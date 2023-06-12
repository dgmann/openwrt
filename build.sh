#!/usr/bin/env bash

echo "Adding Packages: ${PACKAGES}"

echo "Adapting .config"
sed -i "${CONFIG}" .config
make image PACKAGES="${PACKAGES}" FILES="files"
