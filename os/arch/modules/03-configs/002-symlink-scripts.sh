#!/usr/bin/env bash

set -euo pipefail

stow --restow --ignore='\.DS_Store$' --dir="${BOX_ROOT}" --target="$HOME" scripts

echo "✅ box: scripts linked"
