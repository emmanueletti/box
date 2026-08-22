#!/usr/bin/env bash
#
# Names the machine.

set -euo pipefail

current="$(hostnamectl --static)"

read -r -p "box: machine name [$current]: " name

if [[ -z $name || $name == "$current" ]]; then
  echo "✅ box: machine name unchanged"
  exit 0
fi

sudo hostnamectl set-hostname "$name"

echo "✅ box: machine named $name"
