#!/bin/bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 box: 05-fixes"

"${MODULE_ROOT}/fix-fingerprint-keyring-unlock.sh"
"${MODULE_ROOT}/fix-amdgpu-freeze.sh"
