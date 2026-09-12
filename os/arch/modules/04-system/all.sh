#!/bin/bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 box: 04-system"

"${MODULE_ROOT}/setup-microcode.sh"
"${MODULE_ROOT}/setup-secureboot.sh"
"${MODULE_ROOT}/setup-firewall.sh"
"${MODULE_ROOT}/setup-usbguard.sh"
"${MODULE_ROOT}/setup-services.sh"
"${MODULE_ROOT}/setup-docker.sh"
"${MODULE_ROOT}/setup-tailscale.sh"
"${MODULE_ROOT}/setup-mdns.sh"
"${MODULE_ROOT}/setup-wireless-regdom.sh"
"${MODULE_ROOT}/setup-tpm-guard.sh"
"${MODULE_ROOT}/setup-tty-autologin.sh"
