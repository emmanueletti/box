#!/usr/bin/env bash
#
# Sets the desktop wallpaper.

set -euo pipefail

# GNOME stores the wallpaper as an absolute path, so moving box leaves it
# pointing at a file that is gone and the desktop turns black. Only ask when the
# current one still resolves; a broken one just gets repaired.
current="$(gsettings get org.gnome.desktop.background picture-uri)"
current="${current//\'/}"

if [[ -f ${current#file://} ]]; then
  read -r -p "box: set the box wallpaper? [y/N] " reply

  if [[ $reply != "y" ]]; then
    echo "box: wallpaper unchanged"
    exit 0
  fi
fi

"${SCRIPTS_DIR}/box-theme-wallpaper" \
  "${BOX_ROOT}/assets/wallpapers/light/blue-grid.png" \
  "${BOX_ROOT}/assets/wallpapers/dark/blue-grid.png"
