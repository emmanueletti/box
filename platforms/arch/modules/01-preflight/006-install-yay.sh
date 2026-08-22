#!/usr/bin/env bash
#
# Bootstraps yay, the AUR helper. Nothing else can install it -- it's AUR-only
# itself -- so this builds it by hand via makepkg.

set -euo pipefail

if command -v yay >/dev/null 2>&1; then
  echo "✅ box: yay already installed"
  exit 0
fi

echo "box: installing yay"

build_dir="$(mktemp -d)"
trap 'rm -rf "$build_dir"' EXIT

git clone --depth 1 https://aur.archlinux.org/yay.git "$build_dir"
(cd "$build_dir" && makepkg -si --noconfirm)

echo "✅ box: yay installed"
