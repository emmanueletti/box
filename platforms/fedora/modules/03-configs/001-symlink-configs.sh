#!/usr/bin/env bash
#
# Symlinks every app config into $HOME.

set -euo pipefail

"${BOX_ROOT}/lib/stow.sh" "${BOX_ROOT}/platforms/shared/configs"

echo "✅ box: configs linked"
