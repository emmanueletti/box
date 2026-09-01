#!/usr/bin/env bash
#
# Shared helper for scripts that drop a kernel-cmdline config under
# /etc/limine-entry-tool.d/ and need the boot entry regenerated. Source, do
# not execute.

# Regenerates limine.conf via limine-mkinitcpio, then re-signs it if secure
# boot config-locking is on -- otherwise a stale checksum leaves the system
# unbootable next reboot. See ArchWiki Limine#Configurations.
box_limine_regen() {
  command -v limine-mkinitcpio >/dev/null 2>&1 || return 0

  sudo limine-mkinitcpio

  if grep -qs "ENABLE_ENROLL_LIMINE_CONFIG=yes" /etc/default/limine 2>/dev/null \
    && command -v limine-enroll-config >/dev/null 2>&1; then
    sudo limine-enroll-config
  fi
}
