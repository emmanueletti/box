#!/usr/bin/env bash
#
# Symlinks the box-* machine scripts into ~/.local/bin.

set -euo pipefail

"${BOX_ROOT}/lib/stow.sh" "${BOX_ROOT}" scripts

echo "✅ box: scripts linked"
