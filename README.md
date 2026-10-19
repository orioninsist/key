# ORIONINSIST — image-first production

Fedora, uv and Typst. Content is **JSON** (`.json`), not JavaScript (`.js`). The CLI stays stable as we add formats.

## Install on Fedora

```sh
sudo dnf install -y uv typst
```

If uv or typst isn't provided by your Fedora release's configured repositories, install it using its official Fedora-compatible installer/package.

## PNG (implemented)

```sh
uv run render.py content.json instagram_story
uv run render.py content.json pinterest_pin
uv run render.py content.json instagram_post
uv run render.py content.json instagram_square
uv run render.py content.json landscape_4_3
```

`--format png` is optional. By default only ONE PNG is produced per invocation in `output/<template>.png`. Template presets and pixel dimensions live in `config/production.json`.

## Later

```sh
uv run render.py content.json instagram_story --format pdf
uv run render.py content.json deck --format slide
uv run render.py content.json reel --format video
```

PDF, slide and video are **not implemented**; they fail explicitly.

## Notes

- `content.json` contains text. `templates/social_image.typ` controls visual layout; registry controls width/height.
- No `pip install` required: `uv run` resolves Python dependency from `pyproject.toml`.
- Intermediate files are temporary; outputs are checked for correct PNG signature and exact pixel dimensions.
- Legacy one-page files remain in the repository but the image-first CLI replaces its earlier flags.
