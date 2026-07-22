#!/usr/bin/env bash
#
# Names the machine.

set -euo pipefail

current="$(scutil --get ComputerName)"

read -r -p "box: machine name [$current]: " name

if [[ -z $name || $name == "$current" ]]; then
  echo "✅ box: machine name unchanged"
  exit 0
fi

sudo scutil --set ComputerName "$name"
sudo scutil --set HostName "$name"
sudo scutil --set LocalHostName "$name"

echo "✅ box: machine named $name"
