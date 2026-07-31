#!/usr/bin/env bash

set -euo pipefail

if [[ ! -f /etc/yum.repos.d/brave-browser.repo ]]; then
  sudo dnf config-manager addrepo \
    --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
fi

if [[ ! -f /etc/yum.repos.d/tailscale.repo ]]; then
  sudo dnf config-manager addrepo \
    --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
fi

if [[ ! -f /etc/yum.repos.d/gh-cli.repo ]]; then
  sudo dnf config-manager addrepo \
    --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
fi

if [[ ! -f /etc/yum.repos.d/vscode.repo ]]; then
  sudo tee /etc/yum.repos.d/vscode.repo > /dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
fi

if [[ ! -f /etc/yum.repos.d/1password.repo ]]; then
  sudo tee /etc/yum.repos.d/1password.repo > /dev/null <<'EOF'
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
EOF
fi

if [[ ! -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:scottames:ghostty.repo ]]; then
  sudo dnf copr enable -y scottames/ghostty
fi
