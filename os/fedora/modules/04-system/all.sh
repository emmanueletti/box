#!/bin/bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 box: 04-system"

"${MODULE_ROOT}/update-firmware.sh"
"${MODULE_ROOT}/set-default-shell.sh"
"${MODULE_ROOT}/install-runtimes.sh"
"${MODULE_ROOT}/setup-project-dirs.sh"
"${MODULE_ROOT}/setup-docker.sh"
"${MODULE_ROOT}/setup-tailscale.sh"
"${MODULE_ROOT}/setup-clipboard-history.sh"
"${MODULE_ROOT}/setup-wallpaper.sh"
