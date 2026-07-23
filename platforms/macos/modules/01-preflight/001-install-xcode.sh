#!/usr/bin/env bash
#
# Installs the Xcode command line tools.

set -euo pipefail

if xcode-select -p >/dev/null 2>&1; then
  echo "✅ box: xcode command line tools already installed"
  exit 0
fi

echo "box: installing xcode command line tools"
xcode-select --install

echo "⚠️ box: finish the xcode dialog, then run install.sh again"
exit 1

