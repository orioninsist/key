#let c = json(sys.inputs.content)
#let w = int(sys.inputs.width)
#let h = int(sys.inputs.height)

#set page(width: w * 1pt, height: h * 1pt, margin: 0pt)
#set text(fill: white)

#rect(width: 100%, height: 100%, fill: black, inset: 0pt)[
  #pad(left: 7%, right: 7%, top: 12%, bottom: 6%)[
    #text(size: 64pt, weight: "bold")[#c.title]
    #v(6%)
    #text(size: 27pt)[#c.subtitle]
    #v(5%)
    #text(size: 20pt)[#c.description]
    #v(1fr)
    #align(center)[
      #text(size: 17pt)[orioninsist.com]
    ]
  ]
]
