#!/usr/bin/env bash
#
# Symlinks stow packages into $HOME.
#
#   stow.sh <stow-dir> [package...]
#
# With no package names, every directory in <stow-dir> is stowed. Box is the
# source of truth, so files already sitting at a target path are backed up.

set -euo pipefail

stow_dir="$1"
shift

cd "$stow_dir"

packages=("$@")
if (( $# == 0 )); then
  packages=(*/)
fi

for package in "${packages[@]}"; do
  package="${package%/}"

  # stow refuses to overwrite a real file, so clear the way first.
  (cd "$package" && find . -type f ! -name .DS_Store) | while read -r file; do
    target="${HOME}/${file#./}"

    # Symlinks are stow's own, --restow clears them.
    if [[ -e $target && ! -L $target ]]; then
      mv "$target" "${target}.box-bak"
    fi
  done

  # --restow prunes symlinks left behind by files dropped from the package.
  # --no-folding keeps directories real, so stow only links leaf files. Without
  # it a clean $HOME gets ~/.config itself replaced by a symlink.
  stow --restow --no-folding --ignore='\.DS_Store$' \
    --dir="$stow_dir" --target="$HOME" "$package"
done
