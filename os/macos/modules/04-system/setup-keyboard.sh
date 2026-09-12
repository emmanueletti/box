#!/usr/bin/env bash
#
# A keyboard that repeats fast and does not rewrite what you type.
# Takes effect on next login.

set -euo pipefail

defaults write NSGlobalDomain KeyRepeat -int 3
defaults write NSGlobalDomain InitialKeyRepeat -int 20

# Press-and-hold shows the accent picker, which swallows key repeat.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# 3 = tab moves between all controls, not just text fields and lists.
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "✅ box: keyboard configured"
