#!/usr/bin/env bash
#
# bluez isn't in packages.list -- bluetui pulls it in transitively as a
# dependency, same as omarchy relies on. This just turns the daemon on.

set -euo pipefail

if ! command -v bluetoothctl >/dev/null 2>&1; then
  echo "box: bluez not installed, skipping"
  exit 0
fi

sudo systemctl enable --now bluetooth.service

echo "✅ box: bluetooth enabled"
