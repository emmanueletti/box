#!/usr/bin/env bash
#
# Fixes GNOME keyring not unlocking when you log in via fingerprint instead of
# password.

set -euo pipefail

pam_file="/etc/pam.d/gdm-fingerprint"

if [[ ! -f $pam_file ]]; then
  echo "box: no $pam_file, skipping fingerprint keyring fix"
  exit 0
fi

if grep -qF "pam_gnome_keyring.so auto_start" "$pam_file"; then
  echo "✅ box: fingerprint keyring autostart already set"
else
  sudo sed -i "/^session[[:space:]]\+include[[:space:]]\+fingerprint-auth\$/a session     optional      pam_gnome_keyring.so auto_start" "$pam_file"
  echo "✅ box: fingerprint login now auto-starts the keyring daemon"
fi

echo "box: for no keyring prompt at all, blank the login keyring password (Passwords and Keys > Login > Change Password, leave new password blank)"
