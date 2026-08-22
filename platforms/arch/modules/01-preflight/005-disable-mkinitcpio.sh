#!/usr/bin/env bash
#
# Disables the mkinitcpio pacman hooks so 02-packages doesn't regenerate the
# initramfs on every single package install. Re-enabled at the end of
# postinstall -- if that step is missing, kernel updates won't rebuild the
# initramfs, so it must always have a matching restore.

set -euo pipefail

hook_dir=/usr/share/libalpm/hooks

for hook in 90-mkinitcpio-install.hook 60-mkinitcpio-remove.hook; do
  if [[ -f "${hook_dir}/${hook}" ]]; then
    sudo mv "${hook_dir}/${hook}" "${hook_dir}/${hook}.disabled"
  fi
done

echo "✅ box: mkinitcpio hooks disabled for install"
