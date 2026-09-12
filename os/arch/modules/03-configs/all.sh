#!/bin/bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 box: 03-configs"

"${MODULE_ROOT}/symlink.sh"
"${MODULE_ROOT}/setup-xdg-dirs.sh"
"${MODULE_ROOT}/setup-default-apps.sh"
"${MODULE_ROOT}/setup-speaker-eq.sh"
