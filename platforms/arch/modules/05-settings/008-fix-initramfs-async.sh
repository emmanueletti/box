#!/usr/bin/env bash
#
# Kernel 7.1 unpacks the initramfs asynchronously, which races /init: early
# /proc, /sys, /dev, /run mounts fail while unpacking settles, so plymouthd
# exits and encrypted boots fall back to an unthemed text LUKS prompt.

set -euo pipefail

# shellcheck source=/dev/null
. "${BOX_ROOT:-$HOME/box}/lib/box-limine-lib.sh"

conf=/etc/limine-entry-tool.d/box-initramfs-async-fix.conf

if [[ -f $conf ]]; then
  echo "✅ box: initramfs async fix already set"
  exit 0
fi

sudo mkdir -p "$(dirname "$conf")"
echo 'KERNEL_CMDLINE[default]+=" initramfs_async=0"' | sudo tee "$conf" >/dev/null

box_limine_regen

echo "✅ box: initramfs async fix set"
