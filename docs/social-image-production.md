# Social Image Production

Guide to creating social media PNG images from JSON content using Python, uv, and Typst.

## Table of contents

1. [Overview](#1-overview)
2. [Requirements](#2-requirements)
3. [Quick start](#3-quick-start)
4. [Project directory and file reference](#4-project-directory-and-file-reference)
5. [Content JSON and variants](#5-content-json-and-variants)
6. [Image templates and aspect ratios](#6-image-templates-and-aspect-ratios)
7. [Visual design](#7-visual-design)
8. [CLI options and validation](#8-cli-options-and-validation)
9. [GitHub and output policy](#9-github-and-output-policy)
10. [Current limitations and future work](#10-current-limitations-and-future-work)

## 1. Overview

ORIONINSIST Digital Production is an image-first system that turns reusable JSON text into social-media PNG graphics using Python, uv, and Typst.

**Workflow:** `content/*.json` → `render.py` → schema validation → Typst layout → verified `output/*.png`.

One content file can produce multiple aspect ratios. The current implementation creates **one PNG per command**.

## 2. Requirements

- Python 3.11 or newer
- [uv](https://docs.astral.sh/uv/)
- [Typst CLI](https://typst.app/) on your PATH

Use `uv run`; Python dependencies are declared in `pyproject.toml`.

## 3. Quick start

Run from the repository root:

```bash
uv run render.py content/work-smarter.json instagram_post
```

Output: `output/instagram_post.png` (1080 × 1350 pixels).

For Pinterest, using the same source:

```bash
uv run render.py content/work-smarter.json pinterest_pin
```

Output: `output/pinterest_pin.png` (1000 × 1500 pixels).

To make a new post, create a new named JSON file under `content/`, then pass its path to the command. The filename is not fixed.

## 4. Project directory and file reference

| Path | Purpose | GitHub policy |
| --- | --- | --- |
| `content/` | Archive of reusable JSON posts and campaigns. Keep one named file per content item. | Commit |
| `content/work-smarter.json` | Existing sample content, including per-template title overrides. | Commit |
| `config/` | Production configuration directory. | Commit |
| `config/production.json` | Maps template names to a Typst file and exact pixel dimensions. | Commit |
| `schemas/` | JSON validation rules. | Commit |
| `schemas/image-content.schema.json` | **Active** PNG content schema used by `render.py`. | Commit |
| `schemas/content.schema.json` | **Legacy** one-page PDF schema; not used by the active PNG renderer. | Commit while retained |
| `templates/` | Typst visual layouts. | Commit |
| `templates/social_image.typ` | **Active** shared monochrome PNG layout for every size. | Commit |
| `docs/` | Documentation and wiki-style reference pages. | Commit |
| `docs/social-image-production.md` | This guide to the social image production workflow. | Commit |
| `README.md` | Short GitHub landing page that links here. | Commit |
| `render.py` | CLI: loads JSON, validates it, selects a preset, compiles with Typst, and verifies PNG output. | Commit |
| `pyproject.toml` | Python version requirement, project metadata, and `jsonschema` dependency. | Commit |
| `uv.lock` | Resolved dependency versions, if present. | Commit |
| `.gitignore` | Excludes generated output and local environment files from Git. | Commit |
| `output/` | Locally generated images; automatically created by the renderer. | **Do not commit** |

Old `examples/content.json` and `templates/one_page_v1.typ` / `templates/one_page_compact_v1.typ` were removed. They are not needed for PNG production.

## 5. Content JSON and variants

The existing `content/work-smarter.json` has this structure:

```json
{
  "title": "Work Smarter.",
  "subtitle": "Digital Production",
  "description": "One content file. Reusable templates. Pixel-accurate images.",
  "footer": "ORIONINSIST",
  "variants": {
    "instagram_story": { "title": "Create Once. Publish Everywhere." },
    "instagram_post": { "title": "Create Once." },
    "pinterest_pin": { "title": "Publish Everywhere." }
  }
}
```

- `title`: main heading.
- `subtitle`: secondary heading.
- `description`: supporting text.
- `variants`: optional text overrides for named presets; fields not overridden keep their base values.
- `footer`: required by the current schema and read by the renderer, **but not shown by the current visual template**.

The active schema requires the four base text fields. Do not remove `footer` from JSON until the renderer and schema have been updated together.

Store future posts as files such as `content/ai-automation.json` or `content/productivity-tips.json`. Each is a separate reusable content record.

## 6. Image templates and aspect ratios

| Preset | Aspect ratio | Pixel dimensions | Use |
| --- | --- | --- | --- |
| `instagram_story` | 9:16 | 1080 × 1920 | Vertical Instagram Story |
| `instagram_post` | 4:5 | 1080 × 1350 | Instagram portrait feed |
| `instagram_square` | 1:1 | 1080 × 1080 | Square feed image |
| `pinterest_pin` | 2:3 | 1000 × 1500 | Pinterest Pin |
| `landscape_4_3` | 4:3 | 1200 × 900 | Landscape image |

All five names point to `templates/social_image.typ` in `config/production.json`. The registry controls the dimensions; the Typst file controls the look.

## 7. Visual design

The active design uses a black background, white title/subtitle/description text, and the fixed text **orioninsist.com** centered at the bottom. There is no separate logo or brand label.

- Edit `content/*.json` to change the words.
- Edit `templates/social_image.typ` to change typography or layout.
- Edit `config/production.json` to change preset dimensions.

## 8. CLI options and validation

```text
uv run render.py CONTENT_JSON TEMPLATE_NAME [--format png] [--output DIRECTORY]
```

- `CONTENT_JSON`: path to any valid source JSON file.
- `TEMPLATE_NAME`: one of the five registered presets.
- `--format png`: optional; PNG is the only implemented format.
- `--output DIRECTORY`: optional output directory; defaults to `output/`.

The renderer validates input with `schemas/image-content.schema.json`, compiles the Typst layout, and checks the PNG signature and exact width and height. Temporary render files are cleaned up.

Success prints `PNG=PASS`. Errors print `RENDER=FAIL`. Rendering the same preset again replaces the corresponding PNG file in the chosen output directory.

## 9. GitHub and output policy

The project uses a single branch: **`master`**.

Commit source code, configuration, schemas, templates, documentation, and reusable JSON files under `content/`.

**Do not commit generated `output/` files.** The repository's `.gitignore` excludes that directory. Previously tracked files, if any, must be explicitly removed from Git tracking; ignore rules alone do not untrack them.

## 10. Current limitations and future work

PNG generation is implemented. PDF, slides, and video are **not yet implemented** in the current CLI, even though their names are accepted by the `--format` argument. They currently fail explicitly.

The old `schemas/content.schema.json` is retained only as a legacy PDF-era file and is not used by the PNG workflow.

The near-term goal is to keep the JSON-driven PNG workflow simple, predictable, and reusable.

## 11. Docker and Docker Compose

The PNG renderer can run inside a Linux container without installing Python,
uv, or Typst on the host computer. This is useful on Fedora and Windows
with Docker Desktop.

### Build the image

Run from the repository root:

```bash
docker compose build png-renderer
```

### Render the default Instagram Story

```bash
docker compose run --rm --no-deps png-renderer
```

This uses `content/work-smarter.json` and the `instagram_story` preset
defined in `compose.yaml`.

### Render another preset

```bash
docker compose run --rm --no-deps png-renderer content/work-smarter.json instagram_square --format png
```

Replace the JSON path and preset name as needed. The JSON file must be
included in the Docker image; rebuild the image after changing source
content, templates, configuration, or renderer code.

### Output files

Generated PNGs appear in the host's `output/` directory through a
Docker bind mount. They are excluded from Git.

On Fedora, the `:Z` mount option provides the SELinux label needed for
container access. Docker Desktop on Windows runs Linux containers and
uses the same Compose configuration.

The renderer is a one-off job, not a persistent web service. It opens
no network ports and is separate from the FreshRSS Compose project.

### Current Docker limitations

The image currently targets Linux AMD64. The Docker build downloads
Typst 0.15.0 and installs the Python dependencies from `uv.lock`.

Only PNG production is implemented. PDF, slides, video, and GUI-based
production tools will require separate implementation and testing.
