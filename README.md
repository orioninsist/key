# Key

A Markdown-based technical knowledge base documenting Fedora Linux tools, terminal applications, configurations, troubleshooting, and verified solutions.

## Links

- [Tools and Resources](tools-and-resources.md)
- [XLSX to Markdown Conversion Script](xlsx-to-md.sh)
- [Google Sheets — Main Tracking Spreadsheet](https://docs.google.com/spreadsheets/d/1UvxeOACEU39FUg_yxQBjBMXOD9l3IN3RzekUlw3sjlk/edit)
- [GitHub Repository](https://github.com/orioninsist/key)

## Update the Tools List

Google Sheets is the source of truth for the tools list. Download the latest spreadsheet as **Microsoft Excel (.xlsx)** and save it as `Key.xlsx` in the repository root.

On Fedora Linux, the script requires Bash and [uv](https://github.com/astral-sh/uv). It uses `openpyxl` to isolate the **01 | Tools and Resources** worksheet, then [Microsoft MarkItDown](https://github.com/microsoft/markitdown) to convert it to Markdown and update `tools-and-resources.md`.

Run from the repository root:

```bash
./xlsx-to-md.sh
```

If needed, grant executable permission once with `chmod +x xlsx-to-md.sh`.

**Note:** A successful conversion overwrites the existing `tools-and-resources.md` file. The script does not modify Google Sheets or automatically commit or push changes to GitHub. Review the generated Markdown before committing and pushing the relevant files. There is no need to add `Key.xlsx` to GitHub.
