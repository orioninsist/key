#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

TEMPLATE="${1:-basic}"
CONTENT="${2:-content/content.json}"

case "$TEMPLATE" in
  basic)
    COMPOSITION="BasicVideo"
    ;;
  showcase)
    COMPOSITION="ShowcaseVideo"
    ;;
  *)
    echo "HATA: Bilinmeyen şablon: $TEMPLATE"
    exit 1
    ;;
esac

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
