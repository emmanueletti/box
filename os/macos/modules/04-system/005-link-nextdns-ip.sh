#!/usr/bin/env bash
#
# Installs a cron job that refreshes the NextDNS linked IP every 5 minutes, so
# IPv4 DNS filtering survives a home public IP change. The job runs
# box-nextdns-relink, which reads the secret update url from
# ~/.config/nextdns/link-ip-url (created out of band, never committed).
#
# Skips cleanly on a fresh machine that has no url file yet -- add the file and
# rerun this step to install the cron.

set -euo pipefail

runner="${HOME}/.local/bin/box-scripts/box-nextdns-relink"
url_file="${HOME}/.config/nextdns/link-ip-url"
cron_line="*/5 * * * * ${runner} >/dev/null 2>&1"

# Every name the runner has ever had. crontab entries are matched by text, so a
# renamed script leaves the old line behind unless its old name is listed here.
markers=(box-nextdns-relink box-nextdns-link-ip)

if [[ ! -r $url_file ]]; then
  echo "⏭️  box: no ${url_file}, skipping nextdns linked-ip cron"
  echo "   add the secret link-ip url there, then rerun this step"
  exit 0
fi

current="$(crontab -l 2>/dev/null || true)"

# Drop every past and present box line, then add the current one back. Rewriting
# rather than skipping is what retires a stale entry; it is also still
# idempotent, since the line that goes back is always the same.
kept="$current"
for marker in "${markers[@]}"; do
  kept="$(grep -vF "$marker" <<<"$kept" || true)"
done

printf '%s\n' "$kept" "$cron_line" | grep -v '^[[:space:]]*$' | crontab -

echo "✅ box: nextdns linked-ip cron installed (every 5 min)"
