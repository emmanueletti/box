#!/usr/bin/env bash
#
# Prints the box OS identifier: macos, arch or fedora.
# Exits 1 with a message on stderr when the OS is unsupported.

set -euo pipefail

os="$(uname -s)"

if [[ $os == "Darwin" ]]; then
  echo macos
  exit 0
fi

if [[ $os == "Linux" && -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  if [[ ${ID:-} == "arch" ]]; then
    echo arch
    exit 0
  fi

  if [[ ${ID:-} == "fedora" ]]; then
    echo fedora
    exit 0
  fi
fi

echo "❌ box: unsupported OS: $os ${ID:-}" >&2
exit 1
