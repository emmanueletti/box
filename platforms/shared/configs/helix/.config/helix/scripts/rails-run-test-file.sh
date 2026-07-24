#!/usr/bin/env bash
# Run an entire Rails test file. From a test/**/*_test.rb file, runs it
# directly. From an app/**/*.rb source file, runs its paired test file.
set -euo pipefail
caller="${1:-}"

if [[ "$caller" == test/*_test.rb ]]; then
  target="$caller"
elif [[ "$caller" == app/* && "$caller" == *.rb ]]; then
  target="$("$(dirname "$0")/rails-file-to-test.sh" "$caller")"
else
  echo "$caller"
  exit 0
fi

mkdir -p tmp
{
  echo "\$ bin/rails test ${target}"
  echo
  bin/rails test "$target" || true
} > tmp/helix_test.log 2>&1

echo "tmp/helix_test.log"
