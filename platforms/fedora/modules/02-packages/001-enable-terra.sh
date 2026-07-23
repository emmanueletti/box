#!/usr/bin/env bash

set -euo pipefail

if dnf repolist --enabled 2>/dev/null | grep -q '^terra'; then
  echo "✅ box: terra already enabled"
  exit 0
fi

sudo dnf install -y --nogpgcheck \
  --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' \
  terra-release terra-gpg-keys
