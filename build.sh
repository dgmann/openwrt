#!/usr/bin/env bash

echo "Adding Packages: ${PACKAGES}"

sed -i "${CONFIG}" .config
make image PACKAGES="${PACKAGES}" FILES="files"
