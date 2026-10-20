# Typst — JSON + template + native Docker CLI

[Official source](https://github.com/typst/typst) · [Official documentation](https://typst.app/docs/) · [JSON API](https://typst.app/docs/reference/data-loading/json/) · [PNG output](https://typst.app/docs/reference/png/)

## Requirements and verification (Fedora)

Docker Engine/CLI with a running Docker daemon, and Python 3 (standard library only) on the host. Docker runs the official Typst image. Python is **not** required inside the image.

```bash
docker version
docker run --rm ghcr.io/typst/typst:latest --version
python3 --version
```

## Produce an image with one command

```bash
cd tools/typst
python3 main.py
```

Output: `output/post-post.png` (1080 × 1080 pixels, from a 259.2pt square at 300 PPI).

Other content with the **same JSON keys** (`kategori`, `baslik`, `icerik`, `tarih`):

```bash
python3 main.py --content announcement --template post --format png
python3 main.py --content post --template post --format pdf
```

For the first command create `content/announcement.json` first. Templates load the selected content through native Typst `sys.inputs` and `json`. The script validates input JSON, calls the Docker CLI, and checks the result. No extra Python libraries are needed. Generated files belong in the git-ignored `output/` directory.

## Direct CLI (optional)

```bash
mkdir -p output
docker run --rm -v "$PWD:/app" -w /app ghcr.io/typst/typst:latest compile --root /app --input content=/content/post.json templates/post.typ output/post.png --ppi 300
```

## Dockerfile

`Dockerfile` identifies the official Typst image as this workspace's native runtime. No custom image build is required in the basic workflow. The official image already exposes the Typst CLI as its entrypoint.

## Verification boundary

Source files have been added to GitHub, but Docker execution and PNG dimension checks must run on your Fedora system or CI to confirm end-to-end behavior. The exact resolved `latest` version can change; pin an image digest after the first successful verification for repeatable builds.
