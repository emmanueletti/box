#!/bin/bash

set -euo pipefail

cpu="$("${BOX_SCRIPTS_DIR:-$HOME/box/scripts/.local/bin/box-scripts}/lib/cpu-detect")"

if [[ $cpu != "intel" ]]; then
  exit 0
fi

if grep -q 'nvme.noacpi=1' /proc/cmdline; then
  echo "✅ box: nvme.noacpi=1 already set"
  exit 0
fi

echo "⚠️ box: intel board without nvme.noacpi=1"
echo "     some ssds drop off the bus during suspend without it (amd boards must NOT set it)"
echo "     add nvme.noacpi=1 to the kernel command line, then rebuild the boot entry"
