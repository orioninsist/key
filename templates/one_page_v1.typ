#let doc = json(sys.inputs.content)
#let c = doc.content
#set page(paper: "a4", margin: (x: 22mm, y: 22mm), footer: context [#align(right)[#text(size: 8pt, fill: rgb("#64748b"))[#c.footer]]])
#let selected-font = sys.inputs.at("font", default: "Libertinus Serif")
#set text(font: selected-font, size: 10pt, fill: rgb("#172033"))
#set par(leading: 0.7em)
#rect(width: 100%, height: 4pt, fill: rgb("#1b4f91"))
#v(18mm)
#text(size: 28pt, weight: "bold", fill: rgb("#153e75"))[#c.title]
#v(3mm)
#text(size: 14pt, weight: "semibold")[#c.subtitle]
#v(12mm)
#text(size: 12pt)[#c.lead]
#v(13mm)
#for section in c.sections {
  block(breakable: false)[
    #text(size: 13pt, weight: "bold", fill: rgb("#153e75"))[#section.heading]
    #v(3mm)
    #section.body
    #v(8mm)
  ]
}
