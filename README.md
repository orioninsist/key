# ORIONINSIST Digital Production

Local-first, modular digital content production.

**One Content Source. Independent Modules. Reusable Templates. One Command.**

## Architecture

Content JSON → CLI → Selected Module → Native Renderer → Output

Each production module owns its renderer, templates, configuration,
schemas, dependencies, and tests.

Modules are independent and can be added, modified, or removed without
requiring changes to unrelated production modules.

## Directories

- `content/` — Reusable JSON content.
- `assets/` — Shared source assets.
- `modules/` — Independent production modules.
- `output/` — Generated files, excluded from Git.

## Image Module

The first implemented module generates PNG images using Typst.

Requirements:
- Fedora Linux or another compatible environment
- Python 3.11+
- uv
- Typst CLI

Example:

```bash
uv run --frozen modules/image/render.py content/work-smarter.json instagram_story
```

Available presets are defined in:

`modules/image/config/production.json`

Image layouts are defined in:

`modules/image/templates/`

## Development Principles

- Automation first
- Independent modules
- Native tools and configurations
- Minimal orchestration
- No mandatory cloud services
- No mandatory containers
- Reproducible CLI workflows
- No unnecessary infrastructure

## Status

- Image: PNG production implemented and tested.
- Other formats: Not yet implemented.

## Repository

https://github.com/orioninsist/orioninsist-digital-production
