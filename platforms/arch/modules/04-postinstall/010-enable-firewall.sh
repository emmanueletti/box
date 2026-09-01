#!/usr/bin/env bash

set -euo pipefail

if ! command -v ufw >/dev/null 2>&1; then
  echo "box: ufw not installed, skipping"
  exit 0
fi

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo systemctl enable --now ufw.service
sudo ufw --force enable

echo "✅ box: firewall enabled"
