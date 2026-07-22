alias shconfig='$EDITOR ~/zsh'
alias hxlang='$EDITOR ~/.config/helix/languages.toml'
alias zconfig='$EDITOR ~/.config/zellij/config.kdl'
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

alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lah --color=auto --group-directories-first'
alias top='btop'   # dust / procs also installed — call by name (don't shadow du/ps)

alias dev='cd ~/projects'
alias notes='glow ~/notes'

alias z='zellij'
alias zc='zellij --layout compact'
alias zka='zellij kill-all-sessions --yes'
alias ztt='zellij action toggle-theme'

(( $+commands[flatpak] )) && alias flameshot='flatpak run org.flameshot.Flameshot'

alias cc='claude --enable-auto-mode'
alias ccc='claude --chrome --enable-auto-mode'
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
