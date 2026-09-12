#!/usr/bin/env bash
# Claude Code status line — mirrors the Starship prompt in ~/.config/starship.toml:
#   truncate_to_repo=true, truncation_length=3, blue path, (branch) dimmed green, status dimmed red

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')

# ---- Model + context window ----------------------------------------------
model_name=$(echo "$input" | jq -r '.model.display_name // empty')
effort_level=$(echo "$input" | jq -r '.effort.level // empty')

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -z "$used_pct" ]; then
  total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
  window_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
  if [ -n "$total_input" ] && [ -n "$window_size" ] && [ "$window_size" != "0" ]; then
    used_pct=$(awk -v t="$total_input" -v w="$window_size" 'BEGIN { printf "%.0f", (t / w) * 100 }')
  fi
fi

ctx_bar=""
if [ -n "$used_pct" ]; then
  used_pct=$(awk -v p="$used_pct" 'BEGIN { printf "%.0f", p }')
  _filled=$(awk -v p="$used_pct" 'BEGIN { n = int((p / 100) * 10 + 0.5); if (n > 10) n = 10; if (n < 0) n = 0; print n }')
  _empty=$((10 - _filled))
  _bar=""
  for ((i = 0; i < _filled; i++)); do _bar="${_bar}█"; done
  for ((i = 0; i < _empty; i++)); do _bar="${_bar}░"; done
  if [ "$used_pct" -ge 90 ] 2>/dev/null; then
    _bar_color=$'\033[31m'
  elif [ "$used_pct" -ge 70 ] 2>/dev/null; then
    _bar_color=$'\033[33m'
  else
    _bar_color=$'\033[32m'
  fi
  _rst=$'\033[0m'
  ctx_bar="${_bar_color}${_bar}${_rst} ${used_pct}%"
fi

model_info=""
if [ -n "$model_name" ]; then
  model_info="🤖 $model_name"
  [ -n "$effort_level" ] && model_info="${model_info} (${effort_level})"
  [ -n "$ctx_bar" ] && model_info="${model_info} ${ctx_bar}"
fi

# ---- Diff lines added/removed this session -------------------------------
added=$(echo "$input" | jq -r '.cost.total_lines_added // empty')
removed=$(echo "$input" | jq -r '.cost.total_lines_removed // empty')

# ---- Path ---------------------------------------------------------------
# Resolve path relative to git repo root's parent (keeps repo dir name),
# then truncate to the last 3 components — same as starship's settings.

git_root=$(git -C "$cwd" --no-optional-locks rev-parse --show-toplevel 2>/dev/null)

if [ -n "$git_root" ]; then
  parent=$(dirname "$git_root")
  rel="${cwd#${parent}/}"
else
  rel="${cwd/#$HOME/~}"
fi

IFS='/' read -ra _parts <<< "$rel"
_count=${#_parts[@]}
if [ "$_count" -gt 3 ]; then
  display_path="${_parts[$((_count-3))]}/${_parts[$((_count-2))]}/${_parts[$((_count-1))]}"
else
  display_path="$rel"
fi

# ---- Git branch ---------------------------------------------------------
branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)

# ---- Git status ---------------------------------------------------------
status_str=""
if [ -n "$branch" ]; then
  porcelain=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)
  if [ -n "$porcelain" ]; then
    echo "$porcelain" | grep -qvE '^(\?\?|!!)' && status_str="${status_str}!"
    echo "$porcelain" | grep -q '^??' && status_str="${status_str}?"
  fi
  ab=$(git -C "$cwd" --no-optional-locks rev-list --count --left-right "@{upstream}...HEAD" 2>/dev/null)
  if [ -n "$ab" ]; then
    _behind=$(echo "$ab" | cut -f1)
    _ahead=$(echo "$ab" | cut -f2)
    [ "$_behind" -gt 0 ] && status_str="${status_str}⇣${_behind}"
    [ "$_ahead" -gt 0 ] && status_str="${status_str}⇡${_ahead}"
  fi
fi

# ---- Colors (match starship config) -------------------------------------
blue=$'\033[34m'
dim_green=$'\033[2;32m'
dim_red=$'\033[2;31m'
reset=$'\033[0m'

# ---- Caveman mode badge -------------------------------------------------
# Mirrors caveman-statusline.sh: read the mode flag safely (refuse symlinks,
# cap length, whitelist) and render an orange badge.
caveman=""
FLAG="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.caveman-active"
if [ -f "$FLAG" ] && [ ! -L "$FLAG" ]; then
  MODE=$(head -c 64 "$FLAG" 2>/dev/null | tr -d '\n\r' | tr '[:upper:]' '[:lower:]')
  MODE=$(printf '%s' "$MODE" | tr -cd 'a-z0-9-')
  case "$MODE" in
    off|lite|full|ultra|wenyan-lite|wenyan|wenyan-full|wenyan-ultra|commit|review|compress)
      if [ -z "$MODE" ] || [ "$MODE" = "full" ]; then
        caveman=$'\033[38;5;172m[CAVEMAN]\033[0m'
      else
        SUFFIX=$(printf '%s' "$MODE" | tr '[:lower:]' '[:upper:]')
        caveman=$(printf '\033[38;5;172m[CAVEMAN:%s]\033[0m' "$SUFFIX")
      fi
      ;;
  esac
fi

# ---- Output -------------------------------------------------------------
dim=$'\033[2m'

green=$'\033[32m'
red=$'\033[31m'
sep=$'\033[38;5;236m│\033[0m'

# git section
git_seg="${blue}${display_path}${reset}"
[ -n "$branch" ] && git_seg="${git_seg} ${dim_green}(${branch})${reset}"
[ -n "$status_str" ] && git_seg="${git_seg} ${dim_red}[${status_str}]${reset}"

out=""
[ -n "$caveman" ] && out="${caveman} "
out="${out}${git_seg}"
[ -n "$model_info" ] && out="${out} ${sep} ${dim}${model_info}${reset}"
if [ -n "$added" ] || [ -n "$removed" ]; then
  out="${out} ${sep} ${green}+${added:-0}${reset} ${red}-${removed:-0}${reset}"
fi

printf "%s\n" "$out"
