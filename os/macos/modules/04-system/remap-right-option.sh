#!/usr/bin/env bash
#
# The Logitech "opt|ctrl" key sits where right Option lives, so macOS sends
# right Option (HID 0x7000000E6) and Ctrl chords from it do nothing. Remap it
# to left Control (0x7000000E0) so it behaves as Control.
#
# hidutil forgets the mapping on reboot and on keyboard reconnect. A system
# LaunchDaemon re-applies it at boot (before login), which is more reliable on
# recent macOS than a per-user LaunchAgent. This is a global map: right Option
# on the built-in keyboard also becomes Control. To scope it to the Logitech
# only, add its vendor/product IDs via `hidutil property --matching` (see
# `hidutil list`).

set -euo pipefail

readonly LABEL="com.box.remap-right-option-to-control"
readonly PLIST="/Library/LaunchDaemons/${LABEL}.plist"
readonly JSON='{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x7000000E6,"HIDKeyboardModifierMappingDst":0x7000000E0}]}'

# Remove any earlier per-user LaunchAgent version so the map isn't applied twice.
readonly OLD_AGENT="${HOME}/Library/LaunchAgents/${LABEL}.plist"
if [[ -f $OLD_AGENT ]]; then
  launchctl bootout "gui/$(id -u)/${LABEL}" 2>/dev/null || true
  rm -f "$OLD_AGENT"
fi

sudo tee "$PLIST" > /dev/null <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${LABEL}</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/hidutil</string>
    <string>property</string>
    <string>--set</string>
    <string>${JSON}</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
PLIST

sudo chown root:wheel "$PLIST"
sudo chmod 644 "$PLIST"

# Reload so it applies now and on every boot. bootout is idempotent.
sudo launchctl bootout "system/${LABEL}" 2>/dev/null || true
sudo launchctl bootstrap system "$PLIST"

echo "✅ box: right Option remapped to Control"
