#!/usr/bin/env bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 box: 02-packages"

"${MODULE_ROOT}/install-packages.sh"
"${MODULE_ROOT}/install-idb-companion.sh"
