#!/usr/bin/env bash
#
# Lock the screen as soon as the screen saver starts or the display sleeps,
# and keep the floating screenshot thumbnail after each capture.

set -euo pipefail

sudo sysadminctl -screenLock immediate -password ''

echo "✅ box: screen lock set to immediate"

defaults write com.apple.screencapture show-thumbnail -bool true
killall cfprefsd 2>/dev/null || true

echo "✅ box: screenshot floating thumbnail on"
