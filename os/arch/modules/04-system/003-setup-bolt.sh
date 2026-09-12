#!/usr/bin/env bash

set -euo pipefail

sudo systemctl enable --now bolt.service

for security in /sys/bus/thunderbolt/devices/domain*/security; do
  [[ -f $security ]] || continue
  level=$(<"$security")
  if [[ $level != "user" && $level != "secure" ]]; then
    echo "box: thunderbolt security level is '$level', not 'user' or 'secure'"
    echo "box: this is a firmware setting, not something bolt can change -- check your BIOS thunderbolt/USB4 security option"
  fi
done

echo "✅ box: bolt enabled"
