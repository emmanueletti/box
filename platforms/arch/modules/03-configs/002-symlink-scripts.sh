#!/usr/bin/env bash
#
# Symlinks the box-* machine scripts into ~/.local/scripts.

set -euo pipefail

"${BOX_ROOT}/lib/stow.sh" "${BOX_ROOT}/platforms/shared" scripts

echo "✅ box: scripts linked"
