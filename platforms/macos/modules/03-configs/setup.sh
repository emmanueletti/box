#!/usr/bin/env bash
#
# Configs module. Runs its numbered steps in order.

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export BOX_ROOT="${BOX_ROOT:-$(cd "${MODULE_ROOT}/../../../.." && pwd)}"

echo "📦 box: configs"

for step in "${MODULE_ROOT}"/[0-9]*.sh; do
  "$step"
done
