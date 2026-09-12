#!/bin/bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 box: 02-packages"

"${MODULE_ROOT}/enable-terra.sh"
"${MODULE_ROOT}/enable-rpmfusion.sh"
"${MODULE_ROOT}/enable-vendor-repos.sh"
"${MODULE_ROOT}/install-dnf-packages.sh"
"${MODULE_ROOT}/install-codecs.sh"
"${MODULE_ROOT}/install-flatpaks.sh"
"${MODULE_ROOT}/install-fonts.sh"
