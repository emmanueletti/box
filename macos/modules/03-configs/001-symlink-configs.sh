#!/usr/bin/env bash
#
# Symlinks every app config into $HOME.

set -euo pipefail

"${BOX_ROOT}/lib/stow.sh" "${BOX_ROOT}/configs"

echo "✅ box: configs linked"
