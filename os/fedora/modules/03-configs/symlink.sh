#!/bin/bash

set -euo pipefail

( cd "${BOX_ROOT}/doots" && stow --restow --no-folding --ignore='\.DS_Store$' --dir=. --target="$HOME" */ )
echo "✅ box: configs linked"

stow --restow --dir="${BOX_ROOT}" --target="$HOME" scripts
echo "✅ box: scripts linked"
