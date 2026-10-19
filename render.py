#!/usr/bin/env python3
"""ORIONINSIST: uv run render.py content.json instagram_story [--format png]."""
import argparse
import json
import shutil
import struct
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def load(path):
    return json.loads(path.read_text(encoding="utf-8"))


def render_image(content_file, template_name, output, format_name):
    if format_name != "png":
        raise ValueError("Only PNG is implemented. PDF, slide and video are future formats.")
    from jsonschema import Draft202012Validator

    source = content_file.resolve()
    data = load(source)
    if not isinstance(data, dict):
        raise ValueError("Content JSON must be an object")
    config = load(ROOT / "config/production.json")
    presets = config["image_templates"]
    if template_name not in presets:
        raise ValueError("Unknown image template: " + template_name + ". Available: " + ", ".join(presets))
    template = presets[template_name]
    if not isinstance(template, dict):
        raise ValueError("Invalid template configuration")
    width, height = int(template["width"]), int(template["height"])
    if not (1 <= width <= 10000 and 1 <= height <= 10000):
        raise ValueError("Invalid image dimensions")
    schema = load(ROOT / "schemas/image-content.schema.json")
    errors = sorted(Draft202012Validator(schema).iter_errors(data), key=lambda e: str(list(e.path)))
    if errors:
        raise ValueError("; ".join(f"{'/'.join(map(str,e.path))}: {e.message}" for e in errors))
    # Resolve only the selected template's text overrides; other templates stay unchanged.
    overrides = data.get("variants", {}).get(template_name, {})
    resolved = {key: data[key] for key in ("title", "subtitle", "description", "footer")}
    resolved.update({
        key: data[key]
        for key in ("category", "image", "source")
        if key in data
    })
    resolved.update(overrides)
    if resolved.get("image"):
        image_path = (ROOT / resolved["image"]).resolve()
        assets_root = (ROOT / "assets").resolve()
        if not image_path.is_relative_to(assets_root) or not image_path.is_file():
            raise ValueError("Image must exist inside assets/")
        resolved["image"] = "/" + image_path.relative_to(ROOT).as_posix()
    if not shutil.which("typst"):
        raise ValueError("Typst CLI not found (check: typst --version)")
    target = (ROOT / template["file"]).resolve()
    if not target.is_relative_to(ROOT) or not target.is_file():
        raise ValueError("Unsafe or missing image template")
    output.mkdir(parents=True, exist_ok=True)
    dest = output / (template_name + ".png")
    # Typst sizes use points; at 72 PPI the dimensions equal exact pixel values.
    with tempfile.TemporaryDirectory(prefix=".orion-", dir=ROOT) as temp:
        tmp = Path(temp)
        json_path = tmp / "content.json"
        json_path.write_text(json.dumps(resolved, ensure_ascii=False), encoding="utf-8")
        staged = tmp / "image.png"
        cmd = ["typst", "compile", "--root", str(ROOT),
               "--input", "content=/" + json_path.relative_to(ROOT).as_posix(),
               "--input", f"width={width}", "--input", f"height={height}",
               str(target), str(staged), "--ppi", "72"]
        subprocess.run(cmd, check=True)
        raw = staged.read_bytes()
        if not raw.startswith(b"\x89PNG\r\n\x1a\n") or len(raw) < 24:
            raise ValueError("Invalid PNG output")
        actual = struct.unpack(">II", raw[16:24])
        if actual != (width, height):
            raise ValueError(f"Wrong PNG dimensions: {actual} expected {(width, height)}")
        shutil.copy2(staged, dest)
    print(f"PNG=PASS template={template_name} size={width}x{height} output={dest}")
    return 0


def main():
    parser = argparse.ArgumentParser(description="Render content JSON with a named image template")
    parser.add_argument("content", type=Path, help="Path to JSON data (content.json)")
    parser.add_argument("template", help="Named template, e.g. instagram_story")
    parser.add_argument("--format", choices=["png", "pdf", "slide", "video"], default="png")
    parser.add_argument("--output", type=Path, default=ROOT / "output")
    args = parser.parse_args()
    return render_image(args.content, args.template, args.output.resolve(), args.format)


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (ValueError, OSError, json.JSONDecodeError, subprocess.CalledProcessError) as exc:
        sys.exit(f"RENDER=FAIL {exc}")
