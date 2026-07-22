#!/usr/bin/env bash
#
# Installs Rosetta 2, so intel-only binaries run on apple silicon.

set -euo pipefail

if [[ $(uname -m) != "arm64" ]]; then
  exit 0
fi

if pgrep -q oahd; then
  echo "✅ box: rosetta already installed"
  exit 0
fi

echo "box: installing rosetta"
softwareupdate --install-rosetta --agree-to-license

echo "✅ box: rosetta installed"
