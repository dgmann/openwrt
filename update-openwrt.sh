#!/usr/bin/env bash
# Script to update OpenWRT to latest Kernel and Image.
# Creates a snapshot before updating.
# Backup and Restore of Configuration during update.

set -e

VMID=101
DATE=$(date +"%FT%H%M")
STORAGE=local-btrfs
IMAGE_URL="https://github.com/dgmann/openwrt/releases/latest/download/rootfs-squashfs.img.gz"
KERNEL_URL="https://github.com/dgmann/openwrt/releases/latest/download/Image"
BACKUP_FILE="/mnt/backup/update_${DATE}.tar.gz"
OUTPUT="/tmp/image_${DATE}.img.gz"

echo "Downloading new Image"
wget -q --show-progress -O "$OUTPUT" "$IMAGE_URL"
gunzip "$OUTPUT"
OUTPUT="${OUTPUT%.gz}"

echo "Downloading new Kernel"
CURRENT_KERNEL_FILE=$(qm config "$VMID" --current 1 | grep args | sed -nr 's/^.*-kernel\s+(\S*)\s+.*$/\1/p')
NEW_KERNEL_FILE=$(dirname "$CURRENT_KERNEL_FILE")/kernel_"$DATE"
wget -q --show-progress -O "$NEW_KERNEL_FILE" "$KERNEL_URL"

echo "Backup OpenWRT config"
qm guest exec "$VMID" -- /bin/ash -c "mkdir -p /mnt/backup && mount /dev/vdb /mnt/backup && sysupgrade -b ${BACKUP_FILE} && umount /mnt/backup"

echo "Shutdown VM"
qm shutdown "$VMID" && qm wait "$VMID"
echo "Create Snapshot"
qm snapshot "$VMID" "update_${DATE}" --vmstate false

echo "Update Disk"
qm unlink "$VMID" --idlist virtio0
qm set "$VMID" --virtio0 "$STORAGE":0,import-from="$OUTPUT"
rm $OUTPUT

echo "Update Kernel"
ARGS=$(qm config "$VMID" --current 1 | grep args | cut -d ' ' -f2- | sed "s|$CURRENT_KERNEL_FILE|$NEW_KERNEL_FILE|g")
qm set "$VMID" --args "$ARGS"

echo "Start VM"
qm start "$VMID"
until qm guest cmd "$VMID" ping
do
    echo "Waiting for VM to start..."
    sleep 1
done
echo "Restore Backup"
qm guest exec "$VMID" -- /bin/ash -c "mkdir -p /mnt/backup && mount /dev/vdb /mnt/backup && sysupgrade -r ${BACKUP_FILE} && rm ${BACKUP_FILE} && umount /mnt/backup && reboot"

echo "Done"
