#!/usr/bin/env bash

echo "Adding Packages: ${PACKAGES}"

sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=150/' .config
make image PACKAGES="${PACKAGES}" FILES="files"
