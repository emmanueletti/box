#!/usr/bin/env bash
#
# Lock the screen as soon as the screen saver starts or the display sleeps.

set -euo pipefail

sudo sysadminctl -screenLock immediate -password ''

echo "✅ box: screen lock set to immediate"
