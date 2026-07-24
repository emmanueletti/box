#!/usr/bin/env bash

set -euo pipefail

# Terra ships terra-release and terra-gpg-keys unsigned, so its documented
# install uses --nogpgcheck (terrapkg/packages discussion 7736). That leaves the
# repo trust anchor on first-use trust. Pin the key fingerprint instead: fetch
# it, compare, refuse to continue on mismatch. Keys rotate per Fedora release,
# so a release with no pin fails closed. Add one only after checking it against
# https://repos.fyralabs.com/terra<ver>/key.asc
declare -A TERRA_KEY_FINGERPRINTS=(
  [43]="47F7A5060E38FC07F674D11BE43DBFE05C4F92A3"
  [44]="AE09157A4DE88B497EA1D5D300CDAB43DE226D6F"
  [45]="C2AC02124AF114F086592E3C8DDE7D14C1C23D8C"
)

# Terra carries replacements for Fedora's own packages and wins on version
# alone, so restrict it to what box actually takes from it. A Terra-only
# addition to packages.list must be added here too or the install will fail.
TERRA_PACKAGES=(
  terra-release
  terra-gpg-keys
  mise
  mise-bash-completion
  mise-zsh-completion
  usage-cli
  starship
  zellij
  ouch
  golang-github-jesseduffield-lazygit
)

ver=$(rpm -E %fedora)
expected=${TERRA_KEY_FINGERPRINTS[$ver]:-}

if [[ -z $expected ]]; then
  echo "❌ box: no pinned terra key fingerprint for fedora ${ver}" >&2
  echo "   check https://repos.fyralabs.com/terra${ver}/key.asc, then add it to this script" >&2
  exit 1
fi

fingerprint_of() {
  gpg --show-keys --with-colons "$1" 2>/dev/null | awk -F: '/^fpr:/ { print $10; exit }'
}

if ! rpm -q terra-release > /dev/null 2>&1; then
  keyfile=$(mktemp)
  trap 'rm -f "$keyfile"' EXIT

  curl -fsSL "https://repos.fyralabs.com/terra${ver}/key.asc" -o "$keyfile"

  fetched=$(fingerprint_of "$keyfile")
  if [[ $fetched != "$expected" ]]; then
    echo "❌ box: terra key fingerprint mismatch" >&2
    echo "   expected ${expected}" >&2
    echo "   got      ${fetched:-none}" >&2
    exit 1
  fi

  sudo rpm --import "$keyfile"

  sudo dnf install -y --nogpgcheck \
    --repofrompath "terra,https://repos.fyralabs.com/terra${ver}" \
    terra-release terra-gpg-keys
fi

# terra.repo trusts a key by path, so the on-disk copy needs checking too.
# Importing a good key does not stop a bad one landing here.
keypath="/etc/pki/rpm-gpg/RPM-GPG-KEY-terra${ver}"
installed=$(fingerprint_of "$keypath")
if [[ $installed != "$expected" ]]; then
  echo "❌ box: ${keypath} does not match the pinned fingerprint" >&2
  echo "   expected ${expected}" >&2
  echo "   got      ${installed:-none}" >&2
  exit 1
fi

# Re-applied every run so machines set up before this get it too. dnf5 stores it
# in /etc/dnf/repos.override.d/, out of reach of a terra-release upgrade.
allowed=$(
  IFS=,
  echo "${TERRA_PACKAGES[*]}"
)
sudo dnf config-manager setopt "terra.includepkgs=${allowed}"

echo "✅ box: terra enabled, key pinned, scope limited"
