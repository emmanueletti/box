#!/usr/bin/env bash

set -euo pipefail

if ! command -v xdg-user-dirs-update >/dev/null 2>&1; then
  echo "box: xdg-user-dirs not installed, skipping"
  exit 0
fi

xdg-user-dirs-update

echo "✅ box: user dirs created"
