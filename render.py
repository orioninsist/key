#!/usr/bin/env python3
"""ORIONINSIST: one content contract, central config, multiple Typst templates."""
import argparse
import json
import shutil
import struct
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def load_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def choose_font(config, data, override):
    requested = override or data.get("settings", {}).get("font_family") or config["typography"]["font_family"]
    fonts = subprocess.run(["typst", "fonts"], capture_output=True, text=True, check=True).stdout
    available = {line.split(":", 1)[0].strip().casefold(): line.split(":", 1)[0].strip()
                 for line in fonts.splitlines() if line.strip()}
    if requested != "auto":
        if requested.casefold() not in available:
            raise ValueError(f"Font unavailable: {requested}. Check 'typst fonts'.")
        return available[requested.casefold()]
    return next((available[x.casefold()] for x in config["typography"]["preferred"]
                 if x.casefold() in available), "")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--content", type=Path, default=ROOT / "examples/content.json")
    ap.add_argument("--output", type=Path)
    ap.add_argument("--font")
    ap.add_argument("--template", choices=["one_page_v1", "one_page_compact_v1"],
                    help="Render only this template; default renders every configured template")
    args = ap.parse_args()
    from jsonschema import Draft202012Validator
    data = load_json(args.content)
    schema = load_json(ROOT / "schemas/content.schema.json")
    errors = sorted(Draft202012Validator(schema).iter_errors(data), key=lambda e: list(map(str, e.path)))
    if errors:
        for error in errors:
            print(f"SCHEMA=FAIL path={'/'.join(map(str, error.path))} reason={error.message}", file=sys.stderr)
        return 2
    print("SCHEMA=PASS", flush=True)
    if not shutil.which("typst"):
        print("ERROR=Typst executable not found", file=sys.stderr)
        return 3
    config = load_json(ROOT / "config/production.json")
    templates = config["render"]["templates"]
    selected = [args.template] if args.template else list(templates)
    font = choose_font(config, data, args.font)
    print(f"FONT={font or 'Typst default'}", flush=True)
    content = args.content.resolve()
    try:
        content_ref = "/" + content.relative_to(ROOT.resolve()).as_posix()
    except ValueError:
        print("ERROR=Content must be within the production root", file=sys.stderr)
        return 4
    output_dir = args.output or ROOT / config["render"]["output_dir"]
    output_dir.mkdir(parents=True, exist_ok=True)
    ppi = int(config["render"]["png_ppi"])
    if ppi < 36 or ppi > 600:
        raise ValueError("png_ppi must be between 36 and 600")
    for name in selected:
        if name not in templates:
            raise ValueError(f"Unknown template: {name}")
        template = (ROOT / templates[name]).resolve()
        if not template.is_relative_to(ROOT.resolve()) or not template.is_file():
            raise ValueError(f"Missing or unsafe template: {name}")
        for ext in ("pdf", "png"):
            destination = output_dir / f"{name}.{ext}"
            cmd = ["typst", "compile", "--root", str(ROOT), "--input", f"content={content_ref}",
                   "--input", f"font={font}", str(template), str(destination)]
            if ext == "png":
                cmd += ["--ppi", str(ppi)]
            subprocess.run(cmd, check=True)
            b = destination.read_bytes()
            if ext == "pdf":
                if not b.startswith(b"%PDF-") or len(b) < 100:
                    raise ValueError(f"Invalid PDF: {destination}")
                print(f"PDF=PASS template={name} bytes={len(b)}", flush=True)
            else:
                if not b.startswith(b"\x89PNG\r\n\x1a\n") or len(b) < 24:
                    raise ValueError(f"Invalid PNG: {destination}")
                w, h = struct.unpack(">II", b[16:24])
                if not 0 < w <= 20000 or not 0 < h <= 20000:
                    raise ValueError(f"Invalid PNG dimensions: {destination}")
                print(f"PNG=PASS template={name} bytes={len(b)} size={w}x{h}", flush=True)
    print(f"RENDER=PASS templates={len(selected)} files={len(selected)*2} output={output_dir}")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (ValueError, OSError, subprocess.CalledProcessError) as e:
        sys.exit(f"RENDER=FAIL {e}")
