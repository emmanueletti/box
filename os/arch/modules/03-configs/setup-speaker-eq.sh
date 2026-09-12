#!/bin/bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

preset_dir="${XDG_CONFIG_HOME:-$HOME/.config}/easyeffects/output"
preset="${preset_dir}/framework13.json"

if [[ ! -f /sys/class/dmi/id/product_name ]] || ! grep -qi 'Laptop 13' /sys/class/dmi/id/product_name; then
  echo "box: not a framework laptop 13, skipping speaker eq"
  exit 0
fi

if [[ -f $preset ]]; then
  echo "✅ box: speaker eq preset already installed"
  exit 0
fi

install -Dm644 "${MODULE_ROOT}/assets/easyeffects-framework13.json" "$preset"

echo "✅ box: speaker eq preset installed"
echo "     open easyeffects once, pick the 'framework13' output preset, and tick 'load on startup'"
