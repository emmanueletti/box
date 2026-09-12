#!/bin/bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

target="${XDG_CONFIG_HOME:-$HOME/.config}/mimeapps.list"

if [[ -e $target || -L $target ]]; then
  echo "✅ box: default apps already set, leaving ${target} alone"
  exit 0
fi

install -Dm644 "${MODULE_ROOT}/assets/mimeapps.list" "$target"

echo "✅ box: default apps seeded"
