#let c = json(sys.inputs.content)
#let w = int(sys.inputs.width)
#let h = int(sys.inputs.height)
#set page(width: w * 1pt, height: h * 1pt, margin: 0pt)
#set text(font: "DejaVu Sans", fill: white)
#rect(width: 100%, height: 100%, fill: rgb("#12213a"), inset: 0pt)[
  #pad(left: 7%, right: 7%, top: 12%)[
    #text(size: 26pt, weight: "bold", fill: rgb("#9ac7ff"))[ORIONINSIST]
    #v(12%)
    #text(size: 64pt, weight: "bold")[#c.title]
    #v(6%)
    #text(size: 27pt)[#c.subtitle]
    #v(5%)
    #text(size: 20pt, fill: rgb("#c3d0e6"))[#c.description]
    #v(1fr)
    #text(size: 17pt, fill: rgb("#9ac7ff"))[#c.footer]
  ]
]
