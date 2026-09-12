#!/usr/bin/env bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mapfile -t packages < <(grep . "${MODULE_ROOT}/aur-packages.list")

yay -S --needed --noconfirm "${packages[@]}"
