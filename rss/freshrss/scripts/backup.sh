#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p backups
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
archive="backups/freshrss-${stamp}.tar.gz"
# Stop the writer before copying SQLite and application configuration.
docker compose stop freshrss
trap 'docker compose start freshrss >/dev/null' EXIT
# Both named volumes are included, not only OPML subscriptions.
docker run --rm \
  -v orioninsist-rss_freshrss_data:/backup-data:ro \
  -v orioninsist-rss_freshrss_extensions:/backup-extensions:ro \
  -v "$(pwd)/backups:/out" alpine:3.21 \
  tar -czf "/out/$(basename "$archive")" -C / backup-data backup-extensions
printf 'Backup created: %s\n' "$archive"
