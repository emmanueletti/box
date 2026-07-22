#!/usr/bin/env bash
#
# Installs homebrew.

set -euo pipefail

if command -v brew >/dev/null 2>&1; then
  echo "✅ box: homebrew already installed"
  exit 0
fi

echo "box: installing homebrew"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "✅ box: homebrew installed"
