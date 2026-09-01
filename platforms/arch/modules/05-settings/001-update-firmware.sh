#!/usr/bin/env bash

set -euo pipefail

if ! command -v fwupdmgr >/dev/null 2>&1; then
  echo "box: fwupdmgr not found, skipping"
  exit 0
fi

read -r -p "box: check and apply firmware updates? [y/N] " reply

if [[ $reply != "y" ]]; then
  echo "box: firmware unchanged"
  exit 0
fi

sudo fwupdmgr refresh --force || true
sudo fwupdmgr get-updates || true
sudo fwupdmgr update -y || true
