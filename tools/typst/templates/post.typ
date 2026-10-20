#let veri = json(sys.inputs.at("content", default: "../content/post.json"))
#set page(width: 259.2pt, height: 259.2pt, margin: 18pt, fill: rgb("#0d1117"))
#set text(fill: white, size: 12pt)

#v(1fr)
#text(size: 9pt, fill: rgb("#58a6ff"), weight: "bold")[#upper(veri.kategori)]
#v(10pt)
#text(size: 19pt, weight: "bold")[#veri.baslik]
#v(14pt)
#text(size: 11pt, fill: rgb("#c9d1d9"))[#veri.icerik]
#v(1fr)
#line(length: 100%, stroke: 0.5pt + rgb("#30363d"))
#v(6pt)
#text(size: 8pt, fill: rgb("#8b949e"))[Tarih: #veri.tarih]
