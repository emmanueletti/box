#!/usr/bin/env bash
#
# Adds app-launcher entries for TUIs installed by 02-packages. impala and
# wiremix have no icon anywhere upstream (checked their repos and
# dashboardicons.com) -- omarchy skips launcher tiles for these and binds
# them to keypresses instead. Add them by hand with box-tui-install if you
# source an icon later.

set -euo pipefail

box-tui-install "Docker" "lazydocker" tile \
  "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/docker.png"

box-tui-install "Bluetooth" "bluetui" float \
  "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/bluetooth.png"

box-tui-install "Btop" "btop" float \
  "https://github.com/aristocratos/btop/raw/main/Img/logo.png"

echo "✅ box: TUI launchers installed"
