#!/usr/bin/env python3
"""Render JSON content with a Typst template in the official Docker image."""
import argparse
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description="Render JSON via native Typst in Docker")
    parser.add_argument("--content", default="post", help="content/<name>.json")
    parser.add_argument("--template", default="post", help="templates/<name>.typ")
    parser.add_argument("--format", choices=("png", "pdf"), default="png")
    args = parser.parse_args()

    for value in (args.content, args.template):
        if not value or Path(value).name != value or value in (".", ".."):
            parser.error("Names must be simple filenames without paths")
    source = ROOT / "content" / (args.content + ".json")
    template = ROOT / "templates" / (args.template + ".typ")
    if not source.is_file() or not template.is_file():
        parser.error(f"Missing file: {source if not source.is_file() else template}")
    try:
        json.loads(source.read_text(encoding="utf-8"))
    except (ValueError, UnicodeError) as exc:
        parser.error(f"Invalid JSON: {exc}")

    output = ROOT / "output"
    output.mkdir(exist_ok=True)
    target = output / f"{args.content}-{args.template}.{args.format}"
    command = [
        "docker", "run", "--rm",
        "-v", f"{ROOT}:/app:Z", "-w", "/app",
    ]
    if hasattr(os, "getuid"):
        command += ["--user", f"{os.getuid()}:{os.getgid()}"]
    command += [
        "ghcr.io/typst/typst:latest", "compile", "--font-path", "/app/fonts",
        "--root", "/app",
        "--input", f"content=/content/{args.content}.json",
        f"templates/{args.template}.typ", f"output/{target.name}",
    ]
    if args.format == "png":
        command += ["--ppi", "300"]
    subprocess.run(command, check=True)
    if not target.is_file() or target.stat().st_size == 0:
        raise SystemExit(f"Missing/empty output: {target}")
    print(f"Created: {target}")


if __name__ == "__main__":
    main()
