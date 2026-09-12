#!/usr/bin/env bash

set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
  echo "box: docker not installed, skipping"
  exit 0
fi

sudo systemctl enable --now docker.service

if ! id -nG "$(id -un)" | grep -qw docker; then
  sudo usermod -aG docker "$(id -un)"
  echo "box: added $(id -un) to the docker group -- log out and back in for it to take effect"
fi

echo "✅ box: docker ready"
