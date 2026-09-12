#!/usr/bin/env bash

set -euo pipefail

xdg-user-dirs-update

screenshots="$HOME/Pictures/Screenshots"

xdg-user-dirs-update --set SCREENSHOTS "$screenshots"
mkdir -p "$screenshots"

echo "✅ box: xdg user dirs created"
