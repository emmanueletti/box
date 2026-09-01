#!/usr/bin/env bash
#
# Enrolls a new LUKS keyslot bound to the TPM plus a short PIN, so boot only
# asks for the PIN instead of the long recovery passphrase. The long
# passphrase keeps its own keyslot untouched -- a PCR mismatch (BIOS/secure
# boot change) just falls back to it, never a hard lockout.

set -euo pipefail

if [[ ! -d /sys/class/tpm/tpm0 ]]; then
  echo "box: no TPM detected, skipping"
  exit 0
fi

if ! command -v systemd-cryptenroll >/dev/null 2>&1; then
  echo "box: systemd-cryptenroll not found, skipping"
  exit 0
fi

mapfile -t drives < <(blkid -t TYPE=crypto_LUKS -o device)

if (( ${#drives[@]} == 0 )); then
  echo "box: no LUKS drives found, skipping"
  exit 0
fi

if (( ${#drives[@]} == 1 )); then
  drive="${drives[0]}"
else
  echo "box: multiple LUKS drives found, pick one"
  select drive in "${drives[@]}"; do
    [[ -n $drive ]] && break
  done
fi

if sudo systemd-cryptenroll "$drive" | grep -q tpm2; then
  echo "✅ box: TPM already enrolled for $drive"
  exit 0
fi

read -r -p "box: enroll TPM2 + PIN unlock for $drive? [y/N] " reply

if [[ $reply != "y" ]]; then
  echo "box: TPM unchanged"
  exit 0
fi

sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 --tpm2-with-pin=yes "$drive"

echo "✅ box: TPM2 enrolled for $drive, long password kept as fallback"
