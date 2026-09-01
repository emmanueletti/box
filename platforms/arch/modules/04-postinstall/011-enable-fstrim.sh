#!/usr/bin/env bash

set -euo pipefail

sudo systemctl enable --now fstrim.timer

echo "✅ box: fstrim.timer enabled"
