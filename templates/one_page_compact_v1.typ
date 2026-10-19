#let doc = json(sys.inputs.content)
#let c = doc.content
#set page(paper: "a4", margin: (x: 25mm, y: 25mm), footer: context [#align(right)[#text(size: 8pt, fill: rgb("#64748b"))[#c.footer]]])
#let selected-font = sys.inputs.at("font", default: "Libertinus Serif")
#set text(font: selected-font, size: 10pt, fill: rgb("#172033"))
#set par(leading: 0.8em)
#text(size: 9pt, weight: "bold", fill: rgb("#475569"))[ORIONINSIST / BRIEF]
#v(8mm)
#text(size: 24pt, weight: "bold", fill: rgb("#172033"))[#c.title]
#v(3mm)
#text(size: 12pt, fill: rgb("#475569"))[#c.subtitle]
#v(8mm)
#line(length: 100%, stroke: 1pt + rgb("#94a3b8"))
#v(8mm)
#text(size: 12pt, weight: "semibold")[#c.lead]
#v(10mm)
#for section in c.sections {
  block(breakable: false)[
    #text(size: 11pt, weight: "bold")[#section.heading]
    #v(2mm)
    #section.body
    #v(6mm)
  ]
}
