#!/usr/bin/env bash
#
# iwd as NetworkManager's backend instead of wpa_supplicant -- reports of
# better stability/throughput on the MT7921/7922 (Framework 13 AMD wifi
# chip) using it. Do not enable iwd.service: NetworkManager starts and
# manages iwd itself when this backend is set.

set -euo pipefail

if ! command -v nmcli >/dev/null 2>&1; then
  echo "box: NetworkManager not installed, skipping"
  exit 0
fi

sudo systemctl enable --now NetworkManager.service

conf=/etc/NetworkManager/conf.d/wifi_backend.conf

if command -v iwd >/dev/null 2>&1 && [[ ! -f $conf ]]; then
  sudo mkdir -p "$(dirname "$conf")"
  cat <<'EOF' | sudo tee "$conf" >/dev/null
[device]
wifi.backend=iwd
EOF
  sudo systemctl reload NetworkManager.service
fi

echo "✅ box: NetworkManager enabled, use nmtui to connect"
