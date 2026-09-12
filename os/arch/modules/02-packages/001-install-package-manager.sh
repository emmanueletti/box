#!/usr/bin/env bash

set -euo pipefail

if command -v yay >/dev/null 2>&1; then
  echo "✅ box: yay already installed"
  exit 0
fi

echo "box: installing yay"

build_dir=$(mktemp -d)
trap 'rm -rf "$build_dir"' EXIT

git clone --depth 1 https://aur.archlinux.org/yay.git "$build_dir"
(cd "$build_dir" && makepkg -si)

echo "✅ box: yay installed"
