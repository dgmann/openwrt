#!/usr/bin/env bash

echo "Adding Packages: ${PACKAGES}"

echo "Adapting .config"
sed -i "${CONFIG}" .config
echo "::debug::.config:"
echo "::debug::$(cat .config)"
make image PACKAGES="${PACKAGES}" FILES="files"
