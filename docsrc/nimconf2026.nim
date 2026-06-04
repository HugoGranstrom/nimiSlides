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
          liText: "Spirit of Nimib past"
          unorderedList:
            liText: "Rendering: Mustache templates"
            liText: "Single NbBlock type"
      showAt(2):
        unorderedList:
          liText: "Spirit of Nimib present"
          unorderedList:
            liText: "Rendering: normal Nim functions"
            liText: "Different type for each block"
            liText: "Sugar"
            liText: "JSON"
      showAt(3):
        unorderedList:
          liText: "Spirit of Nimib future"
          unorderedList:
            liText: "NimiSlides + NimiBook"
            liText: "Static site generator"
            liText: "Nimibex"


template defineBlockExamples =
  nimSlide:
    nbText: "## Defining a block"
    unorderedList:
      liText: "Simple example - usage bar"
      liText: "Container example - collapsible section"
  slide:
    nimSlide(slideOptions(autoAnimate = true)):
      nbText: "## Usage bar"
    nimSlide(slideOptions(autoAnimate = true)):
      nbText: "## Usage bar"
      for i in [20, 40, 60, 80]:
        nbDiv():
          nbRawHtml: hlHtml"""
          <label>
            $1%
            <meter value="$2" min="0" max="1">$1%</meter>
          </label>
          """ % [$i, $(i / 100)]
    nimSlide(slideOptions(autoAnimate = true)):   
      nbText: "## Usage bar"
      nbRawHtml: preCodeTag("html", hlHtml"""
<label>
  50%
  <meter value="0.5" min="0" max="1">50%</meter>
</label>""")
    nimSlide(slideOptions(autoAnimate = true)):
      nbText: "## Usage bar"
      animateCode(1, 2..6, 7..8, 9..19, 21..28, 29..33, 34):
        newNbBlock(UsageBar):
          label: string
          altText: string
          value: float
          minValue: float
          maxValue: float
          toHtml:
            # injects `blk: UsageBar`
            &"""
<label>
  {blk.label}
  <meter
    value="{blk.value}"
    min="{blk.minValue}"
    max="{blk.maxValue}">
      {blk.altText}
  </meter>
</label>
"""

        proc usageBar(
            nb: var Nb,
            label: string,
            value: float, 
            altText: string = $value,
            minValue: float = 0.0,
            maxValue: float = 1.0
            ) =
          let blk = newUsageBar(
            label=label, value=value,
            altText=altText, minValue=minValue,
            maxValue=maxValue
          )
          nb.add blk

    nimSlide(slideOptions(autoAnimate = true)):
      nbText: "## Usage bar"
      nbCode:
        nb.usageBar(
          label="Storage usage:",
          value=0.8,
          altText="80% of storage used"
        )
  let exampleCollapsible = hlHtml"""
<details>
  <summary>
    What is hidden inside?
  </summary>
  Super secret text!
</details>
"""
  slide:
    nimSlide(slideOptions(autoAnimate = true)):
      nbText: "## Collapsible section"
    nimSlide(slideOptions(autoAnimate = true)):
      nbText: "## Collapsible section"
      nbRawHtml: exampleCollapsible
    nimSlide(slideOptions(autoAnimate = true)):
      nbText: "## Collapsible section"
      nbRawHtml: preCodeTag("html", exampleCollapsible)
    nimSlide(slideOptions(autoAnimate = true)):
      nbText: "## Collapsible section"
      animateCode(1, 2, 3, 3..11, 13..16, 17, 18..19, 20):
        newNbBlock(CollapsibleSection of NbContainer):
          summary: string
          toHtml:
            let renderedBlocks = nbContainerToHtml(blk, nb)
            &"""
<details>
  <summary>
    {blk.summary}
  </summary>
  {renderedBlocks}
</details>"""
            
        template collapsibleSection(
          text: string,
          body: untyped
        ) =
          let blk = newCollapsibleSection(summary=text)
          nb.withContainer(blk):
            body
          nb.add blk
    nimSlide(slideOptions(autoAnimate = true)):
      nbText: "## Collapsible section"
      let secretMessage = "Never gonna give you up, never gonna let you down..."
      nbCode:
        collapsibleSection("Top secret"):
          nbText(secretMessage)


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

template outro =
  discard

#intro
defineBlockExamples
#jsonShowcase
#outro

nbSave
