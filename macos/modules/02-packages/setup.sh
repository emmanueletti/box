#!/usr/bin/env bash
#
# Packages module. Runs its numbered steps in order.

set -euo pipefail
shopt -s nullglob

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🍎 box: packages"

for step in "${MODULE_ROOT}"/[0-9]*.sh; do
  "$step"
done
