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
# autosuggested path one segment at a time.
WORDCHARS="${WORDCHARS:s@/@}"

# Type a command and press Esc then h to open its man page.
autoload -Uz run-help run-help-git run-help-ip run-help-openssl run-help-sudo
(( $+aliases[run-help] )) && unalias run-help

setopt INTERACTIVE_COMMENTS
setopt AUTO_CD
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_GLOB
setopt PROMPT_SUBST
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt EXTENDED_HISTORY

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# =========================================================
# COMPLETION
# =========================================================

# keep the dump out of $HOME, in the XDG cache dir
_zcache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d $_zcache_dir ]] || mkdir -p "$_zcache_dir"

_zcache() {
  local out="$_zcache_dir/$1.zsh"
  shift
  if [[ ! -s $out || $commands[$1] -nt $out ]]; then
    if "$@" >| "$out.tmp" 2>/dev/null; then
      mv -- "$out.tmp" "$out"
    else
      rm -f -- "$out.tmp"
    fi
  fi
  [[ -s $out ]] && source "$out"
}

autoload -Uz compinit
_zdump="$_zcache_dir/zcompdump"
# full rebuild at most once a day; -C reuses the dump (24 ms vs 507 ms)
if [[ -n $_zdump(#qN.mh+24) ]]; then
  compinit -d "$_zdump"
  touch "$_zdump"
else
  compinit -C -d "$_zdump"
fi
unset _zdump
zmodload zsh/complist

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Za-z}' \
  'r:|[-_]=* r:|=*'

export FZF_DEFAULT_OPTS="--height=60% --layout=reverse --border --info=inline"
_zcache fzf fzf --zsh

# =========================================================
# FUNCTIONS
# =========================================================

mkcd() { mkdir -p "$1" && cd "$1" }

galias() { alias | grep "$@" }

glog() { git log --oneline --decorate --color --graph -${1:-10} }

td() {
  local name="${1:-${PWD:t}}"
  tmux attach -t "$name" 2>/dev/null || tmux new -s "$name" -c "$PWD"
}

tkill() {
  local session="${1:-$(tmux list-sessions -F '#S' | fzf --prompt='kill tmux session> ')}"
  [[ -n $session ]] || return 0
  tmux kill-session -t "$session"
}

# cd into the dir lf quit on
lf() {
  local tmp="$(mktemp -t "lf-cwd.XXXXXX")" cwd
  command lf -last-dir-path="$tmp" "$@"
  [[ -f $tmp ]] && cwd="$(cat -- "$tmp")"
  [[ -n $cwd && $cwd != "$PWD" && -d $cwd ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Ctrl-Z again to bring the backgrounded job back to the foreground.
Resume() {
  fg
  zle push-input
  BUFFER=""
  zle accept-line
}
zle -N Resume
bindkey "^Z" Resume

# =========================================================
# ALIASES
# =========================================================

alias shconfig='$EDITOR ~/.zshrc'
alias dootsconfig='$EDITOR ~/box/doots'
alias reload='exec $SHELL'
alias c='clear'
alias x='exit'

alias ..='cd ..'
alias ...='cd ../..'

alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lah'

alias box='cd ~/box'
alias dev='cd ~/projects'
alias notes='$EDITOR ~/notes'


alias t='tmux'
alias tls='tmux ls'

alias cx='claude --chrome --permission-mode auto'
alias lg='lazygit'
alias ts='tailscale'
alias foot-dark='pkill -x -USR1 -u $USER foot'
alias foot-light='pkill -x -USR2 -u $USER foot'

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
alias rdbroll='bin/rails db:rollback'
alias rdbreset='bin/rails db:reset'
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

# =========================================================
# INIT
# =========================================================

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%F{green}(%b)%f%m '
zstyle ':vcs_info:git:*' actionformats '%F{green}(%b|%a)%f%m '
zstyle ':vcs_info:git*+set-message:*' hooks git-status
+vi-git-status() {
  local misc='' line ahead=0 behind=0
  for line in "${(@f)$(git status --porcelain=v2 --branch 2>/dev/null)}"; do
    if [[ $line == "# branch.ab "* ]]; then
      line=${line#\# branch.ab +}
      ahead=${line%% *}
      behind=${line##*-}
    elif [[ $line != "#"* && -n $line ]]; then
      misc='%F{yellow}*%f'
    fi
  done
  if (( ahead > 0 && behind > 0 )); then
    misc+='%F{red}⇕%f'
  elif (( ahead > 0 )); then
    misc+='%F{cyan}⇡%f'
  elif (( behind > 0 )); then
    misc+='%F{cyan}⇣%f'
  fi
  hook_com[misc]=$misc
}
precmd_functions+=(vcs_info)

[[ -n $SSH_CONNECTION ]] && prompt_host='%B%F{red}ssh:%m%f%b '
PROMPT='${prompt_host}%B%F{blue}%3~%f%b ${vcs_info_msg_0_}%(?.%F{green}.%F{red})❯%f '

# mise
(( $+commands[mise] )) && _zcache mise mise activate zsh

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
(( $+commands[zoxide] )) && _zcache zoxide zoxide init --cmd cd zsh

unset _zcache_dir
unfunction _zcache
