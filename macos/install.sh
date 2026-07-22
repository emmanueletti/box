#!/usr/bin/env bash
#
# macOS install.

set -euo pipefail

MACOS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🍎 box: running macos install"

"${MACOS_ROOT}/modules/01-preflight/setup.sh"

# Preflight installs brew. Put it on PATH here so every module below inherits it.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

"${MACOS_ROOT}/modules/02-packages/setup.sh"
"${MACOS_ROOT}/modules/03-configs/setup.sh"
"${MACOS_ROOT}/modules/04-postinstall/setup.sh"
"${MACOS_ROOT}/modules/05-settings/setup.sh"
