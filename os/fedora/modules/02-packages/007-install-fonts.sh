#!/usr/bin/env bash

set -euo pipefail

version="v3.5.1"

install_font() {
  local name=$1 archive=$2
  local font_dir="${HOME}/.local/share/fonts/${name}"

  if [[ -d $font_dir ]]; then
    return 0
  fi

  mkdir -p "$font_dir"
  curl -Lo "${font_dir}/${archive}" "https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/${archive}"
  unzip -q "${font_dir}/${archive}" -d "$font_dir"
  rm "${font_dir}/${archive}"
  rm -f "$font_dir"/*Windows*
  fc-cache -f "$font_dir"
}

install_font JetBrainsMonoNerd JetBrainsMono.zip
install_font NerdFontSymbols NerdFontsSymbolsOnly.zip
install_font FiraCodeNerd FiraCode.zip

echo "✅ box: nerd fonts installed"
