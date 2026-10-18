#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 1 || ! -f "$1" ]]; then
  echo 'Usage: scripts/restore.sh backups/freshrss-YYYYMMDDTHHMMSSZ.tar.gz' >&2
  exit 2
fi
cd "$(dirname "$0")/.."
archive="$(realpath "$1")"
# Refuse to overwrite an active installation.
if [[ -n "$(docker compose ps -q --status running)" ]]; then
  echo 'Stop the FreshRSS stack before restore: docker compose down' >&2
  exit 1
fi
# Ensure volumes exist; do not start FreshRSS yet.
docker volume create orioninsist-rss_freshrss_data >/dev/null
docker volume create orioninsist-rss_freshrss_extensions >/dev/null
# Verify archive layout and reject unexpected paths.
entries="$(tar -tzf "$archive")"
if printf '%s\n' "$entries" | grep -Ev '^backup-(data|extensions)(/|$)' | grep -q .; then
  echo 'Unexpected archive paths. Restore aborted.' >&2; exit 1
fi
printf 'WARNING: this will overwrite the FreshRSS volumes. Type RESTORE to proceed: '
read -r confirmation
[[ "$confirmation" == RESTORE ]] || exit 1
docker run --rm \
  -v orioninsist-rss_freshrss_data:/backup-data \
  -v orioninsist-rss_freshrss_extensions:/backup-extensions \
  -v "$(dirname "$archive"):/in:ro" alpine:3.21 sh -ec '
    rm -rf /backup-data/* /backup-extensions/*
    tar -xzf "/in/$1" -C /
  ' sh "$(basename "$archive")"
echo 'Restore complete. Run: docker compose up -d'
