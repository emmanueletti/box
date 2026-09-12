#!/bin/bash

set -euo pipefail

if command -v gcc >/dev/null 2>&1 && command -v make >/dev/null 2>&1; then
  echo "✅ box: dev tools already installed"
  exit 0
fi

echo "box: installing dev tools"
sudo dnf install -y @development-tools

echo "✅ box: dev tools installed"
