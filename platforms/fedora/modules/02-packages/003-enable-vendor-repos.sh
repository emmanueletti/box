#!/usr/bin/env bash

set -euo pipefail

if [[ ! -f /etc/yum.repos.d/brave-browser.repo ]]; then
  sudo tee /etc/yum.repos.d/brave-browser.repo > /dev/null <<'EOF'
[brave-browser]
name=Brave Browser
enabled=1
gpgcheck=1
gpgkey=https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
baseurl=https://brave-browser-rpm-release.s3.brave.com/$basearch
EOF
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
