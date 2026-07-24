#!/usr/bin/env bash

set -euo pipefail

if ! command -v podman >/dev/null 2>&1; then
  echo "box: podman not installed, skipping"
  exit 0
fi

systemctl --user enable --now podman.socket
