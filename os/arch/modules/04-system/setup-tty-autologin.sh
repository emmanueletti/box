#!/bin/bash

set -euo pipefail

override_dir="/etc/systemd/system/getty@tty1.service.d"

sudo mkdir -p "$override_dir"
sudo tee "$override_dir/autologin.conf" >/dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USER --noclear %I \$TERM
EOF

sudo systemctl daemon-reload
sudo systemctl enable getty@tty1.service >/dev/null
sudo systemctl restart getty@tty1.service

echo "✅ box: tty autologin enabled ($USER on tty1)"
