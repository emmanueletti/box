#!/usr/bin/env bash

set -euo pipefail

zsh_path="$(command -v zsh || true)"

if [[ -z $zsh_path ]]; then
  echo "box: zsh not found, skipping"
  exit 0
fi

current="$(getent passwd "$USER" | awk -F: '{print $NF}')"

if [[ $current == "$zsh_path" ]]; then
  echo "✅ box: zsh already default shell"
  exit 0
fi

sudo chsh -s "$zsh_path" "$USER"
echo "box: default shell set to zsh, log out and back in to apply"
