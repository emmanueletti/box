#!/usr/bin/env bash

set -euo pipefail

if ! command -v podman >/dev/null 2>&1; then
  echo "box: podman not installed, skipping"
  exit 0
fi

systemctl --user enable --now podman.socket

# Rootless podman cannot bind below 1024 due to legacy linux reasons.
# Tools like DDEV's router needs 80/443
sudo tee /etc/sysctl.d/99-podman-unprivileged-ports.conf >/dev/null <<'EOF'
net.ipv4.ip_unprivileged_port_start=80
EOF

sudo sysctl -q net.ipv4.ip_unprivileged_port_start=80

echo "✅ box: podman ready"
