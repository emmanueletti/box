#!/usr/bin/env bash
#
# Installs GNU stow, used to symlink the dotfiles.

set -euo pipefail

if command -v stow >/dev/null 2>&1; then
  echo "✅ box: stow already installed"
  exit 0
fi

echo "box: installing stow"
sudo dnf install -y stow

echo "✅ box: stow installed"
