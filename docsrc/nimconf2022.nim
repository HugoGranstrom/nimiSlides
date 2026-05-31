import std / [strutils, random, sequtils, math, strformat]
import ggplotnim
import nimib
import nimiSlides

nbInit(theme = revealTheme)
nb.useLatex

template nimConfSlide(body: untyped) =
  slide:
    cornerImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png", UpperRight, size=100, animate=false)
    body

template nimConfSlide(options: SlideOptions, body: untyped) =
  slide(options):
    cornerImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png", UpperRight, size=100, animate=false)
    body

template nimConfAutoSlide(body: untyped) =
  nimConfSlide(slideOptions(autoAnimate = true)):
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

template listText(text: string) =
  listItem: nbText: text

template stackElements*(body: untyped) =
  nbRawHtml: """<div class="r-stack">"""
  body
  nbRawHtml: "</div>"

# The general theme:
# Each vertical stack is about one topic
# The first slide in each stack is a code-less showcase of it
# The other slides shows how to use it

slide:
  nimConfSlide:
    nbText: hlMd"""
  ## Make beautiful presentations in Nim 👑
  ## using nimiSlides 🛷

  Hugo Granström

  NimConf 2022
  """

  nimConfAutoSlide:
    nbText: hlMd"""
## What is nimiSlides?
"""

  nimConfAutoSlide:
    nbText: hlMd"""
## What is nimiSlides?
"""
    unorderedList:
      listText: "[Nimib](https://github.com/pietroppeter/nimib) 🐳 theme based on [Reveal.js](https://revealjs.com/)"
      listText: "Powered by [Nim](https://nim-lang.org/) 👑"
      listText: "Elegant DSL-based API"
      unorderedList:
        listText: "Easy to use"
        listText: "Leverages Nim's flexible syntax"

  nimConfAutoSlide:
    nbText: "## Our Goal"

  nimConfAutoSlide:
    nbText: "## Our Goal"
    nbText: "The easiest way to create a slideshow in Nim, about Nim"

  nimConfAutoSlide:
    nbText: hlMd"""
## Why nimib?
"""

  nimConfAutoSlide:
    nbText: hlMd"""
## Why nimib?
"""
    unorderedList:
      listText: "Customizable"
      unorderedList:
        listText: "Easy to extend"
        unorderedList:
          listText: "Custom blocks"
        listText: "Outputs HTML"

  nimConfAutoSlide:
    nbText: hlMd"""
## Why nimib?
"""
    unorderedList:
      listText: "Powerful"
      unorderedList:
        listText: "Nim's meta programming"
        unorderedList:
          listText: "Templates"
          unorderedList:
            listText: "Simplify repetitive patterns"
          listText: "Macros"
        listText: "Code blocks are compiled and run"
        listText: "Captures code output"

  nimConfAutoSlide:
    nbText: hlMd"""
## Why nimib?
"""
    unorderedList:
      listText: "Automation"
      unorderedList:
        listText: "Generate plots - always up to date"
        listText: "for-loops"

  nimConfSlide:
    nbText: "## What we will cover"
    unorderedList:
      listText: "The basics of nimiSlides"
      listText: "Feature exploration"
      listText: "Practical examples"

slide:
  nimConfSlide:
    nbText: hlMd"""
## The basics
"""

  nimConfSlide:
    nbText: "## 2D slideshows"
    speakerNote: "Show the overview"

  nimConfAutoSlide:
    nbText: "## Markdown"

  nimConfAutoSlide:
    nbText: "## Markdown"
    nimibCode:
      nbText: """
### Header
Text can be *italic*, **bold** or ~~crossed over~~.
- List item 1
- List item 2

[A Link](https://github.com/HugoGranstrom/nimiSlides)
"""

  nimConfAutoSlide:
    nbText: """
## Markdown in Code
"""
 
  nimConfAutoSlide:
    nbText: """
## Markdown in Code
## vs
## Code in Markdown
"""

  nimConfSlide:
    nbText: """### Installation"""

    nbCodeSkip:
      nimble install nimiSlides
  
  nimConfSlide:
    nbText: "### Setting up"
    nbCodeSkip:
      import nimib, nimiSlides
      nbInit(theme = revealTheme)

  nimConfSlide:
    nbText: hlMd"""
### The slide API
""" 
    fragmentFadeIn:
      nbText: hlMd"""
- 1 level → horizontal slide (↔️)
- 2 levels → vertical slide (↕️)
""" 
    columns:
      column:
        fragmentFadeIn:
          animateCodeSkip(1..4, 1..2, 3..4, 6..12, 6, 7..8, 9..10, 11..12):
            slide:
              nbText: "1"
            slide:
              nbText: "2"

            slide:
              slide:
                nbText: "3"
              slide:
                nbText: "4"
              slide:
                nbText: "5"
      column:
        fragmentFadeIn:
          nbText: """
```
1 ➡️ 2 ➡️ 3
         ⬇️
         4
         ⬇️
         5
"""


slide:
  nimConfAutoSlide:
    nbText: "## Code Blocks"

  nimConfAutoSlide:
    nbText: "## Code Blocks"
    nbCodeInBlock:
      let a = 1
      let b = 2
      echo a + b

  nimConfAutoSlide:
    nbText: "## Code Blocks"
    nimibCode:
      nbCode:
        let a = 1
        let b = 2
        echo a + b

slide:
  nimConfAutoSlide:
    nbText: "## Animating code"

  nimConfAutoSlide:
    nbText: "## Animating code"
    animateCode(1, 3..4, 2, 3..5):
      echo 1
      echo 2
      echo 3
      echo 4
      echo 5

  nimConfAutoSlide:
    nbText: "## Animating code"
    nimibCode:
      animateCode(1, 3..4, 2, 3..5):
        echo 1
        echo 2
        echo 3
        echo 4
        echo 5

  nimConfAutoSlide:
    nbText: "## Animating code"
    nbText: "It works for long codes as well"
    animateCode(1, 10, 20, 3..5, 15..16):
      echo "1"
      echo 2
      echo 3
      echo 4
      echo 5
      echo "1"
      echo 2
      echo 3
      echo 4
      echo 5
      echo "1"
      echo 2
      echo 3
      echo 4
      echo 5
      echo "1"
      echo 2
      echo 3
      echo 4
      echo 5
      echo "1"
      echo 2
      echo 3
      echo 4
      echo 5
      echo "1"
      echo 2
      echo 3
      echo 4
      echo 5
    nbClearOutput()
  
slide:
  nimConfAutoSlide:
    nbText: "## Typewriter"

  nimConfAutoSlide:
    nbText: "## Typewriter"
    nimibCode:
      typewriter("This text will be typed, one char at a time")

    typewriter("It can go slower", 200)
    typewriter("Or it can go faster", 10)

slide:
  nimConfAutoSlide:
    nbText: "## Fragments"

  nimConfAutoSlide:
    nbText: "## Fragments"
    nimibCode:
      fragmentFadeIn:
        nbText: "First"
      fragmentFadeIn:
        nbText: "Second"

  nimConfSlide:
    nbText: "## Nesting Fragments"
    nimibCode:
      fragment(grows):
        fragment(shrinks):
          nbText: "This will grow, then shrink"

  nimConfSlide:
    nbText: "## End Fragments"
    nimibCode:
      fragmentEnd(semiFadeOut):
        fragmentFadeIn:
          nbText: "First"
        fragmentFadeIn:
          nbText: "Second"

slide:
  nimConfAutoSlide:
    nbText: "## Incremental Lists"

  nimConfAutoSlide:
    nbText: "## Incremental Lists"
    unorderedList:
      listItem: nbText: "This appears first"
      listItem: nbText: "Then this"
      orderedList:
        listItem: nbText: "Then this (nested list)"
        listItem: nbText: "This is also nested"
      listItem: nbText: "Back again"
  
  nimConfSlide:
    animateCode(1, 2..3, 4, 5..6, 7, 9):
      unorderedList:
        listItem:
          nbText: "First item"
        unorderedList:
          listItem:
            nbText: "One level deeper"
          listItem(highlightCurrentGreen):
            nbText: "Still deep"
        listItem(@[highlightCurrentRed]):
          nbText: "Back again"
    
slide:
  nimConfAutoSlide:
    nbText: "## Columns"

  nimConfAutoSlide:
    speakerNote "Simple wrapper on top of CSS Grid with equally sized columns"
    nbText: "## Columns"
    columns:
      column:
        nbText: "Left"
      column:
        nbText: "Middle"
      column:
        nbText: "Right"
  
  nimConfAutoSlide:
    nbText: "## Columns"
    animateCode(1, 2..3, 4..5, 6..7):
      columns:
        column:
          nbText: "Left"
        column:
          nbText: "Middle"
        column:
          nbText: "Right"


slide:
  nimConfAutoSlide:
    nbText: "## Math Equations"
  nimConfAutoSlide:
    nbText: hlMd"""
## Math Equations

$e^{\pi i} = -1$
"""
    speakerNote: "A pain to do in PowerPoint"

  nimConfAutoSlide:
    nbText: "## Math Equations"
    nimibCode:
      nb.useLatex
      nbText: """
This is some inline math: $\alpha^2 + \beta^2 = \gamma^2$

Here we have a standalone equation:
$$e^{\pi i} = -1$$
"""


slide:
  nimConfAutoSlide:
    nbText: "## Speaker View & Notes"
  
  nimConfAutoSlide:
    nbText: "## Speaker View & Notes"
    nimibCode:
      speakerNote: "Show the **viewer** this note in the *speaker view*"

# Backgrounds
slide:
  nimConfSlide:
    nbText: "## Backgrounds"
  
  slide(slideOptions(colorBackground = "darkviolet")):
    nbText: "## Color Background"
    nbCodeSkip:
      slide(slideOptions(colorBackground = "darkviolet")):
        nbText: "## Color Background"
  
  slide(slideOptions(imageBackground = "https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png")):
    nbText: "## Image Background"

  nimConfSlide:
    nbText: "## Image Background"
    nbCodeSkip:
      slide(slideOptions(imageBackground = "https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png")):
        discard

  slide(slideOptions(iframeBackground = "https://nim-lang.org/")):
    discard

  nimConfSlide:
    nbText: "## Iframe Background"
    nbCodeSkip:
      slide(slideOptions(iframeBackground = "https://nim-lang.org/")):
        discard
    
  nimConfSlide:
    nbText: "## Video Background"
    nbCodeSkip:
      slide(slideOptions(videoBackground = "link/to/videofile.mp4")):
        discard
    fragmentFadeIn:
      nbText: "Youtube videos should use Iframes backgrounds "


slide:
  nimConfAutoSlide:
    nbText: "## Auto Animate"

  nimConfSlide(slideOptions(autoAnimate=true)):
    nbText: "## Auto Animate"
    nbText: """
- First
"""

  nimConfSlide(slideOptions(autoAnimate=true)):
    nbText: "## Auto Animate"
    nbText: """
- First
- Second
"""

  nimConfSlide(slideOptions(autoAnimate=true)):
    nbText: "## Auto Animate"
    nbText: """
- First
- Second
- Third
"""

  nimConfSlide(slideOptions(autoAnimate=true)):
    nbText: "## Auto Animate"
    nbText: """
- First
- Second
- Third
- What comes next?
"""

  nimConfSlide:
    animateCodeSkip(1..4, 6..10, 12..17):
      slide(slideOptions(autoAnimate=true)):
        nbText: """
- First
"""

      slide(slideOptions(autoAnimate=true)):
        nbText: """
- First
- Second
"""

      slide(slideOptions(autoAnimate=true)):
        nbText: """
- First
- Second
- Third
"""

nimConfAutoSlide:
  nbText: "## Footer"

nimConfAutoSlide:
  nbText: "## Footer"
  nimibCode:
    footer: "Hugo Granström *NimConf 2022* - [https://github.com/HugoGranstrom/nimiSlides](https://github.com/HugoGranstrom/nimiSlides)"

slide:
  nimConfSlide:
    nbText: "## Corner Images"
    speakerNote: "The Nim Logo is put there using this feature."
  
  slide:
    nimibCode:
      cornerImage(
        "https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png",
        corner=UpperRight)
  
  slide:
    nimibCode:
      cornerImage(
        "https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png",
        corner=LowerRight)

  slide:
    nimibCode:
      cornerImage(
        "https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png",
        corner=LowerLeft)

  slide:
    nimibCode:
      cornerImage(
        "https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png",
        corner=UpperLeft)

nimConfSlide:
  nbText: "## A few practical examples"

slide:
  nimConfAutoSlide:
    nbText: "## Using Templates"
  nimConfAutoSlide:
    nbText: "## Using Templates"
    animateCodeSkip({1, 3, 6}):
      slide(slideOptions(autoAnimate=true)):
        nbText: "## Animate header"
      slide(slideOptions(autoAnimate=true)):
        nbText: "## Animate header"
        nbText: "Animate this"
      slide(slideOptions(autoAnimate=true)):
        nbText: "## Animate header"
        nbText: "Animate this"
        nbText: "And this"
    fragmentFadeIn:
      nbText: "Let's make our lifes easier and define a template for this!"

  nimConfAutoSlide:
    nbText: "## Using Templates"
    animateCodeSkip(1, 2..3, 3, 5..6):
      template slideAutoAnimate(body: untyped) =
        slide(slideOptions(autoAnimate=true)):
          body
    
      slideAutoAnimate:
        nbText: "## Animate header"

  nimConfAutoSlide:
    nbText: "## Using Templates"
    stackElements:
      fragment(fadeInThenOut):
        nbText: "#### Without template"
        nbCodeSkip:
          slide(slideOptions(autoAnimate=true)):
            nbText: "## Animate header"
          slide(slideOptions(autoAnimate=true)):
            nbText: "## Animate header"
            nbText: "Animate this"
          slide(slideOptions(autoAnimate=true)):
            nbText: "## Animate header"
            nbText: "Animate this"
            nbText: "And this"
      fragmentFadeIn:
        nbText: "#### With template"
        nbCodeSkip:
          slideAutoAnimate:
            nbText: "## Animate header"
          slideAutoAnimate:
            nbText: "## Animate header"
            nbText: "Animate this"
          slideAutoAnimate:
            nbText: "## Animate header"
            nbText: "Animate this"
            nbText: "And this"
  
slide:
  nimConfAutoSlide:
    nbText: "## Loops ♻️ + Generate images 🖼️"
  nimConfAutoSlide:
    nbText: "## Loops ♻️ + Generate images 🖼️"
    nbText: "Example: Histogram of Gaussian for different N"
  nimConfAutoSlide:
    nbText: "## Loops ♻️ + Generate images 🖼️"
    animateCodeSkip(1, 2, 3, 4..7, 9, 10, 11):
      for n in [50, 100, 1000, 10000]:
        let filename = &"images/gauss-{n}.png"
        let samples = newSeqWith(n, gauss(0.0, 1.0))
        let df = toDf(samples)
        ggplot(df, aes("samples")) +
          geom_histogram(fillColor="green") +
          ggsave(filename)

        slide:
          nbText: &"## Gauss Samples (N = {n})"
          nbImage(filename)

slide:
  for n in [50, 100, 1000, 10000]:
    let filename = &"images/gauss-{n}.png"
    let samples = newSeqWith(n, gauss(0.0, 1.0))
    let df = toDf(samples)
    ggplot(df, aes("samples")) +
      geom_histogram(fillColor="green") +
      ggsave(filename)

    slide:
      nbText: &"## Gauss Samples (N = {n})"
      nbImage(filename)


slide:
  nimConfAutoSlide:
    nbText: "## The End"

  nimConfAutoSlide:
    nbText: "## The End"
    nbText: "Thanks for watching 😄"

  nimConfAutoSlide:
    nbText: "## The End"
    nbText: "Thanks for watching 😄"
    nbText: "Have a great day!"

nbSave()