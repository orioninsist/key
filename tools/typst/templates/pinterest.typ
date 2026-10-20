#let veri = json(sys.inputs.at(
  "content",
  default: "/content/pinterest.json",
))

// Pinterest 2:3 — 1000 x 1500 px @ 300 PPI
#let w = 240pt
#let h = 360pt

#let black = rgb("#000000")
#let white = rgb("#FFFFFF")

#set page(
  width: w,
  height: h,
  margin: 0pt,
  fill: black,
)


#set text(
  font: "DejaVu Sans Mono",
  fill: white,
)
#let brand = "ORIONINSIST"
#let website = "orioninsist.com"

#block(
  width: w,
  height: h,
  inset: 20pt,
)[
  #grid(
    columns: (1fr, auto),
    align: (left, right),
    text(size: 9pt, weight: "bold")[#brand],
    text(size: 5.5pt)[DIGITAL PRODUCTION],
  )

  #v(1fr)

  #align(center)[
    #rect(
      width: 30pt,
      height: 2pt,
      fill: white,
      stroke: none,
    )

    #v(18pt)

    #text(
      size: 24pt,
      weight: "bold",
      tracking: -0.7pt,
    )[
      #veri.baslik
    ]

    #v(13pt)

    #text(
      size: 10pt,
    )[
      #veri.alt_baslik
    ]

    #v(22pt)

    #block(
      width: 100%,
      inset: 12pt,
      stroke: 0.7pt + white,
    )[
      #align(center)[
        #text(size: 9pt)[#veri.aciklama]
      ]
    ]
  ]

  #v(1fr)

  #line(
    length: 100%,
    stroke: 0.6pt + white,
  )

  #v(10pt)

  #align(center)[
    #text(
      size: 9pt,
      weight: "bold",
    )[
      #website
    ]
  ]
]
