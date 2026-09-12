#!/usr/bin/env bash

set -euo pipefail

sudo ufw --force enable

if command -v ufw-docker >/dev/null 2>&1; then
  sudo ufw-docker install
  sudo systemctl restart ufw
fi

echo "✅ box: firewall configured"
