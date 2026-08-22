#!/usr/bin/env bash
#
# Installs base-devel and git, so mise can compile the runtimes it builds from
# source and the rest of the install can pull from GitHub.

set -euo pipefail

if pacman -Qg base-devel >/dev/null 2>&1 && command -v git >/dev/null 2>&1; then
  echo "✅ box: dev tools already installed"
  exit 0
fi

echo "box: installing dev tools"
sudo pacman -S --needed --noconfirm base-devel git

echo "✅ box: dev tools installed"
