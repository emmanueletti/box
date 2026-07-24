#!/usr/bin/env bash

set -euo pipefail

arg="amdgpu.dcdebugmask=0x410"

if [[ ! -d /sys/module/amdgpu ]]; then
  echo "box: no amdgpu, skipping freeze fix"
  exit 0
fi

if sudo grubby --info=DEFAULT 2>/dev/null | grep -qF "$arg"; then
  echo "✅ box: amdgpu freeze fix already set"
  exit 0
fi

echo "box: applying amdgpu freeze fix ($arg)"
sudo grubby --update-kernel=ALL --args="$arg"

echo "✅ box: amdgpu freeze fix set, reboot to apply"
