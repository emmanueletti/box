#!/usr/bin/env bash
#
# Closes System Settings, so it does not overwrite defaults set later.

set -euo pipefail

killall "System Settings" 2>/dev/null || true
killall "System Preferences" 2>/dev/null || true

echo "✅ box: system settings closed"
