import nimib, nimibook, nimiSlides
import ../utils/embeddedReveal

nbInit(theme = useNimibook)
initEmbeddedSlides()

nbText: hlMd"""
# Getting Started
## Installation
To get started with nimiSlides you have to install it. This is done the easiest using nimble:
```console
nimble install nimislides
```
Now that nimiSlides is installed we can create a Nim file, e.g., `slideshow.nim`, with the basic structure:
```nim
import nimib, nimiSlides

nbInit(theme = revealTheme)

# Your slides here

nbSave()
```
The comment `# Your slides here` shows where we will put the code that generates out slides. All examples in the following tutorials will only show the code that goes here and not the boilerplate around it.

## The slides API
This
"""

# Slides API (esc to zoom out and see whole structure)
codeAndSlides:
  slide:
    nbText: "1"
  slide:
    nbText: "2"



# Text

# Images
nbSave
