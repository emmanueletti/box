#!/bin/bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 box: 05-fixes"

"${MODULE_ROOT}/fix-keyring-unlock.sh"
"${MODULE_ROOT}/fix-amd-panel-power.sh"
"${MODULE_ROOT}/fix-intel-nvme-suspend.sh"
