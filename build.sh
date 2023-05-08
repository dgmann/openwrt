#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PACKAGES="luci adguardhome htop irqbalance kmod-wireguard luci-app-bcp38 luci-app-sqm luci-app-wireguard luci-proto-wireguard sqm-scripts wireguard-tools luci-app-acme acme-dnsapi"

mkdir -p "${SCRIPT_DIR}"/files/usr/bin/

wget -O "${SCRIPT_DIR}"/files/usr/bin/netclient https://github.com/gravitl/netclient/releases/download/v0.18.7/netclient-linux-arm64 && \
    chmod +x "${SCRIPT_DIR}"/files/usr/bin/netclient

wget -O "${SCRIPT_DIR}"/files/usr/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/download/2023.1.0/cloudflared-linux-arm64 && \
    chmod +x "${SCRIPT_DIR}"/files/usr/bin/cloudflared

mkdir "${SCRIPT_DIR}"/bin/
IMAGE=openwrt/imagebuilder:armvirt-64-openwrt-22.03
podman pull "$IMAGE"
podman run --rm -it \
    -v "${SCRIPT_DIR}"/bin/:/builder/bin:z \
    -v "${SCRIPT_DIR}"/files/:/builder/files:z \
    -v "${SCRIPT_DIR}"/.config:/builder/.config:z \
    "$IMAGE" make image PACKAGES="${PACKAGES}" FILES="files"
