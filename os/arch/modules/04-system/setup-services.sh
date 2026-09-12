#!/bin/bash

set -euo pipefail

services=(
  NetworkManager.service
  bluetooth.service
  power-profiles-daemon.service
  man-db.timer
)

for service in "${services[@]}"; do
  if ! systemctl list-unit-files "$service" >/dev/null 2>&1; then
    echo "⚠️ box: $service not installed, skipping"
    continue
  fi

  sudo systemctl enable --now "$service"
done

echo "✅ box: session services enabled"
