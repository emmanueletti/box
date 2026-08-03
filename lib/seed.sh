#!/usr/bin/env bash
#
# Copies default files into $HOME, only where nothing is there yet.
#
#   seed.sh [--force] <defaults-dir> [package...]
#
# The counterpart to stow.sh. A stowed file is a symlink, so editing it writes
# back into the repo -- right for configs box owns end to end. A seeded file is
# a real copy: box hands the machine a starting point, then never touches it
# again, so the machine is free to drift. Use this for files an app rewrites
# by itself (~/.claude/settings.json), which through a symlink would silently
# overwrite the repo's copy.
#
# --force replaces files that are already there, saving each one as
# <file>.box-bak first. Without it, an existing file is kept and reported.
#
# With no package names, every directory in <defaults-dir> is seeded.

set -euo pipefail

force=0
if [[ ${1:-} == "--force" ]]; then
  force=1
  shift
fi

defaults_dir="$1"
shift

cd "$defaults_dir"

packages=("$@")
if (( $# == 0 )); then
  packages=(*/)
fi

kept=0

for package in "${packages[@]}"; do
  package="${package%/}"   # strip the trailing slash the */ glob leaves on

  # Layout matches a stow package: the path below the package name is exactly
  # where the file lands under $HOME. So defaults/claude/.claude/settings.json
  # seeds ~/.claude/settings.json.
  while IFS= read -r -d '' file; do
    rel="${file#./$package/}"
    target="$HOME/$rel"

    # -L as well as -e: a dangling symlink still counts as occupied, and
    # clobbering it would be a surprise rather than a seed.
    if [[ -e $target || -L $target ]]; then
      if (( force == 0 )); then
        echo "   kept   $rel (already there)"
        (( ++kept ))
        continue
      fi

      mv "$target" "$target.box-bak"
      cp "$file" "$target"
      echo "   forced $rel (old copy saved as $rel.box-bak)"
      continue
    fi

    mkdir -p "$(dirname "$target")"
    cp "$file" "$target"
    echo "   seeded $rel"
  done < <(find "./$package" -type f -print0)
done

if (( kept > 0 )); then
  echo "   ($kept kept as-is. Re-run with --force to replace them.)"
fi
