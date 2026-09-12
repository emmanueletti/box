#!/bin/bash

set -euo pipefail

if [[ -x "$HOME/.local/bin/claude" ]]; then
  echo "✅ box: claude code already installed"
  exit 0
fi

echo "box: installing claude code"

curl -fsSL https://claude.ai/install.sh | bash

echo "✅ box: claude code installed"
