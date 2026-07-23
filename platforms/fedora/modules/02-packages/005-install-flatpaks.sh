#!/usr/bin/env bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mapfile -t apps < <(grep . "${MODULE_ROOT}/flatpaks.list")

flatpak remote-add --if-not-exists --user \
  flathub https://flathub.org/repo/flathub.flatpakrepo

for app in "${apps[@]}"; do
  flatpak install -y --user flathub "$app" || echo "⚠️ box: could not install $app"
done
