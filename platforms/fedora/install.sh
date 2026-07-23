#!/usr/bin/env bash
#
# Fedora install.

set -euo pipefail

FEDORA_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🎩 box: running fedora install"

"${FEDORA_ROOT}/modules/01-preflight/setup.sh"
"${FEDORA_ROOT}/modules/02-packages/setup.sh"
"${FEDORA_ROOT}/modules/03-configs/setup.sh"
"${FEDORA_ROOT}/modules/04-postinstall/setup.sh"
"${FEDORA_ROOT}/modules/05-settings/setup.sh"
