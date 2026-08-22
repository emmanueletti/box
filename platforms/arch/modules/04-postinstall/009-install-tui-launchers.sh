#!/usr/bin/env bash
#
# Adds app-launcher entries for TUIs installed by 02-packages. btop, impala,
# and wiremix have no icon at dashboardicons.com yet -- add them by hand
# with box-tui-install once you've got icons for them.

set -euo pipefail

box-tui-install "Docker" "lazydocker" tile \
  "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/docker.png"

box-tui-install "Bluetooth" "bluetui" float \
  "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/bluetooth.png"

echo "✅ box: TUI launchers installed"
