#!/usr/bin/env bash

set -euo pipefail

if ! command -v gpaste-client >/dev/null 2>&1; then
  echo "box: gpaste not installed, skipping clipboard history keybind"
  exit 0
fi

kb_schema="org.gnome.settings-daemon.plugins.media-keys"
kb_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/box-clipboard-history/"

# The keybindings list is a plain gsettings array of dconf paths, so add ours
# only if it is missing -- overwriting would drop whatever else is bound.
existing="$(gsettings get "$kb_schema" custom-keybindings)"
if [[ $existing != *"$kb_path"* ]]; then
  if [[ $existing == "@as []" ]]; then
    updated="['${kb_path}']"
  else
    updated="${existing%]}, '${kb_path}']"
  fi
  gsettings set "$kb_schema" custom-keybindings "$updated"
fi

gsettings set "${kb_schema}.custom-keybinding:${kb_path}" name "Clipboard history"
gsettings set "${kb_schema}.custom-keybinding:${kb_path}" command "gpaste-client show-history"
gsettings set "${kb_schema}.custom-keybinding:${kb_path}" binding "<Control><Shift>v"

echo "✅ box: clipboard history bound to ctrl+shift+v"
