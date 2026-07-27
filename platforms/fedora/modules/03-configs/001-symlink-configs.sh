#!/usr/bin/env bash
#
# Symlinks every app config into $HOME, shared first then the Fedora-only ones.

set -euo pipefail

"${BOX_ROOT}/lib/stow.sh" "${BOX_ROOT}/platforms/shared/configs"
"${BOX_ROOT}/lib/stow.sh" "${BOX_ROOT}/platforms/fedora/configs"

echo "✅ box: configs linked"
