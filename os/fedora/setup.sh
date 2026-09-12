#!/bin/bash

set -euo pipefail

FEDORA_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🎩 box: running fedora install"

"${FEDORA_ROOT}/modules/01-preflight/all.sh"
"${FEDORA_ROOT}/modules/02-packages/all.sh"
"${FEDORA_ROOT}/modules/03-configs/all.sh"
"${FEDORA_ROOT}/modules/04-system/all.sh"
"${FEDORA_ROOT}/modules/05-fixes/all.sh"
