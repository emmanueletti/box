#!/usr/bin/env bash
#
# Arch Linux install. Run via the root install.sh, not directly.

set -euo pipefail

ARCH_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🐧 box: running arch install"

"${ARCH_ROOT}/modules/01-preflight/setup.sh"
"${ARCH_ROOT}/modules/02-packages/setup.sh"
