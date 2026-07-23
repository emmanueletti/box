#!/usr/bin/env bash
#
# Sets the desktop wallpaper.

set -euo pipefail

read -r -p "box: set the box wallpaper? [y/N] " reply

if [[ $reply != "y" ]]; then
  echo "box: wallpaper unchanged"
  exit 0
fi

box-set-wallpaper \
  "${BOX_ROOT}/assets/wallpapers/light/blue-grid.png" \
  "${BOX_ROOT}/assets/wallpapers/dark/blue-grid.png"
