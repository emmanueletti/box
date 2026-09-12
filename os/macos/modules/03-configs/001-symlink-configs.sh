#!/usr/bin/env bash
#
# Symlinks every app config into $HOME.

set -euo pipefail

( cd "${BOX_ROOT}/doots" && stow --restow --no-folding --ignore='\.DS_Store$' --dir=. --target="$HOME" */ )

echo "✅ box: configs linked"
