#!/usr/bin/env bash

set -euo pipefail

stow --restow --dir="${BOX_ROOT}" --target="$HOME" scripts

echo "✅ box: scripts linked"
