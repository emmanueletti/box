#!/bin/bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

grep . "${MODULE_ROOT}/assets/packages-aur.list" | yay -S --needed --noconfirm -
