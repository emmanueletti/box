#!/usr/bin/env bash
#
# Downloads the zellij wasm plugins and pre-grants their permissions.
#
# The kdl files reference plugins by path only, so the versions below are the
# single place they are pinned.
#
# Granting matters as much as downloading: zellij asks for plugin permissions
# inside the plugin's own pane, and the status bar pane is one row tall, so the
# prompt is invisible and unanswerable. Without a grant the bar silently renders
# as nothing.

set -euo pipefail

declare -A plugin_urls=(
  [zjstatus.wasm]="https://github.com/dj95/zjstatus/releases/download/v0.24.0/zjstatus.wasm"
  [zellij_forgot.wasm]="https://github.com/karimould/zellij-forgot/releases/download/0.4.2/zellij_forgot.wasm"
)

declare -A plugin_permissions=(
  [zjstatus.wasm]="ReadApplicationState ChangeApplicationState RunCommands"
  [zellij_forgot.wasm]="ReadApplicationState ChangeApplicationState"
)

plugin_dir="${HOME}/.config/zellij/plugins"

if [[ -n ${XDG_CACHE_HOME:-} ]]; then
  cache_dir="${XDG_CACHE_HOME}/zellij"
elif [[ $(uname -s) == "Darwin" ]]; then
  cache_dir="${HOME}/Library/Caches/org.Zellij-Contributors.zellij"
else
  cache_dir="${HOME}/.cache/zellij"
fi

permissions="${cache_dir}/permissions.kdl"

mkdir -p "$plugin_dir" "$cache_dir"
touch "$permissions"

for plugin in "${!plugin_urls[@]}"; do
  target="${plugin_dir}/${plugin}"

  echo "box: downloading ${plugin}"
  curl -sSfL -o "$target" "${plugin_urls[$plugin]}"

  # Delete this plugin's old grant before writing the new one, otherwise the
  # file grows a duplicate block per run. awk drops from the quoted path line
  # through its closing brace and leaves every other plugin's block alone.
  awk -v key="\"${target}\" {" '
    $0 == key { drop = 1; next }
    drop { if ($0 == "}") drop = 0; next }
    { print }
  ' "$permissions" >"${permissions}.tmp"
  mv "${permissions}.tmp" "$permissions"

  echo "box: granting permissions for ${plugin}"
  {
    echo "\"${target}\" {"
    for permission in ${plugin_permissions[$plugin]}; do
      echo "    ${permission}"
    done
    echo "}"
  } >>"$permissions"
done

echo "✅ box: zellij plugins installed"
