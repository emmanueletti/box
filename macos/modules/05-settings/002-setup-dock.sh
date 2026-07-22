#!/usr/bin/env bash
#
# A dock that stays out of the way and holds only what box installs.

set -euo pipefail

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock minimize-to-application -bool true

if ! command -v dockutil >/dev/null 2>&1; then
  echo "⚠️ box: dockutil not found, skipping dock contents"
  killall Dock
  exit 0
fi

# Clearing first keeps reruns from stacking duplicates, and the dock minimal.
dockutil --no-restart --remove all

for app in /Applications/Ghostty.app /Applications/Zen.app; do
  if [[ -d $app ]]; then
    dockutil --no-restart --add "$app"
  fi
done

# sort dateadded puts the newest file nearest the dock.
dockutil --no-restart --add ~/Desktop --view fan --display stack --sort dateadded
dockutil --no-restart --add ~/Documents --view fan --display stack --sort dateadded

killall Dock

echo "✅ box: dock configured"
