#!/usr/bin/env bash

set -euo pipefail

if ! command -v flameshot >/dev/null 2>&1; then
  echo "box: flameshot not installed, skipping"
  exit 0
fi

autostart="${HOME}/.config/autostart"
mkdir -p "$autostart"
cat > "${autostart}/flameshot.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=Flameshot
Exec=flameshot
X-GNOME-Autostart-enabled=true
EOF

schema=org.gnome.settings-daemon.plugins.media-keys
kb_path=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot/

current=$(gsettings get "$schema" custom-keybindings)
if [[ $current == "@as []" || $current == "[]" ]]; then
  gsettings set "$schema" custom-keybindings "['$kb_path']"
elif [[ $current != *"$kb_path"* ]]; then
  gsettings set "$schema" custom-keybindings "${current%]*}, '$kb_path']"
fi

binding="${schema}.custom-keybinding:${kb_path}"
gsettings set "$binding" name "Flameshot"
gsettings set "$binding" command 'sh -c "QT_QPA_PLATFORM=wayland flameshot gui"'
gsettings set "$binding" binding "Print"

gsettings set org.gnome.shell.keybindings show-screenshot-ui "[]"

echo "✅ box: flameshot autostart + Print keybind set"
