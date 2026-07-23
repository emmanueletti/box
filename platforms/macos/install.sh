#!/usr/bin/env bash
#
# macOS install.

set -euo pipefail

MACOS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🍎 box: running macos install"

# Ask for the password once, then keep the sudo timestamp warm so no step below
# stops to prompt. The loop exits with this process.
sudo -v
trap 'sudo -k' EXIT

while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" 2>/dev/null || exit
done 2>/dev/null &

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
