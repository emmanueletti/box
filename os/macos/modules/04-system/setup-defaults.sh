#!/usr/bin/env bash

set -euo pipefail

defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# The login window and the current session read this one.
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

defaults write com.apple.controlcenter BatteryShowPercentage -bool true
killall ControlCenter 2>/dev/null || true

echo "✅ box: trackpad, dialogs, printing and menu bar configured"
