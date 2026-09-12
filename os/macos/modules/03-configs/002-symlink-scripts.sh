#!/usr/bin/env bash
#
# Symlinks the box-* machine scripts into ~/.local/bin/box-scripts as one link,
# so a new script appears on PATH immediately -- no re-stow needed. Safe only
# because ~/.local/bin/box-scripts is box-exclusive; nothing else writes there.

set -euo pipefail

stow --restow --ignore='\.DS_Store$' --dir="${BOX_ROOT}" --target="$HOME" scripts

echo "✅ box: scripts linked"
