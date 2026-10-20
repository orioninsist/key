#!/usr/bin/env python3
"""Select content + template; render via the official Typst Docker image."""
import argparse
import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description="Render Typst templates from JSON using Docker")
    parser.add_argument("--content", default="post", help="JSON name under content/ (without .json)")
    parser.add_argument("--template", default="post", help="Typst name under templates/ (without .typ)")
    parser.add_argument("--format", choices=("png", "pdf"), default="png")
    args = parser.parse_args()

    for value in (args.content, args.template):
        if not value or Path(value).name != value or value in (".", ".."):
            parser.error("content and template must be simple file names")
    source = ROOT / "content" / (args.content + ".json")
    template = ROOT / "templates" / (args.template + ".typ")
    if not source.is_file() or not template.is_file():
        parser.error(f"missing source: {source if not source.is_file() else template}")
    try:
        json.loads(source.read_text(encoding="utf-8"))
    except (ValueError, UnicodeError) as exc:
        parser.error(f"invalid JSON: {exc}")

    # Typst templates load ../content/post.json; for other content names we pass
    # the chosen JSON as an explicit CLI input and decode it in the template.
    # Keep post.typ and the default JSON path as an immediately usable first example.
    if args.content != "post":
        parser.error("The starter post.typ template currently reads content/post.json; use --content post")

    output = ROOT / "output"
    output.mkdir(exist_ok=True)
    target = output / f"{args.content}-{args.template}.{args.format}"
    command = [
        "docker", "run", "--rm", "--user", f"{__import__('os').getuid()}:{__import__('os').getgid()}",
        "-v", f"{ROOT}:/app", "-w", "/app", "ghcr.io/typst/typst:latest",
        "compile", f"templates/{args.template}.typ", f"output/{target.name}",
    ]
    if args.format == "png":
        command += ["--ppi", "300"]
    subprocess.run(command, check=True)
    if not target.is_file() or target.stat().st_size == 0:
        raise SystemExit(f"Missing/empty output: {target}")
    print(f"Created: {target}")


if __name__ == "__main__":
    main()
