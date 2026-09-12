#!/usr/bin/env bash

set -euo pipefail

ARCH_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🐧 box: running arch install"

"${ARCH_ROOT}/modules/01-preflight/setup.sh"
"${ARCH_ROOT}/modules/02-packages/setup.sh"
"${ARCH_ROOT}/modules/03-configs/setup.sh"
"${ARCH_ROOT}/modules/04-system/setup.sh"
"${ARCH_ROOT}/modules/05-fixes/setup.sh"
