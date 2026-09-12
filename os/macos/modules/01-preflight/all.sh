#!/usr/bin/env bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 box: 01-preflight"

"${MODULE_ROOT}/install-xcode.sh"
"${MODULE_ROOT}/install-rosetta.sh"
"${MODULE_ROOT}/install-homebrew.sh"
"${MODULE_ROOT}/install-stow.sh"
"${MODULE_ROOT}/sudo-with-touch-id.sh"
"${MODULE_ROOT}/close-system-settings.sh"
