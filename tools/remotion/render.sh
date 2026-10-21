#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# templates/ altındaki geçerli şablonları keşfet
mapfile -t TEMPLATES < <(
  find templates -mindepth 2 -maxdepth 2 -name index.ts -type f |
  sed -E 's@^templates/([^/]+)/index.ts$@\1@' | sort
)

if [ "${#TEMPLATES[@]}" -eq 0 ]; then
  echo "HATA: Şablon bulunamadı."
  exit 1
fi

TEMPLATE="${1:-}"
CONTENT="${2:-}"

if [ -z "$TEMPLATE" ]; then
  echo "Şablon seç:"
  select TEMPLATE in "${TEMPLATES[@]}"; do
    [ -n "$TEMPLATE" ] && break
    echo "Geçersiz seçim."
  done
fi

if [[ ! " ${TEMPLATES[*]} " =~ " ${TEMPLATE} " ]]; then
  echo "HATA: Bilinmeyen şablon: $TEMPLATE"
  exit 1
fi

# Şablonun Composition ID değerini Root.tsx içinden oku
ROOT="templates/$TEMPLATE/Root.tsx"
if [ ! -f "$ROOT" ]; then
  echo "HATA: Root.tsx bulunamadı: $ROOT"
  exit 1
fi

COMPOSITION="$(sed -nE 's/.*id="([^"]+)".*/\1/p' "$ROOT" | head -n 1)"

if [ -z "$COMPOSITION" ]; then
  echo "HATA: Composition ID bulunamadı: $ROOT"
  exit 1
fi

if [ -z "$CONTENT" ]; then
  mapfile -t CONTENTS < <(find content -type f -name '*.json' | sort)
  if [ "${#CONTENTS[@]}" -eq 0 ]; then
    echo "HATA: JSON içeriği bulunamadı."
    exit 1
  fi
  echo "İçerik seç:"
  select CONTENT in "${CONTENTS[@]}"; do
    [ -n "$CONTENT" ] && break
    echo "Geçersiz seçim."
  done
fi

if [ ! -f "$CONTENT" ]; then
  echo "HATA: JSON dosyası bulunamadı: $CONTENT"
  exit 1
fi

mkdir -p output

OUTPUT="output/${TEMPLATE}-$(date +%Y%m%d-%H%M%S).mp4"

if [ -e "$OUTPUT" ]; then
  echo "HATA: Çıktı dosyası zaten mevcut: $OUTPUT"
  exit 1
fi

echo "Şablon: $TEMPLATE"
echo "İçerik: $CONTENT"
echo "Çıktı: $OUTPUT"

echo "Docker imajı hazırlanıyor..."
docker build -t orioninsist-remotion:latest .

echo "MP4 üretiliyor..."
docker run --rm \
  --init \
  --shm-size=2g \
  --user "$(id -u):$(id -g)" \
  -e HOME=/tmp \
  --mount type=tmpfs,destination=/app/node_modules/.cache,tmpfs-mode=1777 \
  -v "$(pwd)/content:/app/content:ro,Z" \
  -v "$(pwd)/templates:/app/templates:ro,Z" \
  -v "$(pwd)/public:/app/public:ro,Z" \
  -v "$(pwd)/output:/app/output:Z" \
  --entrypoint npx \
  orioninsist-remotion:latest \
  remotion render \
  "templates/${TEMPLATE}/index.ts" \
  "$COMPOSITION" \
  "$OUTPUT" \
  --props="$CONTENT" \
  --codec=h264 \
  --concurrency=2

echo "VIDEO: $(pwd)/$OUTPUT"
