#!/usr/bin/env bash

set -euo pipefail

if ! command -v tailscale >/dev/null 2>&1; then
  echo "box: tailscale not installed, skipping"
  exit 0
fi

sudo systemctl enable --now tailscaled

# operator lets this user drive tailscale without sudo
sudo tailscale set --operator="$(id -un)"

if tailscale status >/dev/null 2>&1; then
  echo "✅ box: tailscale connected"
  exit 0
fi

echo "box: run 'tailscale up' to join the tailnet"
