#!/usr/bin/env bash
#
# Postinstall module. Runs its numbered steps in order.

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🍎 box: postinstall"

for step in "${MODULE_ROOT}"/[0-9]*.sh; do
  "$step"
done
