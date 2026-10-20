# Typst — native Docker rendering

Official documentation: https://typst.app/docs/  
Official source and Docker image: https://github.com/typst/typst and `ghcr.io/typst/typst`

## Requirements
- Docker Engine / Docker CLI (daemon must be running)
- Python 3 (standard library only; runs on Fedora host)

## Verify installation

```bash
docker version
docker run --rm ghcr.io/typst/typst:latest --version
python3 --version
```

## Render

From this folder:

```bash
python3 main.py
python3 main.py --format pdf
```

Output goes to the ignored `output/` folder. To change the post, edit `content/post.json`. The template is `templates/post.typ`.

The starter example produces a 259.2 pt square page at 300 PPI = 1080 × 1080 px. The same template can be exported to PDF. `--ppi` controls PNG resolution, not the document's layout dimensions.

Direct native CLI alternative, without Python:

```bash
docker run --rm -v "$PWD:/app" -w /app ghcr.io/typst/typst:latest compile templates/post.typ output/post.png --ppi 300
```

`Dockerfile` records the official image-based runtime; no Docker build is required for this basic workflow. Docker runs the official CLI as its entrypoint. The host's Python script invokes Docker; it is not installed inside the image.

## Limitations / next steps
- This initial `post.typ` intentionally loads `content/post.json`; arbitrary content-file selection is not enabled yet.
- The illustration presumes a locally available DejaVu Sans font; check actual fonts with `docker run --rm ghcr.io/typst/typst:latest fonts` and adjust if necessary.
- Test the rendering on the local Docker daemon before declaring installation verified. GitHub source updates alone cannot prove Docker runs on Fedora.

CLI: https://github.com/typst/typst  
JSON: https://typst.app/docs/reference/data-loading/json/  
PNG: https://typst.app/docs/reference/png/  
Page: https://typst.app/docs/reference/layout/page/
