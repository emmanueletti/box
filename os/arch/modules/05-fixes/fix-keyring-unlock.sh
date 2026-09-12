#!/bin/bash

set -euo pipefail

pam_file="/etc/pam.d/login"

if [[ ! -f $pam_file ]]; then
  echo "box: no $pam_file, skipping keyring unlock fix"
  exit 0
fi

if grep -qF "pam_gnome_keyring.so" "$pam_file"; then
  echo "✅ box: keyring unlock already wired into login"
else
  sudo sed -i \
    -e '/^auth[[:space:]]\+include[[:space:]]\+system-local-login$/a auth       optional     pam_gnome_keyring.so' \
    -e '/^session[[:space:]]\+include[[:space:]]\+system-local-login$/a session    optional     pam_gnome_keyring.so auto_start' \
    "$pam_file"

  if ! grep -qF "pam_gnome_keyring.so" "$pam_file"; then
    echo "❌ box: could not wire pam_gnome_keyring into $pam_file, add it by hand" >&2
    exit 1
  fi

  echo "✅ box: login now unlocks the gnome keyring"
fi

echo "box: tty autologin skips the password prompt, so the keyring must have an empty password."
echo "     when an app first asks you to create the login keyring, leave the password empty."
echo "     already created one with a password? rm ~/.local/share/keyrings/login.keyring"
echo "     (deletes anything stored in it) and let the next prompt recreate it empty."
