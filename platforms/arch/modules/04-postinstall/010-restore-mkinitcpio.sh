#!/usr/bin/env bash
#
# Re-enables the mkinitcpio pacman hooks disabled by preflight, then runs a
# full regen since every package install in between skipped it.

set -euo pipefail

hook_dir=/usr/share/libalpm/hooks

for hook in 90-mkinitcpio-install.hook 60-mkinitcpio-remove.hook; do
  if [[ -f "${hook_dir}/${hook}.disabled" ]]; then
    sudo mv "${hook_dir}/${hook}.disabled" "${hook_dir}/${hook}"
  fi
done

sudo mkinitcpio -P

echo "✅ box: mkinitcpio hooks restored"
