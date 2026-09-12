#!/usr/bin/env bash

set -euo pipefail

if command -v stow >/dev/null 2>&1; then
  echo "✅ box: stow already installed"
  exit 0
fi

echo "box: installing stow"
sudo dnf install -y stow

echo "✅ box: stow installed"
