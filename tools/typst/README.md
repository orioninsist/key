# Typst ile Görsel ve PDF Üretimi

Bu klasör, JSON içeriğini Typst şablonuyla birleştirerek PNG görsel veya PDF üretir. İşlem Docker içinde çalışır; bilgisayara ayrıca Typst kurmanız gerekmez.

## Gerekenler

Bilgisayarda **Docker** (çalışır durumda) ve **Python 3** olmalıdır.

## Hızlı başlangıç

Terminali projenin ana klasöründe açın ve sırayla çalıştırın:

```bash
cd tools/typst
python3 main.py
```

- `cd tools/typst`: Typst klasörüne geçer.
- `python3 main.py`: Örnek JSON içeriğinden PNG görsel üretir.

**Sonuç:** `output/post-post.png` (1080 × 1080 piksel).

## PDF üretmek

```bash
python3 main.py --format pdf
```

**Sonuç:** `output/post-post.pdf`.

## İçeriği değiştirmek

`content/post.json` dosyasını düzenleyin. Alanlar:

- `kategori`: Üst başlık
- `baslik`: Ana başlık
- `icerik`: Açıklama metni
- `tarih`: Görseldeki tarih

Ardından `python3 main.py` komutunu tekrar çalıştırın.

## Dosyalar ne işe yarar?

| Dosya / klasör | Görevi |
| --- | --- |
| `content/` | Yazıların bulunduğu JSON dosyaları |
| `templates/` | Görselin tasarımını belirleyen Typst şablonları |
| `main.py` | Üretimi başlatan Python programı |
| `Dockerfile` | Typst için Docker çalışma ortamı tanımı |
| `output/` | Üretilen PNG ve PDF dosyaları |

## Başka bir içerik kullanmak

Önce `content/announcement.json` dosyasını `post.json` ile aynı alanları kullanarak oluşturun. Ardından:

```bash
python3 main.py --content announcement
```

**Sonuç:** `output/announcement-post.png`.

**Not:** İlk çalıştırmada Docker, Typst imajını indirebilir. Üretim için Docker'ın açık olması gerekir. Çıktılar `output/` klasörüne kaydedilir.

[Typst belgeleri](https://typst.app/docs/) · [Typst kaynak kodu](https://github.com/typst/typst)
