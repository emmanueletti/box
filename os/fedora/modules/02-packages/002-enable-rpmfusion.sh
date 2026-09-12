#!/usr/bin/env bash

set -euo pipefail

if rpm -q rpmfusion-free-release >/dev/null 2>&1; then
  echo "✅ box: rpmfusion already enabled"
  exit 0
fi

ver=$(rpm -E %fedora)

sudo dnf install -y \
  "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${ver}.noarch.rpm" \
  "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${ver}.noarch.rpm"
