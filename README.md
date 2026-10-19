# ORIONINSIST Digital Production

A simple **JSON → Typst → PNG** production tool for Instagram, Pinterest, and other social media images.

**Status:** PNG generation is working. PDF, slides, and video are not implemented yet.

## Quick start

Requirements: Python 3.11+, [uv](https://docs.astral.sh/uv/), and the [Typst CLI](https://typst.app/) installed and available on your PATH.

From the repository root, run:

```bash
uv run render.py content/work-smarter.json instagram_post
```

The generated image is saved to `output/instagram_post.png`.

To create another format from **the same JSON file**:

```bash
uv run render.py content/work-smarter.json pinterest_pin
```

`uv run` installs/resolves the Python dependencies specified in `pyproject.toml`. The CLI validates the JSON, renders the image using Typst, and checks the PNG signature and exact dimensions. It prints `PNG=PASS` on success or `RENDER=FAIL` on failure.

## Project folders and files

| Path | What it does | GitHub |
| --- | --- | --- |
| `content/` | Stores source JSON content. Create a separate named file for each post or campaign, such as `work-smarter.json`. | Tracked |
| `content/work-smarter.json` | Current example post: title, subtitle, description, and optional platform-specific text. | Tracked |
| `config/` | Stores production settings. | Tracked |
| `config/production.json` | Defines template names, image widths/heights, and which Typst layout to use. | Tracked |
| `schemas/` | Stores JSON validation rules. | Tracked |
| `schemas/image-content.schema.json` | Validates the content fields used by the PNG renderer. | Tracked |
| `schemas/content.schema.json` | Old one-page PDF content schema; **not used by the current PNG CLI**. | Tracked (legacy) |
| `templates/` | Stores the visual designs. | Tracked |
| `templates/social_image.typ` | Active black-and-white layout shared by every image size. | Tracked |
| `render.py` | Command-line program that loads JSON, selects a preset, validates, renders, and verifies a PNG. | Tracked |
| `pyproject.toml` | Project metadata, Python requirement, and `jsonschema` dependency. | Tracked |
| `README.md` | This guide. | Tracked |
| `.gitignore` | Prevents generated output and local environment folders from being added to Git. | Tracked |
| `output/` | Locally generated PNG files; created when rendering. | **Ignored** |

The former `examples/content.json` and `templates/one_page*.typ` files have been removed. The remaining `schemas/content.schema.json` is legacy and can be removed later; it is not needed to create PNG images.

**Key rule:** Source files and JSON content are committed to GitHub. Generated images inside `output/` stay on your computer.

## Image sizes

All presets use the same `templates/social_image.typ` design.

| Template name | Ratio | Output size |
| --- | --- | --- |
| `instagram_story` | 9:16 | 1080 × 1920 |
| `instagram_post` | 4:5 | 1080 × 1350 |
| `instagram_square` | 1:1 | 1080 × 1080 |
| `pinterest_pin` | 2:3 | 1000 × 1500 |
| `landscape_4_3` | 4:3 | 1200 × 900 |

The preset name selects the size, and the PNG is written as `output/<template-name>.png`. Rendering the same preset again overwrites that output file.

## How JSON content works

Every post can have its own file in `content/`. **The filename is your choice**; the CLI reads the path you pass to it.

For example, `content/work-smarter.json`:

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
- `variants`: optional changes for individual image presets. All other fields inherit their main values.
- `footer`: currently required by the schema, but **not displayed** by the current design.

You can create `content/another-post.json` and render it without changing the program:

```bash
uv run render.py content/another-post.json instagram_square
```

## Visual style

The shared Typst design uses a **black background**, **white text**, and a centered **orioninsist.com** at the bottom. The website text is built into the Typst layout; it is not read from the JSON `footer` field.

Change the text in `content/*.json`. Change the design in `templates/social_image.typ`. Change the sizes in `config/production.json`.

## Command options

```text
uv run render.py CONTENT_FILE TEMPLATE_NAME [--format png] [--output DIRECTORY]
```

- `CONTENT_FILE`: the JSON file to render.
- `TEMPLATE_NAME`: one of the five presets above.
- `--format png`: optional; PNG is the default and only implemented format.
- `--output DIRECTORY`: optional output folder; defaults to `output/`.

Although `pdf`, `slide`, and `video` are accepted as format names, they currently return an explicit error instead of generating a file.

## Project workflow

Work on the single `master` branch. Save reusable JSON content and source code in GitHub. Keep generated `output/` files local. Add future production formats only after the PNG workflow is stable.
