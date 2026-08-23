#!/usr/bin/env bash
#
# Installs an intel-capable idb_companion on intel macs.
#
# The Brewfile's idb-companion pulls facebook's release tarball, which has been
# arm64-only since v1.5.0.b3 -- "universal" in the v1.5.0.b1/b2 asset names is a
# lie, those are arm64 too. On an intel mac brew installs it anyway and every
# idb command dies with "Bad CPU type in executable", which reads like a broken
# python install rather than a wrong-arch binary.
#
# v1.1.8 is the last genuinely universal build. It is old, but it still drives
# current simulators, so shadow the brew copy with it rather than dropping the
# package (apple silicon keeps the newer one).

set -euo pipefail

if [[ $(uname -m) == "arm64" ]]; then
  exit 0
fi

VERSION="1.1.8"
ARCHIVE_URL="https://github.com/facebook/idb/releases/download/v${VERSION}/idb-companion.universal.tar.gz"
ARCHIVE_SHA="3b72cc6a9a5b1a22a188205a84090d3a294347a846180efd755cf1a3c848e3e7"

prefix="${HOME}/.local/libexec/idb-companion"
binary="${prefix}/bin/idb_companion"

# ~/.local/bin precedes /usr/local/bin on PATH, so the symlink wins over brew's
# without uninstalling the formula.
if [[ -x $binary ]] && lipo -archs "$binary" | grep -q "x86_64"; then
  echo "✅ box: idb_companion already intel-capable"
  exit 0
fi

echo "box: installing idb_companion ${VERSION} (universal)"

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

curl -fsSL -o "${workdir}/idb.tar.gz" "$ARCHIVE_URL"

if ! echo "${ARCHIVE_SHA}  ${workdir}/idb.tar.gz" | shasum -a 256 --check --status; then
  echo "⚠️ box: idb_companion checksum mismatch, skipping"
  exit 0
fi

tar xzf "${workdir}/idb.tar.gz" -C "$workdir"

# The binary resolves Frameworks/ as a sibling of bin/, so move the whole tree.
mkdir -p "${HOME}/.local/libexec" "${HOME}/.local/bin"
rm -rf "$prefix"
mv "${workdir}/idb-companion.universal" "$prefix"
ln -sf "$binary" "${HOME}/.local/bin/idb_companion"

echo "✅ box: idb_companion installed"
