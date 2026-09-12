#!/bin/bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v docker >/dev/null 2>&1; then
  echo "box: docker not installed, skipping"
  exit 0
fi

if ! cmp -s "${MODULE_ROOT}/assets/daemon.json" /etc/docker/daemon.json; then
  sudo install -Dm644 "${MODULE_ROOT}/assets/daemon.json" /etc/docker/daemon.json
  sudo systemctl restart docker.service
fi

sudo systemctl enable --now docker.service

if ! id -nG "$(id -un)" | grep -qw docker; then
  sudo usermod -aG docker "$(id -un)"
  echo "box: added $(id -un) to the docker group -- log out and back in for it to take effect"
fi

echo "✅ box: docker ready, published ports bind to localhost by default"
