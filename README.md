# ORIONINSIST Digital Production

A small, **image-first digital production pipeline** for creating social media graphics from reusable JSON content and Typst layouts.

**Current status:** PNG rendering works. PDF, slide, and video output are planned but **not implemented** in the current CLI.

## How it works

```text
content.json  ───────────────┐
                             ▼
config/production.json → render.py → JSON validation → Typst → verified PNG
                             ▲                         │
schemas/image-content.schema.json                     │
templates/social_image.typ ────────────────────────────┘
```

- **Content** lives in JSON, independently of the design.
- **Template names** select a predefined width and height.
- **One shared Typst layout** draws all current image sizes.
- **Validation** checks the input JSON and verifies the PNG signature and exact pixel dimensions.
- **One command produces one image** in `output/`.

## Requirements

- Fedora Linux (or another system with the required tools)
- Python 3.11 or newer, managed through [uv](https://docs.astral.sh/uv/)
- [Typst](https://typst.app/) CLI available on your `PATH`

The Python dependency (`jsonschema`) is declared in `pyproject.toml`; **do not use `pip install`** for this workflow. Run the commands with `uv run`.

## Quick start

Run from the repository root:

```bash
uv run render.py content.json instagram_post
```

Expected success output resembles:

```text
PNG=PASS template=instagram_post size=1080x1350 output=/path/to/project/output/instagram_post.png
```

The file is saved as `output/instagram_post.png`. The command fails with `RENDER=FAIL` if validation, Typst compilation, or output verification fails.

### Available image templates

| Template argument | Aspect ratio | Pixels | Typical use |
| --- | --- | --- | --- |
| `instagram_story` | 9:16 | 1080 × 1920 | Instagram Story / vertical creative |
| `instagram_post` | 4:5 | 1080 × 1350 | Instagram portrait feed post |
| `instagram_square` | 1:1 | 1080 × 1080 | Instagram square post |
| `pinterest_pin` | 2:3 | 1000 × 1500 | Pinterest Pin |
| `landscape_4_3` | 4:3 | 1200 × 900 | General landscape graphic |

For example:

```bash
uv run render.py content.json instagram_story
uv run render.py content.json pinterest_pin
```

The template name determines the image dimensions; you do **not** need a separate JSON file for each aspect ratio.

### Content and per-template variants

Edit the root `content.json`:

```json
{
  "title": "Work Smarter.",
  "subtitle": "Digital Production",
  "description": "One content file. Multiple image formats.",
  "footer": "ORIONINSIST",
  "variants": {
    "instagram_story": { "title": "Create Once. Publish Everywhere." },
    "instagram_post": { "title": "Create Once." },
    "pinterest_pin": { "title": "Publish Everywhere." }
  }
}
```

The four base text fields are currently required by the JSON schema. `variants` is optional. Each variant may override any subset of `title`, `subtitle`, `description`, and `footer`; unspecified fields inherit the base values.

**Important:** The current monochrome Typst layout displays `title`, `subtitle`, and `description`. It does **not** display the JSON `footer` value. That field remains required for compatibility with the current schema and renderer.

### Visual design

All five image presets currently use `templates/social_image.typ`:

- Black background and white typography
- Title, subtitle, and description from the resolved JSON content
- **`orioninsist.com` centered at the bottom**, with no separate brand wordmark
- Dimensions supplied by the selected preset in `config/production.json`

To change the visual layout, edit the Typst template. To add or adjust image sizes, edit the template registry in `config/production.json`. To change the message, edit `content.json`.

## Project structure

```text
.
├── render.py                         # CLI: reads JSON, validates, renders, verifies PNG
├── content.json                      # Active example content and template-specific variants
├── pyproject.toml                    # Python version and uv-managed dependencies
├── uv.lock                           # Locked dependency versions, when present
├── README.md                         # Project documentation
├── config/
│   └── production.json               # Template names, Typst file paths, pixel dimensions
├── schemas/
│   ├── image-content.schema.json     # Active schema for social image content
│   └── content.schema.json           # Legacy one-page PDF schema, if retained
├── templates/
│   ├── social_image.typ              # Active black-and-white social image design
│   ├── one_page_v1.typ               # Legacy PDF template, if retained
│   └── one_page_compact_v1.typ       # Legacy compact PDF template, if retained
├── examples/
│   └── content.json                  # Legacy one-page example, if retained
└── output/                            # Generated images and any older local outputs
```

**Active PNG pipeline:** `render.py`, root `content.json`, `config/production.json`, `schemas/image-content.schema.json`, `templates/social_image.typ`, and `pyproject.toml`.

The older one-page PDF files are **not used** by the current `render.py`. They may already have been removed during repository cleanup; their presence is not required for PNG production. Previously generated PDFs in `output/` are also not evidence that the current CLI supports PDF generation.

## CLI reference

```text
uv run render.py CONTENT_JSON TEMPLATE_NAME [--format png] [--output DIRECTORY]
```

- `CONTENT_JSON`: path to the source JSON file.
- `TEMPLATE_NAME`: a key from `config/production.json` → `image_templates`.
- `--format`: defaults to `png`. The parser also recognizes `pdf`, `slide`, and `video`, but those formats currently raise an error.
- `--output`: optional output directory; defaults to `output/`.

Intermediate render files are created in a temporary directory and cleaned up after the command finishes. A successful render validates both the PNG file header and its pixel dimensions.

## Development conventions

- **Single branch:** make ongoing project changes on `master`.
- **One JSON source per campaign:** use `variants` when a platform needs different copy.
- **Shared visual rules:** keep the monochrome social design consistent across aspect ratios.
- **Image-first roadmap:** complete and stabilize PNG production before implementing PDF, slides, or video.
