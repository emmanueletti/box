#!/bin/bash

set -euo pipefail

conf_dir="/etc/systemd/logind.conf.d"
conf_file="${conf_dir}/99-power-key.conf"

if [[ -f $conf_file ]]; then
  echo "✅ box: power key already handed to the compositor"
  exit 0
fi

sudo install -d "$conf_dir"
sudo tee "$conf_file" >/dev/null <<'EOF'
[Login]
HandlePowerKey=ignore
HandlePowerKeyLongPress=poweroff
EOF

echo "✅ box: power key handed to the compositor, long press still powers off"
echo "     takes effect after a reboot"
