#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
mkdir -p output

echo "Docker imaji hazirlaniyor..."
docker build -t orioninsist-remotion .

echo "MP4 uretiliyor..."
docker run --rm \
  --init \
  --shm-size=2g \
  --user "$(id -u):$(id -g)" \
  -e HOME=/tmp \
  -v "$(pwd)/content:/app/content:ro,Z" \
  -v "$(pwd)/templates:/app/templates:ro,Z" \
  -v "$(pwd)/public:/app/public:ro,Z" \
  -v "$(pwd)/output:/app/output:Z" \
  orioninsist-remotion

echo "VIDEO: $(pwd)/output/video.mp4"
