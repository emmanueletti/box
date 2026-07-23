#!/usr/bin/env bash
#
# Save and print panels open expanded, not in their collapsed one-line form.

set -euo pipefail

defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

echo "✅ box: dialogs configured"
