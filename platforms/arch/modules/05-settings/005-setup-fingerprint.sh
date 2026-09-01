#!/usr/bin/env bash

set -euo pipefail

if ! command -v fprintd-enroll >/dev/null 2>&1; then
  echo "box: fprintd not installed, skipping"
  exit 0
fi

read -r -p "box: set up fingerprint auth now? [y/N] " reply

if [[ $reply != "y" ]]; then
  echo "box: run box-fingerprint-setup later to enroll"
  exit 0
fi

box-fingerprint-setup
