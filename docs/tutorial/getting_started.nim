import nimib
import nimiSlides

nbInit(theme = revealTheme)
setSlidesTheme(Moon)

slide:
  slide:
    nbText: hlMd"""
## Getting started with nimiSlides    
"""

  slide:
    nbText: hlMd"""
## Create a slide
- A slide is created using the `slide` template
- The slide content is put inside it
```nim
slide:
  nbText: "This is a slide"
```
This will create the next slide (press `<Space>` to continue): 
"""

  slide:
    nbText: "This is a slide"

slide:
  slide:
    nbText: hlMd"""
## Show text
- `nbText` takes a **Markdown**-formatted string and outputs pretty text.
"""

  slide:
    nbText: "## Text example"
    nimibCode:
      nbText: """
### This is a header
You can have *italic* and **bold** text or why not ***both***?
- Lists work as well
- Banana
- Apple
"""

slide:
  slide:
    nbText: """
## Code blocks
- nimiSlides allows you to show the source code of a code block and its outputs.
- The template `nbCode` is used by:    
"""
    nimibCode:
      nbCode:
        let a = 1
        echo a + 2

slide:
  slide(slideOptions(autoAnimate=true)):
    nbText: """
## Images
- Images can be displayed using `nbImage`
- Works for both URL links and relative links.
"""
  slide(slideOptions(autoAnimate=true)):
    nbText: "## Images"
    nimibCode:
      nbImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png")

slide:
  slide:
    nbText: """
## Layout
- nimiSlides has two kinds of column containers built-in:
  - `columns`: Every column is the same size.
  - `adaptiveColumns`: each column only takes as much space as its content requries.
- A column is created by placing a `column` inside one of the containers mentioned above.
"""
  slide:
    nbText: "## Equal columns"
    nimibCode:
      columns:
        column:
          nbText: "Short"
        column:
          nbText: "Looooooooooooooooooong"
        column:
          nbText: "Mediuuuum"

  slide:
    nbText: "## Adaptive columns"
    nimibCode:
      adaptiveColumns:
        column:
          nbText: "Short"
        column:
          nbText: "Looooooooooooooooooong"
        column:
          nbText: "Mediuuuum"

nbSave()