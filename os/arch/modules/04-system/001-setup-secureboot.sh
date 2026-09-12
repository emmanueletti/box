#!/usr/bin/env bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v sbctl >/dev/null 2>&1; then
  echo "box: installing sbctl"
  sudo pacman -S --needed --noconfirm sbctl
fi

if [[ ! -d /usr/share/secureboot/keys ]]; then
  echo "box: generating secure boot keys"
  sudo sbctl create-keys
fi

if ! sudo sbctl status | grep -q "Secure Boot:.*Enabled"; then
  echo "box: secure boot keys not enrolled yet, see README.md"
  exit 0
fi

for efi in /boot/EFI/BOOT/BOOTX64.EFI /boot/EFI/limine/BOOTX64.EFI /boot/limine/BOOTX64.EFI; do
  [[ -f $efi ]] && sudo sbctl sign -s "$efi"
done

sudo sbctl sign-all

sudo install -Dm644 "${MODULE_ROOT}/sbctl-resign.hook" /etc/pacman.d/hooks/zz-sbctl-resign.hook

echo "✅ box: secure boot enrolled and signed with your own keys"
