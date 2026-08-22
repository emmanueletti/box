#!/usr/bin/env bash
#
# Adds app-launcher entries for TUIs installed by 02-packages. wiremix has
# no icon anywhere upstream (checked its repo and dashboardicons.com) --
# omarchy skips a launcher tile for it and binds it to a keypress instead.
# Add it by hand with box-tui-install if you source an icon later.

set -euo pipefail

icons="${BOX_ROOT}/platforms/arch/icons"

box-tui-install "Docker" "lazydocker" tile "${icons}/docker.png"
box-tui-install "Bluetooth" "bluetui" float "${icons}/bluetooth.png"
box-tui-install "Btop" "btop" tile "${icons}/btop.png"
box-tui-install "WiFi" "impala" float "${icons}/wifi.svg"

echo "✅ box: TUI launchers installed"
