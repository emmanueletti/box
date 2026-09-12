#!/bin/bash

set -euo pipefail

ARCH_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🐧 box: running arch install"

"${ARCH_ROOT}/modules/01-preflight/all.sh"
"${ARCH_ROOT}/modules/02-packages/all.sh"
"${ARCH_ROOT}/modules/03-configs/all.sh"
"${ARCH_ROOT}/modules/04-system/all.sh"
"${ARCH_ROOT}/modules/05-fixes/all.sh"
