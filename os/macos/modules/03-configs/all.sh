#!/usr/bin/env bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 box: 03-configs"

"${MODULE_ROOT}/symlink.sh"
