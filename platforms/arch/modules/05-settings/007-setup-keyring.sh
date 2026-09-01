#!/usr/bin/env bash
#
# Writes an unencrypted default keyring so gnome-keyring never needs an
# unlock prompt, then strips any encrypted-login-keyring PAM hook that would
# fight it -- covers raw TTY login (not wired in by default, stays safe if
# that changes by hand) and SDDM (wires it in out of the box, if ever added).

set -euo pipefail

keyring_dir="$HOME/.local/share/keyrings"
keyring_file="$keyring_dir/Default_keyring.keyring"
default_file="$keyring_dir/default"

mkdir -p "$keyring_dir"

cat >"$keyring_file" <<EOF
[keyring]
display-name=Default keyring
ctime=$(date +%s)
mtime=0
lock-on-idle=false
lock-after=false
EOF

echo "Default_keyring" >"$default_file"

chmod 700 "$keyring_dir"
chmod 600 "$keyring_file"
chmod 644 "$default_file"

if [[ -f /etc/pam.d/login ]]; then
  sudo sed -i '/pam_gnome_keyring\.so/d' /etc/pam.d/login
fi

if [[ -f /etc/pam.d/sddm ]]; then
  sudo sed -i '/pam_gnome_keyring\.so/d' /etc/pam.d/sddm
fi

echo "✅ box: unencrypted default keyring set up"
