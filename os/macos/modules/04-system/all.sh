#!/usr/bin/env bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 box: 04-system"

"${MODULE_ROOT}/install-runtimes.sh"
"${MODULE_ROOT}/setup-project-dirs.sh"
"${MODULE_ROOT}/hush-login.sh"
"${MODULE_ROOT}/install-ghostty-terminfo.sh"
"${MODULE_ROOT}/link-nextdns-ip.sh"
"${MODULE_ROOT}/change-shell.sh"
"${MODULE_ROOT}/setup-dock.sh"
"${MODULE_ROOT}/setup-finder.sh"
"${MODULE_ROOT}/setup-keyboard.sh"
"${MODULE_ROOT}/setup-defaults.sh"
"${MODULE_ROOT}/setup-screen.sh"
"${MODULE_ROOT}/remap-right-option.sh"
"${MODULE_ROOT}/setup-wallpaper.sh"
"${MODULE_ROOT}/screenshot-clipboard.sh"
"${MODULE_ROOT}/link-1password-ssh-socket.sh"
