## Style

- Two spaces for indentation, no tabs
- All scripts use bash 5
- Use `[[ ]]` for string/file tests and `(( ))` for numeric tests
- In `[[ ]]`, don't quote variables; do quote string literals when comparing (e.g. `[[ $branch == "dev" ]]`)
- Prefer `(( ))` over numeric operators inside `[[ ]]` (e.g. `(( count < 50 ))`, not `[[ $count -lt 50 ]]`)
- Quote strings/paths with spaces rather than escaping (e.g. `"$APP_DIR/Disk Usage.app"`, not `$APP_DIR/Disk\ Usage.app`)
- Use ASCII `...` (three dots), never the unicode ellipsis `…` (U+2026). Bash with `set -u` misparses `$VAR…` in non-UTF-8 locales and reports the variable as unbound.

