#!/usr/bin/env bash

# Key: Google Sheets XLSX -> Markdown
# Fedora Linux / Bash / uv / MarkItDown

main() {
    local root source target tmpdir count status=0

    root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)" || return 1

    source="$root/Key.xlsx"
    target="$root/tools-and-resources.md"

    if [[ ! -f "$source" ]]; then
        printf 'HATA: Key.xlsx bulunamadı.\n'
        return 1
    fi

    if ! command -v uv >/dev/null 2>&1; then
        printf 'HATA: uv kurulu değil.\n'
        return 1
    fi

    tmpdir="$(mktemp -d)" || return 1

    if KEY_SOURCE="$source" KEY_TEMP="$tmpdir/selected.xlsx" \
        uv run --no-project --with openpyxl python - <<'PY'
import os
from openpyxl import load_workbook

source = os.environ["KEY_SOURCE"]
target = os.environ["KEY_TEMP"]
sheet_name = "01 | Tools and Resources"

wb = load_workbook(source)

if sheet_name not in wb.sheetnames:
    raise SystemExit(f"HATA: Sekme bulunamadı: {sheet_name}")

for ws in list(wb.worksheets):
    if ws.title != sheet_name:
        wb.remove(ws)

ws = wb[sheet_name]

count = sum(
    any(
        cell.value is not None and str(cell.value).strip()
        for cell in row
    )
    for row in ws.iter_rows()
)

print(f"Sekme: {sheet_name}")
print(f"Dolu satır: {count}")

if count < 2:
    raise SystemExit("HATA: Sekme boş veya eksik.")

wb.save(target)
PY
    then
        if uvx --from 'markitdown[xlsx]' \
            markitdown "$tmpdir/selected.xlsx" \
            -o "$tmpdir/output.md"
        then
            if [[ -s "$tmpdir/output.md" ]]; then
                if mv -f -- "$tmpdir/output.md" "$target"; then
                    printf '\nBaşarılı: %s\n' "$target"
                    printf 'Markdown satır sayısı: '
                    wc -l < "$target"
                    printf '\nİlk 10 satır:\n'
                    head -n 10 "$target"
                else
                    status=1
                fi
            else
                printf 'HATA: Markdown çıktısı boş.\n'
                status=1
            fi
        else
            printf 'HATA: MarkItDown başarısız.\n'
            status=1
        fi
    else
        printf 'HATA: XLSX hazırlama başarısız.\n'
        status=1
    fi

    rm -rf -- "$tmpdir"
    return "$status"
}

main "$@"
