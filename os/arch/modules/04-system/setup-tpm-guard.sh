#!/bin/bash

set -euo pipefail

unit="box-tpm-guard.service"

if [[ ! -f "$HOME/.config/systemd/user/$unit" ]]; then
  echo "⚠️ box: $unit not stowed yet, skipping"
  exit 0
fi

systemctl --user daemon-reload
systemctl --user enable "$unit" >/dev/null

if ! journalctl -b 0 -n 1 >/dev/null 2>&1; then
  echo "⚠️ box: $USER cannot read the system journal, so drift will go undetected"
  echo "   grant it with: sudo usermod -aG systemd-journal $USER"
fi

if ! grep -qs "tpm2-device=" /etc/crypttab; then
  echo "⚠️ box: no TPM2 keyslot in /etc/crypttab, so there is nothing to watch yet"
  echo "   enroll one first:"
  echo "     sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 --tpm2-with-pin=yes <device>"
fi

echo "✅ box: tpm drift guard enabled"
