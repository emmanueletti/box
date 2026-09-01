#!/usr/bin/env bash
#
# Re-enables the mkinitcpio pacman hooks disabled by preflight, then runs a
# full regen since every package install in between skipped it.

set -euo pipefail

# shellcheck source=/dev/null
. "${BOX_ROOT:-$HOME/box}/lib/box-limine-lib.sh"

hook_dir=/usr/share/libalpm/hooks

for hook in 90-mkinitcpio-install.hook 60-mkinitcpio-remove.hook; do
  if [[ -f "${hook_dir}/${hook}.disabled" ]]; then
    sudo mv "${hook_dir}/${hook}.disabled" "${hook_dir}/${hook}"
  fi
done

# The regen itself is mandatory (hooks were off, initramfs may be stale) --
# box_limine_regen no-ops without limine-mkinitcpio, so fall back to a plain
# rebuild when that tooling isn't installed.
if command -v limine-mkinitcpio >/dev/null 2>&1; then
  box_limine_regen
else
  sudo mkinitcpio -P
fi

echo "✅ box: mkinitcpio hooks restored"
