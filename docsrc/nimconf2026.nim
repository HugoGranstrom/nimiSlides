import std / [strutils, random, sequtils, math, strformat, json]
import nimib, nimib / [capture]
import nimiSlides

nbInit(theme = revealTheme)
nb.useLatex

template nimSlide(body: untyped) =
  slide:
    cornerImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png", UpperRight, size=100, animate=false)
    body

template nimSlide(options: SlideOptions, body: untyped) =
  slide(options):
    cornerImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png", UpperRight, size=100, animate=false)
    body

template nimConfTheme*() =
  setSlidesTheme(Black)
  let nimYellow = "#FFE953"
  nb.addStyle: """
:root {
  --r-background-color: #181922;
  --r-heading-color: $1;
  --r-link-color: $1;
  --r-selection-color: $1;
  --r-link-color-dark: darken($1 , 15%)
}

.reveal ul, .reveal ol {
  display: block;
  text-align: left;
}

li::marker {
  color: $1;
  content: "»";
}

li {
  padding-left: 12px;
}
""" % [nimYellow]

nimConfTheme()

proc liText(s: string) =
  listItem:
    nbText:
      s

newNbBlock(FieldSet of NbContainer):
  title: string
  toHtml:
    let renderedBlocks = nbContainerToHtml(blk, nb)
    hlHtmlF"""
    <fieldset style="border-radius: 12px;">
      <legend>{blk.title}</legend>
      {renderedBlocks}
    </fieldset>
    """

template fieldSet(ttitle: string, body: untyped) =
  let blk = newFieldSet(title=ttitle)
  nb.withContainer(blk):
    body
  nb.add blk

newNbBlock(JsonShow of NbContainer):
  toHtml:
    let blocksSerialized = blk.blocks.toJson().fromJson().pretty()
    preCodeTag("json", blocksSerialized)

template jsonShow(body: untyped) =
  let blk = newJsonShow()
  nb.withContainer(blk):
    body
  nb.add blk

template showJsonSerialized(body: untyped) =
  let code = getCode(body)
  autoAnimateSlidesCustom(nimSlide, 3):
    fieldSet("Nim"):
      nbRawHtml: preCodeTag("nim", code)
    showAt(2):
      fieldSet("Rendered"):
        body
    showAt(3):
      fieldSet("JSON"):
        jsonShow:
          body

template intro =
  slide:
    nimSlide:
      nbText: "## Nimib v0.4"
      nbText: "## internals ref-actoring"
      nbText: "Hugo Granström"
      nbText: "NimConf 2026"
    autoAnimateSlidesCustom(nimSlide, 3):
      nbText: "## Story time"
      showAt(1):
        unorderedList:
          liText: "Previously on Nimib"
          unorderedList:
            liText: "Rendering: Mustache templates"
            liText: "Single NbBlock type"
      showAt(2):
        unorderedList:
          liText: "In this episode of Nimib"
          unorderedList:
            liText: "Rendering: normal Nim functions"
            liText: "Different type for each block"
      showAt(3):
        unorderedList:
          liText: "Next time on Nimib"
          unorderedList:
            liText: "NimiSlides + NimiBook"
            liText: "Static site generator"
            liText: "Nimibex"


template defineBlockExamples =
  discard

template jsonShowcase =
  nimSlide:
    nbText: "## JSON serialization"
  nimSlide:
    showJsonSerialized:
      nbText: "*Hello* **there**"
  nimSlide:
    showJsonSerialized:
      nbCode:
        echo "General Kenobi"
  nimSlide:
    showJsonSerialized:
      nbDiv(classes="cool", styles="color: green"):
        nbText: "This is nested"

intro
defineBlockExamples
jsonShowcase

nbSave
