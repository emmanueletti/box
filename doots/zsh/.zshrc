# =========================================================
# CORE
# =========================================================

bindkey -e
bindkey "\e[3~" delete-char
bindkey "^[[3;5~" kill-word     # ctrl + delete
bindkey "^H" backward-kill-word # ctrl + backspace
bindkey "^[^?" backward-kill-word # opt + delete
bindkey "^[[1;5C" forward-word  # ctrl + ->
bindkey "^[[1;5D" backward-word # ctrl + <-
bindkey '^[[H' beginning-of-line # Home key
bindkey '^[[F' end-of-line       # End key

# Treat `/` as a word boundary, so word motions and kills stop at each path
# segment instead of jumping the whole path. Also makes ctrl + -> take an
# autosuggested path one segment at a time (see the init section below).
WORDCHARS="${WORDCHARS:s@/@}"

setopt INTERACTIVE_COMMENTS
setopt AUTO_CD
setopt HIST_IGNORE_ALL_DUPS   # supersedes HIST_IGNORE_DUPS
setopt INC_APPEND_HISTORY     # write each command to $HISTFILE at once, but don't pull other panes' history into up-arrow
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_GLOB
setopt PROMPT_SUBST
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT  # cd builds a stack: cd -<TAB>
setopt HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS        # dedupe search + saved history
setopt EXTENDED_HISTORY                            # timestamps in history

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# LS_COLORS via dircolors — uses ANSI palette indices, so file colors track
# the terminal theme automatically. Drop a custom ~/.dircolors to override.
if (( $+commands[dircolors] )); then
  if [[ -r "$HOME/.dircolors" ]]; then
    eval "$(dircolors -b "$HOME/.dircolors")"
  else
    eval "$(dircolors -b)"
  fi
fi

# =========================================================
# COMPLETION
# =========================================================

autoload -Uz compinit
# keep the dump out of $HOME, in the XDG cache dir
_zdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
[[ -d ${_zdump:h} ]] || mkdir -p "${_zdump:h}"
# rebuild the completion dump at most once a day; otherwise fast path
if [[ -n $_zdump(#qN.mh+24) ]]; then
  compinit -d "$_zdump"
else
  compinit -C -d "$_zdump"
fi
unset _zdump
zmodload zsh/complist

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Za-z}' \
  'r:|[-_]=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# fd as the engine: fast, respects .gitignore, includes dotfiles
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --strip-cwd-prefix'
export FZF_DEFAULT_OPTS="--height=60% --layout=reverse --border --info=inline \
  --bind 'ctrl-/:toggle-preview' --bind 'ctrl-u:preview-half-page-up' \
  --bind 'ctrl-d:preview-half-page-down'"
# Ctrl-T (file widget, rebound to Ctrl-F below): bat preview
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
# Alt-C (cd into dir): tree preview
export FZF_ALT_C_OPTS="--preview 'tree -C -L 2 {} | head -200'"
# Ctrl-R (history): wrapped command preview + Ctrl-Y copies it to clipboard
if (( $+commands[wl-copy] )); then
  _clip=wl-copy
else
  _clip=pbcopy
fi
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap \
  --bind 'ctrl-y:execute-silent(echo -n {2..} | $_clip)+abort'"
unset _clip

source <(fzf --zsh)
# zellij eats Ctrl-T (Tab mode), so move the file-paste widget to Ctrl-F
# (Ctrl-F was just forward-char in emacs mode == redundant with the -> arrow)
bindkey '^F' fzf-file-widget

# =========================================================
# ALIASES
# =========================================================

alias shconfig='$EDITOR ~/.zshrc'
alias hxlang='$EDITOR ~/.config/helix/languages.toml'
alias zconfig='$EDITOR ~/.config/zellij/config.kdl'
alias gconfig='$EDITOR ~/.config/ghostty/config'
alias configdoots='$EDITOR ~/box/doots'
alias reload='exec $SHELL'
alias c='clear'
alias x='exit'
# macOS ships pbcopy/pbpaste; on wayland, map them onto wl-clipboard
(( $+commands[pbcopy] ))  || alias pbcopy='wl-copy'
(( $+commands[pbpaste] )) || alias pbpaste='wl-paste'

alias tm='tmux'
alias tml='tmux list-sessions'
alias tmks='tmux kill-session'

# soft-delete via trash-cli (install: sudo dnf install trash-cli).
# Deliberately NOT aliasing rm -> trash: keep rm meaning rm.
alias trash='trash-put'    # trash a file (goes to GNOME Files trash)
alias trl='trash-list'     # list trashed files
alias trr='trash-restore'  # interactive restore
alias tre='trash-empty'    # empty trash (trash-empty 30 = older than 30d)

alias ..='cd ..'
alias ...='cd ../..'

alias ls='eza --color=auto --group-directories-first'
alias ll='eza -lah --color=auto --group-directories-first --git --icons=auto'
alias top='btop'   # dust / procs also installed — call by name (don't shadow du/ps)

alias box='cd ~/box'
alias dev='cd ~/projects'
alias projects='cd ~/projects'
alias notes='glow ~/notes'

alias ladybird='/home/emmanueletti/projects/oss/ladybird/Meta/ladybird.py run ladybird -- --certificate /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem'

z() {
  local name="${1:-${PWD:t}}"
  zellij attach -c "${name//[^a-zA-Z0-9_-]/-}"
}

zd() {
  local name="${1:-${PWD:t}}"
  zellij attach -c "${name//[^a-zA-Z0-9_-]/-}" options --default-layout dev
}

zkill() {
  local session="${1:-$(zellij list-sessions --short | fzf --prompt='kill zellij session> ')}"
  [[ -n $session ]] || return 0
  zellij delete-session --force "$session"
}

alias zls='zellij list-sessions'
alias zc='zellij --layout compact'
alias zka='zellij delete-all-sessions --force --yes'
alias ztt='zellij action toggle-theme'

td() {
  local name="${1:-${PWD:t}}"
  tmux attach -t "$name" 2>/dev/null || tmux new -s "$name" -c "$PWD"
}

tkill() {
  local session="${1:-$(tmux list-sessions -F '#S' | fzf --prompt='kill tmux session> ')}"
  [[ -n $session ]] || return 0
  tmux kill-session -t "$session"
}

alias t='tmux'
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tls='tmux ls'


alias cc='claude --chrome --permission-mode auto'
alias lg='lazygit'
alias ld='lazydocker'
alias ts='tailscale'
alias tss='sudo tailscale serve'
alias tsfd='sudo tailscale file get'

alias ga='git add'
alias gs='git status -sb'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit'
alias gcm='git commit -m'
alias gcma='git commit -am'
alias gcane='git commit --amend --no-edit'
alias gpsh='git push'
alias gpll='git pull'
alias gpf='git push --force-with-lease'

# legacy
alias gco='git checkout'
alias gcom='git checkout main'
alias gcob='git checkout -b'
# modern
alias gsm='git switch main'
alias gsc='git switch -b'
alias grs='git restore --staged'

alias grpr='git remote prune origin'
alias glog='git log --oneline --decorate --color --graph -10'
alias glog50='git log --oneline --decorate --color --graph -50'
alias glog100='git log --oneline --decorate --color --graph -100'
alias gloga='git log --oneline --decorate --color --graph --all'
alias glogfull='git log --pretty=fuller'
alias gd='git diff'
alias gsize='git count-objects -vH'
alias gr='git rebase'
alias gri='git rebase -i'
alias grim='git rebase -i main'
alias grc='git rebase --continue'
alias gclean='git branch --merged | grep -v "\*\|main\|master\|develop" | xargs -r git branch -d'

alias dps='docker ps -a'
alias drm='docker rm'
alias drmf='docker rm -f'
alias db='docker build'
alias dka='docker stop $(docker ps -a -q)'
alias dcb='docker compose build'
alias dcu='docker compose up'
alias dcub='docker compose up --build'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dce='docker compose exec'
alias websh='docker compose exec web bash'
alias dbsh='docker compose exec db bash'
alias dprune='docker system prune -af --volumes'

alias prc='gh pr create -w'
alias prv='gh pr view -w'
alias repo='gh repo view -w'

alias be="bundle exec"
alias bu="bundle update"
alias bo='bundle outdated --only-explicit'
alias bi='bundle install'

alias r='bundle exec rails'
alias rnew='rails new . -c tailwind -d postgresql --skip-rubocop'
alias rc='bin/rails console'
alias rdbm='bin/rails db:migrate'
alias rdbrb='bin/rails db:rollback'
alias rdbr='bin/rails db:reset'
alias rdbs='bin/rails db:seed'
alias rdbsrp='bin/rails db:seed:replant'
alias rr='bin/rails routes --expanded -g'
alias rt='bin/rails test'
alias rtc='COVERAGE=true bin/rails test'
alias rts='bin/rails test:system'
alias rgm='bin/rails g migration'
alias rcred='bin/rails credentials:edit'

alias hf='herb-format'

alias nr='npm run'

alias mi='mise install'
alias mls='mise ls'
alias mo='mise outdated'
alias mx='mise exec'
alias mrun='mise run'
alias mup='mise update && mise prune'

# Only functions that need the calling shell live here. Everything else is a
# script in box/bin, discoverable with box-<TAB>.

galias() { alias | grep "$@" }

mkcd() { mkdir -p "$1" && cd "$1" }

Resume() {
  fg
  zle push-input
  BUFFER=""
  zle accept-line
}
zle -N Resume
bindkey "^Z" Resume

# yazi: cd into the dir you quit on
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ $cwd != "$PWD" && -d $cwd ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

lf() {
  local tmp="$(mktemp -t "lf-cwd.XXXXXX")" cwd
  command lf -last-dir-path="$tmp" "$@"
  [[ -f $tmp ]] && cwd="$(cat -- "$tmp")"
  [[ -n $cwd && $cwd != "$PWD" && -d $cwd ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# =========================================================
# INIT
# =========================================================

# Must load LAST -- zsh-syntax-highlighting has to be sourced after everything
# else.

# Point docker/compose at the engine's socket: rootless podman on Linux, Docker
# Desktop on macOS. Literal paths, no subprocess, so shell start stays fast.
if [[ -S ${XDG_RUNTIME_DIR:-/run/user/$UID}/podman/podman.sock ]]; then
  export DOCKER_HOST="unix://${XDG_RUNTIME_DIR:-/run/user/$UID}/podman/podman.sock"
elif [[ $OSTYPE == darwin* && -S $HOME/.docker/run/docker.sock ]]; then
  export DOCKER_HOST="unix://$HOME/.docker/run/docker.sock"
fi

# starship prompt
eval "$(starship init zsh)"

# Homebrew's bin, ahead of the system dirs -- brew, mise, starship etc. need
# to resolve before the calls below. Must run before `mise activate` --
# mise snapshots PATH at that point (__MISE_ORIG_PATH) and every prompt
# rebuilds from that snapshot, so anything prepended after activation gets
# buried again on the next prompt.
if [[ -n $HOMEBREW_PREFIX ]]; then
  path=($HOMEBREW_PREFIX/bin $HOMEBREW_PREFIX/sbin $path)
fi

# mise
eval "$(mise activate zsh)"

# The plugin files ship with the packages, in a different place per platform.
if [[ $OSTYPE == darwin* ]]; then
  _plugins=$HOMEBREW_PREFIX/share   # macOS (intel: /usr/local, silicon: /opt/homebrew)
else
  _plugins=/usr/share               # linux
fi

# autosuggestions (inline history hints)
if [[ -r $_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source $_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  bindkey '^ ' autosuggest-accept   # Ctrl-Space accepts the whole suggestion
fi

# syntax highlighting (must be last)
if [[ -r $_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source $_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

unset _plugins

# zoxide
export _ZO_EXCLUDE_DIRS="$HOME:*/server:*/ios:*/android:*/marketing"
eval "$(zoxide init --cmd cd zsh)"
