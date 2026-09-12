#!/usr/bin/env bash

set -euo pipefail

BOX_ROOT="${BOX_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
BOX_SCRIPTS_DIR="${BOX_ROOT}/scripts/.local/bin/box-scripts"
BOX_OS="$("${BOX_SCRIPTS_DIR}/_box-os-detect")"

export BOX_ROOT
export BOX_SCRIPTS_DIR
export BOX_OS

read -r -p "box: detected ${BOX_OS}. continue? [y/N] " reply

if [[ $reply != "y" ]]; then
  echo "❌ box setup: aborted"
  exit 1
fi

exec "${BOX_ROOT}/os/${BOX_OS}/setup.sh"
