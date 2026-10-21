#let data = json(sys.inputs.at(
  "content",
  default: "/content/tier1.json",
))

// 1080 x 1920 px at 300 PPI
#let w = 259.2pt
#let h = 460.8pt

#let black = rgb("#080808")
#let white = rgb("#F5F5F3")
#let muted = rgb("#A0A0A0")

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

#block(
  width: w,
  height: h,
  inset: 24pt,
)[
  #text(
    size: 7pt,
    weight: "bold",
    tracking: 1pt,
  )[#data.eyebrow]

  #v(1fr)

  #rect(
    width: 27pt,
    height: 2pt,
    fill: white,
    stroke: none,
  )

  #v(18pt)

  #text(
    size: 30pt,
    weight: "bold",
    tracking: -1.2pt,
  )[#data.title]

  #v(14pt)

  #text(
    size: 11pt,
    weight: "medium",
  )[#data.subtitle]

  #v(17pt)

  #text(
    size: 9pt,
    fill: muted,
  )[#data.description]

  #v(1fr)

  #line(
    length: 100%,
    stroke: 0.5pt + muted,
  )

  #v(12pt)

  #grid(
    columns: (1fr, auto),
    text(
      size: 8pt,
      weight: "bold",
    )[#data.footer],
    text(
      size: 7pt,
      fill: muted,
    )[#data.website],
  )
]
