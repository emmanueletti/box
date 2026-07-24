#!/usr/bin/env bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mapfile -t apps < <(grep . "${MODULE_ROOT}/flatpaks.list")

sudo flatpak remote-add --if-not-exists --system \
  flathub https://flathub.org/repo/flathub.flatpakrepo

for app in "${apps[@]}"; do
  sudo flatpak install -y --system flathub "$app" || echo "⚠️ box: could not install $app"
done
