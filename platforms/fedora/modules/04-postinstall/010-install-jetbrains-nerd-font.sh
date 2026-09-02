#!/usr/bin/env bash

set -euo pipefail

font_dir="${HOME}/.local/share/fonts/JetBrainsMonoNerd"
version="v3.5.1"

if [[ ! -d $font_dir ]]; then
  mkdir -p "$font_dir"
  curl -Lo "${font_dir}/JetBrainsMono.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/JetBrainsMono.zip"
  unzip -q "${font_dir}/JetBrainsMono.zip" -d "$font_dir"
  rm "${font_dir}/JetBrainsMono.zip"
  rm -f "$font_dir"/*Windows*
  fc-cache -f "$font_dir"
fi

echo "✅ box: JetBrains Mono Nerd Font installed"
