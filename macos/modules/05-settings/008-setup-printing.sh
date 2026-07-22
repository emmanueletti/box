#!/usr/bin/env bash
#
# The printer app closes itself once the queue is empty.

set -euo pipefail

defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "✅ box: printing configured"
