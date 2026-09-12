#!/bin/bash

set -euo pipefail

if [[ ! -f /etc/arch-release ]]; then
  echo "❌ box: arch install requires Arch Linux" >&2
  exit 1
fi

if (( EUID == 0 )); then
  echo "❌ box: arch install must not run as root" >&2
  exit 1
fi

if [[ $(uname -m) != "x86_64" ]]; then
  echo "❌ box: arch install requires x86_64" >&2
  exit 1
fi

if pacman -Qe gnome-shell &>/dev/null || pacman -Qe plasma-desktop &>/dev/null; then
  echo "❌ box: arch install expects a fresh box, not an existing gnome/kde install" >&2
  exit 1
fi

if ! command -v limine >/dev/null 2>&1; then
  echo "❌ box: arch install requires the limine bootloader" >&2
  exit 1
fi

if [[ $(findmnt -n -o FSTYPE /) != "btrfs" ]]; then
  echo "❌ box: arch install requires a btrfs root filesystem" >&2
  exit 1
fi

echo "✅ box: guards ok"
