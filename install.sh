#!/usr/bin/env bash
#
# Box installer entrypoint.

set -euo pipefail

BOX_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOX_OS="$("${BOX_ROOT}/lib/box-detect-os.sh")"
export BOX_ROOT BOX_OS

read -r -p "box: detected ${BOX_OS}. continue? [y/N] " reply

if [[ $reply != "y" ]]; then
  echo "❌ box: aborted"
  exit 1
fi

exec "${BOX_ROOT}/platforms/${BOX_OS}/install.sh"
