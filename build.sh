#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PACKAGES="luci adguardhome htop irqbalance kmod-wireguard luci-app-bcp38 luci-app-sqm luci-app-wireguard luci-proto-wireguard sqm-scripts wireguard-tools luci-app-acme acme-dnsapi luci-ssl-nginx"

# Copy configs
mkdir -p "${SCRIPT_DIR}"/files/etc/config/
scp -O root@192.168.0.4:/etc/config/network "${SCRIPT_DIR}"/files/etc/config/
scp -O root@192.168.0.4:/etc/config/firewall "${SCRIPT_DIR}"/files/etc/config/

chmod -R 755 "${SCRIPT_DIR}"/files/etc/config/

mkdir -p "${SCRIPT_DIR}"/files/usr/bin/

wget -O "${SCRIPT_DIR}"/files/usr/bin/netclient https://github.com/gravitl/netclient/releases/download/v0.18.5/netclient_linux_arm64 && \
    chmod +x "${SCRIPT_DIR}"/files/usr/bin/netclient

wget -O "${SCRIPT_DIR}"/files/usr/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/download/2023.1.0/cloudflared-linux-arm64 && \
    chmod +x "${SCRIPT_DIR}"/files/usr/bin/cloudflared

podman run --rm -it \
    -v "${SCRIPT_DIR}"/bin/:/home/build/openwrt/bin:z \
    -v "${SCRIPT_DIR}"/files/:/home/build/openwrt/files:z \
    openwrtorg/imagebuilder:armvirt-64-22.03.3 make image PACKAGES="${PACKAGES}" FILES="files"
