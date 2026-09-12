#!/bin/bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 box: 01-preflight"

"${MODULE_ROOT}/guard.sh"
"${MODULE_ROOT}/install-dev-tools.sh"
"${MODULE_ROOT}/install-stow.sh"
