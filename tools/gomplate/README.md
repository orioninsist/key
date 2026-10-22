# Gomplate — Markdown Renderer

Render Markdown from JSON using the official Gomplate Docker image. No host installation of Gomplate, Dockerfile, or Docker Compose is required.

## Requirements

- Docker Engine

## Quick start

Clone the repository and enter the project directory:

```bash
git clone https://github.com/orioninsist/key.git
cd key/tools/gomplate
```

Render the example:

```bash
docker run --rm \
  -v "$PWD:/work:Z" \
  -w /work \
  hairyhenderson/gomplate \
  --datasource content=file:///work/content/example.json \
  --file templates/github-flavored-markdown.md.tmpl \
  --out output/example.md
```

The generated file is `output/example.md`. Docker downloads the official image automatically if it is not already available.

**Fedora / SELinux:** `:Z` relabels the bind-mounted directory for private container access. Evaluate its impact before using it on shared directories. On systems without SELinux, omit `:Z` if unsupported.

## Directories

- `content/` — JSON input
- `templates/` — Gomplate templates
- `output/` — generated Markdown (must exist and be writable)

To use a different JSON file or template, change the corresponding paths in the command.

**Workflow:** JSON + Template → Gomplate → Markdown
