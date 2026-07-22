#!/usr/bin/env bash
#
# Battery reads as a number, not a picture of a battery.

set -euo pipefail

defaults write com.apple.controlcenter BatteryShowPercentage -bool true

killall ControlCenter 2>/dev/null || true

echo "✅ box: menu bar configured"
