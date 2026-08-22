#!/usr/bin/env bash
#
# Installs man, so the rest of the install (and you) can read man pages.

set -euo pipefail

if command -v man >/dev/null 2>&1; then
  echo "✅ box: man already installed"
  exit 0
fi

echo "box: installing man"
sudo pacman -S --needed --noconfirm man-db man-pages

echo "✅ box: man installed"
