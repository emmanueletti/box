#!/usr/bin/env bash
#
# 0x400 fixes 780M graphical artifacts, 0x10 fixes PSR corruption on external
# monitors -- combined mask covers both known Framework 13 AMD bugs.

set -euo pipefail

# shellcheck source=/dev/null
. "${BOX_ROOT:-$HOME/box}/lib/box-limine-lib.sh"

arg="amdgpu.dcdebugmask=0x410"
conf=/etc/limine-entry-tool.d/box-amdgpu-freeze-fix.conf

if [[ ! -d /sys/module/amdgpu ]]; then
  echo "box: no amdgpu, skipping freeze fix"
  exit 0
fi

if [[ -f $conf ]]; then
  echo "✅ box: amdgpu freeze fix already set"
  exit 0
fi

echo "box: applying amdgpu freeze fix ($arg)"

sudo mkdir -p "$(dirname "$conf")"
echo "KERNEL_CMDLINE[default]+=\" $arg\"" | sudo tee "$conf" >/dev/null

box_limine_regen

echo "✅ box: amdgpu freeze fix set, reboot and check /proc/cmdline to confirm"
