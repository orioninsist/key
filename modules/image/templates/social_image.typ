#let c = json(sys.inputs.content)
#let w = int(sys.inputs.width)
#let h = int(sys.inputs.height)

#set page(width: w * 1pt, height: h * 1pt, margin: 0pt)
#set text(fill: white)

#rect(width: 100%, height: 100%, fill: black, inset: 0pt)[
  #pad(left: 7%, right: 7%, top: 12%, bottom: 6%)[
    #if "category" in c and c.category != "" [
      #text(size: 17pt, weight: "bold")[#c.category]
      #v(3%)
    ]
    #text(size: 64pt, weight: "bold")[#c.title]
    #v(6%)
    #text(size: 27pt)[#c.subtitle]
    #v(5%)
    #text(size: 20pt)[#c.description]
    #if "image" in c and c.image != "" [
      #v(4%)
      #image(c.image, width: 75%)
    ]
    #v(1fr)
    #if "source" in c and c.source != "" [
      #text(size: 13pt)[Kaynak: #c.source]
      #v(2%)
    ]
    #align(center)[
      #text(size: 17pt)[orioninsist.com]
    ]
  ]
]
