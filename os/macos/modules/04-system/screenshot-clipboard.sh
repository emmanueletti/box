#!/usr/bin/env bash
#
# Auto-copy each new screenshot to the clipboard, while keeping the file on the
# Desktop and the floating thumbnail. macOS can send a screenshot to a file OR
# the clipboard, never both -- so a per-user LaunchAgent watches the Desktop and
# copies the newest screenshot in with osascript.

set -euo pipefail

readonly LABEL="com.box.screenshot-to-clipboard"
readonly LIBEXEC="${HOME}/.local/libexec/box"
readonly HELPER="${LIBEXEC}/screenshot-to-clipboard.sh"
readonly PLIST="${HOME}/Library/LaunchAgents/${LABEL}.plist"
readonly WATCH="${HOME}/Desktop"

mkdir -p "$LIBEXEC" "$(dirname "$PLIST")"

# The helper: copy the newest screenshot to the clipboard, once. WatchPaths
# fires on any Desktop change, so it filters by name, ignores files older than a
# few seconds, and records the last file copied to avoid repeat copies.
cat > "$HELPER" <<'HELPER'
#!/usr/bin/env bash
set -euo pipefail

dir="${HOME}/Desktop"
state="${HOME}/.local/state/box/last-screenshot-clip"
mkdir -p "$(dirname "$state")"

shopt -s nullglob
newest=""
for f in "$dir"/Screenshot*.png "$dir/Screen Shot"*.png; do
  [[ -z $newest || $f -nt $newest ]] && newest=$f
done
[[ -n $newest ]] || exit 0

# Only a just-taken shot, and only once. date -r reads mtime on BSD and GNU
# alike; stat's format flag differs between them.
(( $(date +%s) - $(date -r "$newest" +%s) <= 5 )) || exit 0
[[ -f $state && $(<"$state") == "$newest" ]] && exit 0

# Pass the path as argv, never inside the script source: a Desktop file named
# to look like AppleScript would otherwise be executed. «class PNGf» is the
# clipboard type most apps paste an image from.
osascript - "$newest" <<'AS'
on run argv
  set the clipboard to (read (POSIX file (item 1 of argv)) as «class PNGf»)
end run
AS
printf '%s' "$newest" > "$state"
HELPER

chmod +x "$HELPER"

cat > "$PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${LABEL}</string>
  <key>ProgramArguments</key>
  <array>
    <string>${HELPER}</string>
  </array>
  <key>WatchPaths</key>
  <array>
    <string>${WATCH}</string>
  </array>
</dict>
</plist>
PLIST

# Reload so it runs now and on every login. bootout is idempotent.
launchctl bootout "gui/$(id -u)/${LABEL}" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST"

echo "✅ box: screenshots auto-copy to clipboard"
