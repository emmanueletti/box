#!/usr/bin/env bash

set -euo pipefail

file=$1
width=$2
height=$3

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
mimetype=$(file --mime-type -Lb -- "$file")

case $mimetype in
    inode/directory)
        eza -la --color=always --group-directories-first -- "$file"
        ;;
    text/*|application/json|application/x-empty)
        bat --color=always --style=numbers --line-range :"$height" -- "$file"
        ;;
    application/pdf)
        pdftotext -l 1 -layout -- "$file" -
        ;;
    application/zip|application/x-tar|application/x-7z-compressed|application/x-rar|application/x-xz|application/gzip)
        ouch list -- "$file"
        ;;
    image/*)
        chafa -f "$("$script_dir/chafa-format.sh")" -s "${width}x${height}" --animate off --polite on -t 1 --bg gray -- "$file"
        ;;
    *)
        file -b -- "$file"
        ;;
esac
