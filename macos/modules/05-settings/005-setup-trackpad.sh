#!/usr/bin/env bash
#
# Tap to click, on the built-in trackpad and any external one.
# Takes effect on next login.

set -euo pipefail

defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# The login window and the current session read this one.
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "✅ box: trackpad configured"
