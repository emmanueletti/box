#!/bin/bash

set -euo pipefail

if ! pacman -Qq amd-ucode >/dev/null 2>&1; then
  echo "box: amd-ucode not installed, skipping microcode check"
  exit 0
fi

if ! grep -qE '^HOOKS=.*\bmicrocode\b' /etc/mkinitcpio.conf; then
  echo "⚠️ box: no 'microcode' hook in /etc/mkinitcpio.conf, so cpu microcode is not loaded at boot"
  echo "     add microcode to the HOOKS array, then: sudo mkinitcpio -P"
  exit 0
fi

for image in /boot/initramfs-linux*.img; do
  [[ -f $image ]] || continue

  if ! sudo lsinitcpio --early "$image" 2>/dev/null | grep -q AuthenticAMD.bin; then
    echo "⚠️ box: ${image} carries no microcode, rebuild it: sudo mkinitcpio -P"
    exit 0
  fi
done

echo "✅ box: cpu microcode loads at boot"
