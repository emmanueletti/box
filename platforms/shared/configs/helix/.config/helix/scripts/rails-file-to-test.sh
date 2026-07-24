#!/usr/bin/env bash
# Toggle between app/**/name.rb and test/**/name_test.rb (Rails convention).
set -euo pipefail
f="${1:-}"

if [[ "$f" == app/* && "$f" == *.rb ]]; then
  rel="${f#app/}"
  d="$(dirname "$rel")"; [[ "$d" == "." ]] && d=""
  b="$(basename "$rel" .rb)"
  echo "test/${d:+$d/}${b}_test.rb"
elif [[ "$f" == test/* && "$f" == *_test.rb ]]; then
  rel="${f#test/}"
  d="$(dirname "$rel")"; [[ "$d" == "." ]] && d=""
  b="$(basename "$rel" .rb)"; b="${b%_test}"
  echo "app/${d:+$d/}${b}.rb"
else
  echo "$f"
fi
