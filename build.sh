#!/usr/bin/env bash

echo "Adding Packages: ${PACKAGES}"

sed -i "${CONFIG}" .config
make image PACKAGES="${PACKAGES}" FILES="files"

mv bin/targets/armvirt/64/*-default-rootfs.tar.gz bin/targets/armvirt/64/default-rootfs.tar.gz
mv bin/targets/armvirt/64/*rootfs-squashfs.img.gz bin/targets/armvirt/64/rootfs-squashfs.img.gz 
mv bin/targets/armvirt/64/*Image bin/targets/armvirt/64/Image