#!/usr/bin/env bash
#
# Hard requirements before touching anything: not root, limine bootloader,
# btrfs root filesystem, no pre-existing GNOME or KDE.

set -euo pipefail

if (( EUID == 0 )); then
  echo "❌ box: run as your user, not root" >&2
  exit 1
fi

if ! command -v limine >/dev/null 2>&1; then
  echo "❌ box: limine bootloader required" >&2
  exit 1
fi

if [[ "$(findmnt -n -o FSTYPE /)" != "btrfs" ]]; then
  echo "❌ box: btrfs root filesystem required" >&2
  exit 1
fi

if pacman -Qe gnome-shell >/dev/null 2>&1 || pacman -Qe plasma-desktop >/dev/null 2>&1; then
  echo "❌ box: gnome-shell or plasma-desktop already installed" >&2
  exit 1
fi

echo "✅ box: guards passed"
