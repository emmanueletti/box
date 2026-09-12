#!/bin/bash

set -euo pipefail

regdom_file="/etc/conf.d/wireless-regdom"
country="${BOX_REGDOM:-CA}"

if [[ ! -f $regdom_file ]]; then
  echo "box: no ${regdom_file}, is wireless-regdb installed? skipping"
  exit 0
fi

if grep -qE '^WIRELESS_REGDOM=' "$regdom_file"; then
  echo "✅ box: wireless regdom already set to $(grep -m1 -E '^WIRELESS_REGDOM=' "$regdom_file" | cut -d= -f2)"
  exit 0
fi

if ! grep -qE "^#WIRELESS_REGDOM=\"${country}\"" "$regdom_file"; then
  echo "⚠️ box: no ${country} entry in ${regdom_file}, set it by hand" >&2
  exit 0
fi

sudo sed -i "s/^#WIRELESS_REGDOM=\"${country}\"/WIRELESS_REGDOM=\"${country}\"/" "$regdom_file"

echo "✅ box: wireless regdom set to ${country}, takes effect after a reboot"
echo "     other country? BOX_REGDOM=XX before setup, or edit ${regdom_file}"
