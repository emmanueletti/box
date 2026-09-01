#!/usr/bin/env bash
#
# Settings module. Runs its numbered steps in order.

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${MODULE_ROOT}/../../../../lib/box-env.sh"

echo "📦 box: settings"

for step in "${MODULE_ROOT}"/[0-9]*.sh; do
  "$step"
done
