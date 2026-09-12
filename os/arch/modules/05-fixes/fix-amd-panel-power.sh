#!/bin/bash

set -euo pipefail

cpu="$("${BOX_SCRIPTS_DIR:-$HOME/box/scripts/.local/bin/box-scripts}/lib/cpu-detect")"

if [[ $cpu != "amd" ]]; then
  exit 0
fi

drop_in="/etc/systemd/system/power-profiles-daemon.service.d/box-panel-power.conf"

# The blocked daemon stops changing it, but whatever it last wrote sticks.
for panel in /sys/class/drm/*/amdgpu/panel_power_savings; do
  [[ -w $panel ]] || [[ -f $panel ]] || continue
  [[ $(<"$panel") == "0" ]] && continue
  echo 0 | sudo tee "$panel" >/dev/null
done

if [[ -f $drop_in ]]; then
  echo "✅ box: amd panel power saving already blocked"
  exit 0
fi

sudo mkdir -p "$(dirname "$drop_in")"

printf '[Service]\nExecStart=\nExecStart=/usr/lib/power-profiles-daemon --block-action=amdgpu_panel_power\n' \
  | sudo tee "$drop_in" >/dev/null

sudo systemctl daemon-reload
sudo systemctl restart power-profiles-daemon.service

echo "✅ box: amd panel power saving blocked, colors stay true on battery"
