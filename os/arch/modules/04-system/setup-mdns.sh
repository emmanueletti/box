#!/bin/bash

set -euo pipefail

nsswitch="/etc/nsswitch.conf"

if ! systemctl list-unit-files avahi-daemon.service >/dev/null 2>&1; then
  echo "box: avahi not installed, skipping"
  exit 0
fi

sudo systemctl enable --now avahi-daemon.service

if grep -q "mdns_minimal" "$nsswitch"; then
  echo "✅ box: mdns already in $nsswitch"
  exit 0
fi

if ! grep -q "^hosts:" "$nsswitch"; then
  echo "⚠️ box: no hosts line in $nsswitch, wire mdns_minimal in by hand"
  exit 0
fi

backup="${nsswitch}.box.bak"
sudo cp "$nsswitch" "$backup"

if grep -qE "^hosts:.*\bresolve\b" "$nsswitch"; then
  anchor="resolve"
else
  anchor="files"
fi

sudo sed -i "/^hosts:/ s/\b${anchor}\b/mdns_minimal [NOTFOUND=return] ${anchor}/" "$nsswitch"

if ! grep -q "mdns_minimal" "$nsswitch" || ! getent hosts localhost >/dev/null 2>&1; then
  sudo cp "$backup" "$nsswitch"
  echo "❌ box: mdns edit broke name resolution, restored $nsswitch from $backup" >&2
  exit 1
fi

sudo rm -f "$backup"

echo "✅ box: mdns resolution enabled (.local hostnames)"
