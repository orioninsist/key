# ORIONINSIST Digital Production

One validated JSON input, reusable Typst templates, and checked PDF + PNG outputs.

## Prerequisites

Install Python 3, Typst CLI, Poppler (for `pdfinfo`), and Python dependency `jsonschema`.
On Debian/Ubuntu:

```bash
sudo apt update
sudo apt install -y python3 python3-venv poppler-utils
# Install Typst CLI for your platform and confirm:
typst --version
python3 -m venv .venv
source .venv/bin/activate
pip install jsonschema
```

## Render one template selected by JSON

```bash
python render.py --content examples/content.json
```

Select a template explicitly:

```bash
python render.py --content examples/content.json --template one_page_compact_v1
```

Render all templates:

```bash
python render.py --content examples/content.json --all-templates
```

Choose destination directory:

```bash
python render.py --content examples/content.json --output output/demo
```

Files are written to `output/` by default. JSON is validated using `schemas/content.schema.json`; PDF is checked with `pdfinfo` and PNG signatures/dimensions are inspected. Temporary files are cleaned up after rendering.

## Structure

- `render.py` — orchestrates validation, generation, and checks.
- `config/production.json` — template registry, font preferences, PNG PPI, output directory.
- `examples/content.json` — current content contract example.
- `schemas/content.schema.json` — JSON schema.
- `templates/` — reusable Typst templates.

## Scope

This pipeline renders text-based JSON data. Importing a user-supplied image and converting it to PDF, or OCR, is **not yet implemented**. Those require a separately defined input contract and conversion path.
