#!/usr/bin/env bash
#
# Symlinks stow packages into $HOME.
#
#   stow.sh <stow-dir> [package...]
#
# With no package names, every directory in <stow-dir> is stowed. A real file
# already sitting at a target path makes stow abort that package and name the
# path. Move or delete it yourself, then re-run.

set -euo pipefail

stow_dir="$1"
shift

cd "$stow_dir"

packages=("$@")
if (( $# == 0 )); then
  packages=(*/)
fi

for package in "${packages[@]}"; do
  package="${package%/}"   # strip the trailing slash the */ glob leaves on

  # Folding decides how much of a package $HOME points at:
  #
  #   folded (.stow-fold marker present): the package DIRECTORY is symlinked, so
  #     ~/dir -> repo/dir. Every file under it is reached through that one link,
  #     which means adding, renaming, or deleting files in the repo shows up
  #     immediately -- no re-stow needed. Safe only for box-exclusive dirs
  #     (~/zsh, ~/.local/scripts); a stray file written there lands in the repo.
  #
  #   leaf-linked (default, --no-folding): each FILE is symlinked individually
  #     and the directory itself stays real. This is required for shared dirs
  #     (~/.config, ~/.claude) so other tools can write alongside box's files --
  #     but it means the links only match the file list as of the last stow.
  #     Add/rename/delete a file in the repo and you must re-stow to reconcile.
  #
  # Re-stowing (--restow) is that reconcile: stow first UNSTOWS (removes the
  # symlinks it owns, including ones left dangling by deleted repo files) then
  # STOWS again (links whatever files exist now). Net effect: stale links pruned,
  # new files linked, moved files repointed.
  fold=(--no-folding)
  [[ -e $package/.stow-fold ]] && fold=()

  stow --restow "${fold[@]}" --ignore='\.DS_Store$' --ignore='\.stow-fold$' \
    --dir="$stow_dir" --target="$HOME" "$package"
done
