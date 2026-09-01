#!/usr/bin/env bash

set -euo pipefail

if ! command -v powerprofilesctl >/dev/null 2>&1; then
  echo "box: power-profiles-daemon not installed, skipping"
  exit 0
fi

sudo systemctl enable --now power-profiles-daemon.service

echo "✅ box: power-profiles-daemon enabled"
