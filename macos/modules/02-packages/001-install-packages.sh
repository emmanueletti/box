#!/usr/bin/env bash
#
# Installs everything in the Brewfile.

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  echo "⚠️ box: homebrew not found, skipping"
  exit 0
fi

echo "box: installing packages"

# brew bundle tries every entry and exits non-zero if any failed. A failed
# package should not take the rest of the install down with it.
if brew bundle install --file "${MODULE_ROOT}/Brewfile" --jobs auto; then
  echo "✅ box: packages installed"
else
  echo "⚠️ box: some packages failed, continuing"
fi
