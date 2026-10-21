#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

mapfile -t TEMPLATES < <(
  find templates -mindepth 2 -maxdepth 2 -type f -name index.ts |
  sed -E 's@^templates/([^/]+)/index.ts$@\1@' | sort
)

if [ "${#TEMPLATES[@]}" -eq 0 ]; then
  echo "HATA: Şablon bulunamadı."
  exit 1
fi

TEMPLATE="${1:-}"

if [ -z "$TEMPLATE" ]; then
  echo "Önizlenecek şablonu seç:"
  select TEMPLATE in "${TEMPLATES[@]}"; do
    [ -n "$TEMPLATE" ] && break
    echo "Geçersiz seçim."
  done
fi

if [ ! -f "templates/$TEMPLATE/index.ts" ]; then
  echo "HATA: Geçersiz şablon: $TEMPLATE"
  exit 1
fi

if [ ! -x node_modules/.bin/remotion ]; then
  echo "HATA: Yerel Remotion kurulumu bulunamadı."
  echo "Studio için önce npm ci çalıştır."
  exit 1
fi

echo "Studio başlatılıyor: $TEMPLATE"
echo "Durdurmak için Ctrl+C"

exec ./node_modules/.bin/remotion studio "templates/$TEMPLATE/index.ts"
