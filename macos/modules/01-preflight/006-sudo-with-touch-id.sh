#!/usr/bin/env bash
#
# Lets sudo accept touch id.

set -euo pipefail

if grep -qs pam_tid.so /etc/pam.d/sudo_local; then
  echo "✅ box: sudo touch id already enabled"
  exit 0
fi

echo "box: enabling sudo with touch id"
echo "auth       sufficient     pam_tid.so" | sudo tee -a /etc/pam.d/sudo_local >/dev/null

echo "✅ box: sudo touch id enabled"
