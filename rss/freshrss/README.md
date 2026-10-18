# ORIONINSIST | Portable FreshRSS

**Status: draft, not deployed or runtime-tested.** No GitHub push performed.

## Purpose
One FreshRSS server with SQLite for Fedora or Windows Docker Desktop (WSL 2). Browser access from the same host at <http://127.0.0.1:8080>. To read the same subscriptions on several devices, connect clients to **one** always-on server; do not run independent writable copies of the same SQLite volume.

## Prerequisites
- Fedora: Docker Engine and Docker Compose plugin installed and started; check `docker version` and `docker compose version`.
- Windows: Docker Desktop with WSL 2 backend and Linux containers enabled; check `docker version` and `docker compose version` in PowerShell.
- Free port 8080, or change `FRESHRSS_PORT`.

## Install (Fedora Bash or Windows PowerShell)
```sh
cd rss/freshrss
```
Copy `.env.example` to `.env` (Fedora: `cp .env.example .env`; PowerShell: `Copy-Item .env.example .env`). Then:
```sh
docker compose config
docker compose pull
docker compose up -d
docker compose ps
```
Open <http://127.0.0.1:8080>, finish the FreshRSS web installer, choose **SQLite** and create your admin account with a strong password. Do not put credentials in Git.

## Import feeds
Use the FreshRSS subscription management import option to import `opml/starter-feeds.opml`. These **11 candidate URLs were copied from the existing 04 spreadsheet**; feed availability has not been checked. Inspect existing subscriptions first to avoid duplicates. Existing Miniflux subscriptions are **not automatically migrated** by this starter file; export your full Miniflux OPML separately and review before import.

## Backup and restore
- `scripts/backup.sh` (Bash on Fedora, or from WSL/Git Bash with Docker Desktop integration) stops FreshRSS briefly and archives **both named volumes** under ignored `backups/`.
- Store backups in private encrypted storage **outside GitHub**, and keep a second offline copy. Verify archive and perform a test restore before relying on backups.
- `docker compose down` stops the stack without deleting volumes. **Never use `down -v` unless you intend to destroy data.**
- `scripts/restore.sh backups/<archive>.tar.gz` restores both volumes **destructively** after confirmation, while stack is stopped. Test only on a disposable installation first. Restore overwrites current data.
- These scripts require Bash, Docker, a working daemon, and internet access for `alpine:3.21` on first use. They have not been executed against a FreshRSS server.
- OPML exports subscriptions only; the volume archive is needed for account/configuration/SQLite/read-state retention.

## Remote access
The Compose port is deliberately bound to `127.0.0.1` only. Do **not** expose port 8080 directly to the public internet. For private remote access, configure Tailscale Serve or a suitable authenticated private reverse proxy **as a separate, reviewed step**. No Tailscale configuration is included or tested here.

## Safety / portability
- `.env`, backup archives, credentials, tokens, and personal database files are ignored by Git.
- `latest` tracks FreshRSS releases; pin an exact image version or digest after the first successful test for reproducibility.
- Windows PowerShell can run Docker Compose; backup/restore `.sh` scripts require Bash in WSL or Git Bash.
- Do not run simultaneous server instances with copied SQLite data and expect automatic synchronization.

Official documentation: <https://github.com/FreshRSS/FreshRSS/blob/edge/Docker/README.md>
