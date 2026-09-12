#!/bin/bash

set -euo pipefail

if [[ ! -f /etc/usbguard/rules.conf ]]; then
  echo "box: generating usbguard policy from currently connected devices"
  sudo sh -c 'usbguard generate-policy > /etc/usbguard/rules.conf'
fi

sudo systemctl enable --now usbguard.service

echo "✅ box: usbguard enabled"
