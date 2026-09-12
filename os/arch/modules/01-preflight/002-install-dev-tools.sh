#!/usr/bin/env bash

set -euo pipefail

if command -v gcc >/dev/null 2>&1 && command -v make >/dev/null 2>&1; then
  echo "✅ box: dev tools already installed"
  exit 0
fi

echo "box: installing dev tools"
sudo pacman -S --needed --noconfirm base-devel

echo "✅ box: dev tools installed"
