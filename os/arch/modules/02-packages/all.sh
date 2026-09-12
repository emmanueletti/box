#!/bin/bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 box: 02-packages"

"${MODULE_ROOT}/install-package-manager.sh"
"${MODULE_ROOT}/install-pacman-packages.sh"
"${MODULE_ROOT}/install-aur-packages.sh"
"${MODULE_ROOT}/install-claude-code.sh"
