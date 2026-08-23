#!/usr/bin/env bash
#
# Installs a cron job that refreshes the NextDNS linked IP every 5 minutes, so
# IPv4 DNS filtering survives a home public IP change. The job runs
# box-nextdns-link-ip, which reads the secret update url from
# ~/.config/nextdns/link-ip-url (created out of band, never committed).
#
# Skips cleanly on a fresh machine that has no url file yet -- add the file and
# rerun this step to install the cron.

set -euo pipefail

runner="${HOME}/.local/scripts/box-nextdns-link-ip"
url_file="${HOME}/.config/nextdns/link-ip-url"
cron_line="*/5 * * * * ${runner} >/dev/null 2>&1"
marker="box-nextdns-link-ip"

if [[ ! -r $url_file ]]; then
  echo "⏭️  box: no ${url_file}, skipping nextdns linked-ip cron"
  echo "   add the secret link-ip url there, then rerun this step"
  exit 0
fi

current="$(crontab -l 2>/dev/null || true)"

if grep -qF "$marker" <<<"$current"; then
  echo "✅ box: nextdns linked-ip cron already installed"
  exit 0
fi

printf '%s\n' "$current" "$cron_line" | grep -v '^[[:space:]]*$' | crontab -

echo "✅ box: nextdns linked-ip cron installed (every 5 min)"
