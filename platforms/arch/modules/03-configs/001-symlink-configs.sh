#!/usr/bin/env bash
#
# Symlinks every app config into $HOME, shared first then the Arch-only ones.

set -euo pipefail

"${BOX_ROOT}/lib/stow.sh" "${BOX_ROOT}/platforms/shared/configs"
"${BOX_ROOT}/lib/stow.sh" "${BOX_ROOT}/platforms/arch/configs"

echo "✅ box: configs linked"
