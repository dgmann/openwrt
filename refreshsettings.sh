#!/usr/bin/env bash
#
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# Copy configs
mkdir -p "${SCRIPT_DIR}"/files/etc/config/
scp -O root@192.168.0.4:/etc/config/network "${SCRIPT_DIR}"/files/etc/config/
scp -O root@192.168.0.4:/etc/config/firewall "${SCRIPT_DIR}"/files/etc/config/
#
chmod -R 755 "${SCRIPT_DIR}"/files/etc/config/
