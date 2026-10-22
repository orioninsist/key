# Key

Fedora Linux araçları, terminal uygulamaları, yapılandırmaları ve doğrulanmış çözümler için Markdown tabanlı teknik bilgi arşivi.

## Bağlantılar

- [Teknik belge dizini](docs/index.md)
- [Araçlar ve kaynaklar (Markdown)](tools-and-resources.md)
- [XLSX → Markdown dönüştürme scripti](xlsx-to-md.sh)
- [Google Sheets — Ana takip tablosu](https://docs.google.com/spreadsheets/d/1UvxeOACEU39FUg_yxQBjBMXOD9l3IN3RzekUlw3sjlk/edit)
- [GitHub deposu](https://github.com/orioninsist/key)

## Araç listesini güncelleme

Google Sheets, araç listesinin ana kaynağıdır. Güncel tabloyu **Microsoft Excel (.xlsx)** biçiminde indirip bu deponun kök dizinine `Key.xlsx` adıyla koyun.

Fedora Linux üzerinde Bash ve [uv](https://github.com/astral-sh/uv) gereklidir. Script Python bağımlılığı `openpyxl` ile **01 | Tools and Resources** sekmesini ayırır, [Microsoft MarkItDown](https://github.com/microsoft/markitdown) ile Markdown'a dönüştürür ve `tools-and-resources.md` dosyasını yeniler.

```bash
./xlsx-to-md.sh
```

Gerekirse çalıştırma izni bir defaya mahsus `chmod +x xlsx-to-md.sh` komutuyla verilebilir.

**Önemli:** Script mevcut `tools-and-resources.md` dosyasını başarılı dönüşümde üzerine yazar; Google Sheets'e veya GitHub'a kendiliğinden veri göndermez. Markdown sonucunu kontrol ettikten sonra ilgili dosyaları ayrıca commit ve push edin. `Key.xlsx` dosyasını GitHub'a eklemek gerekmez.
