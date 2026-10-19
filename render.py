#!/usr/bin/env python3
"""Unified ORIONINSIST renderer: JSON -> selected Typst template -> PDF and PNG."""
import argparse
import json
import shutil
import struct
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def choose_font(config, data, override):
    requested = override or data.get("settings", {}).get("font_family") or config["typography"]["font_family"]
    result = subprocess.run(["typst", "fonts"], capture_output=True, text=True, check=True)
    available = {line.split(":", 1)[0].strip().casefold(): line.split(":", 1)[0].strip()
                 for line in result.stdout.splitlines() if line.strip()}
    if requested != "auto":
        if requested.casefold() not in available:
            raise ValueError(f"Font unavailable: {requested}. Check 'typst fonts'.")
        return available[requested.casefold()]
    return next((available[x.casefold()] for x in config["typography"]["preferred"]
                 if x.casefold() in available), "")


def validate_pdf(path):
    payload = path.read_bytes()
    if not payload.startswith(b"%PDF-") or len(payload) < 100:
        raise ValueError(f"Invalid PDF: {path}")
    result = subprocess.run(["pdfinfo", str(path)], capture_output=True, text=True, check=True)
    page_line = next((x for x in result.stdout.splitlines() if x.startswith("Pages:")), None)
    pages = int(page_line.split(":", 1)[1].strip()) if page_line else None
    if pages != 1:
        raise ValueError(f"Expected exactly one PDF page, found {pages}")
    print(f"PDF=PASS pages={pages} bytes={len(payload)}", flush=True)


def validate_png(path):
    payload = path.read_bytes()
    if not payload.startswith(b"\x89PNG\r\n\x1a\n") or len(payload) < 24:
        raise ValueError(f"Invalid PNG: {path}")
    width, height = struct.unpack(">II", payload[16:24])
    if not 0 < width <= 20000 or not 0 < height <= 20000:
        raise ValueError(f"Invalid PNG dimensions: {path}")
    print(f"PNG=PASS size={width}x{height} bytes={len(payload)}", flush=True)


def main():
    parser = argparse.ArgumentParser(description="JSON to validated PDF and PNG")
    parser.add_argument("--content", type=Path, default=ROOT / "examples/content.json")
    parser.add_argument("--output", type=Path, help="Output directory")
    parser.add_argument("--font", help="Installed Typst font family")
    parser.add_argument("--template", help="Override content JSON template")
    parser.add_argument("--all-templates", action="store_true",
                        help="Render every configured template, not just the selected one")
    args = parser.parse_args()

    from jsonschema import Draft202012Validator
    content_path = args.content.resolve()
    data = read_json(content_path)
    schema = read_json(ROOT / "schemas/content.schema.json")
    errors = sorted(Draft202012Validator(schema).iter_errors(data), key=lambda e: list(map(str, e.path)))
    if errors:
        for error in errors:
            print(f"SCHEMA=FAIL path={'/'.join(map(str, error.path))} reason={error.message}", file=sys.stderr)
        return 2
    print("SCHEMA=PASS", flush=True)

    for executable in ("typst", "pdfinfo"):
        if not shutil.which(executable):
            print(f"ERROR=Missing executable: {executable}", file=sys.stderr)
            return 3

    config = read_json(ROOT / "config/production.json")
    templates = config["render"]["templates"]
    selected = list(templates) if args.all_templates else [args.template or data["template"]]
    ppi = int(config["render"]["png_ppi"])
    if not 36 <= ppi <= 600:
        raise ValueError("png_ppi must be between 36 and 600")
    for name in selected:
        if name not in templates:
            raise ValueError(f"Unknown template: {name}")

    output_dir = (args.output or ROOT / config["render"]["output_dir"]).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)
    font = choose_font(config, data, args.font)
    print(f"FONT={font or 'Typst default'}", flush=True)

    # A temporary JSON copy inside ROOT supports input files located anywhere.
    # Intermediate rendered files are only moved to output after validation.
    with tempfile.TemporaryDirectory(prefix=".orion-render-", dir=ROOT) as temporary:
        work = Path(temporary)
        normalized_content = work / "content.json"
        normalized_content.write_text(json.dumps(data, ensure_ascii=False), encoding="utf-8")
        content_ref = "/" + normalized_content.relative_to(ROOT).as_posix()
        staged = []
        for name in selected:
            template = (ROOT / templates[name]).resolve()
            if not template.is_relative_to(ROOT) or not template.is_file():
                raise ValueError(f"Missing or unsafe template: {name}")
            for ext, validator in (("pdf", validate_pdf), ("png", validate_png)):
                temp_output = work / f"{name}.{ext}"
                command = ["typst", "compile", "--root", str(ROOT),
                           "--input", f"content={content_ref}", "--input", f"font={font}",
                           str(template), str(temp_output)]
                if ext == "png":
                    command += ["--ppi", str(ppi)]
                subprocess.run(command, check=True)
                validator(temp_output)
                staged.append((temp_output, output_dir / f"{name}.{ext}"))
        for source, destination in staged:
            shutil.copy2(source, destination)
            print(f"OUTPUT={destination}", flush=True)
    print(f"RENDER=PASS templates={len(selected)} files={len(selected) * 2}")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (ValueError, OSError, subprocess.CalledProcessError, json.JSONDecodeError) as error:
        sys.exit(f"RENDER=FAIL {error}")
