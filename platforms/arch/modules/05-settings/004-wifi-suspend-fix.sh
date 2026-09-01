#!/usr/bin/env bash
#
# MT7921/MT7922 has a chance of rebooting instead of waking from suspend.
# Blocking wifi/bluetooth before sleep and unblocking after works around it.

set -euo pipefail

unit=/etc/systemd/system/rfkill-before-sleep.service

sudo tee "$unit" >/dev/null <<'EOF'
[Unit]
Description=Disable wifi and bluetooth before suspend
DefaultDependencies=no
StopWhenUnneeded=yes
Before=sleep.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/rfkill block all
ExecStop=/usr/sbin/rfkill unblock all

[Install]
WantedBy=sleep.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable rfkill-before-sleep.service

echo "✅ box: wifi/bluetooth suspend workaround enabled"
