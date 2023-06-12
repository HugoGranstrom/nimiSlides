import nimib, nimitheme, nimiSlides
import ./utils/embeddedReveal

nbInit()
initEmbeddedSlides()
nb.useGithubMarkdown()

nbText: hlMd"""
# Documentation - nimiSlides

## API Reference
All procs and templates are documented in the [API Reference](./docs/nimiSlides.html). For easier CTRL-F see [the index](./docs/theindex.html).

## Tutorials

"""

embeddedSlides:
  slide:
    nbText: "Hello"
    fragment:
      nbText: "Fade in"
  slide:
    fragment(highlightCurrentBlue):
      nbText: "blue"
    nbText: "Goodbye"

embeddedSlides:
  slide:
    nbText: "Hello2"
    fragment(highlightCurrentRed):
      nbText: "red"
  slide:
    nbText: "Goodbye2"
    fragment:
      nbText: "Fade in2"

# TODO:
# List tutorials
# Add links to existing slides
# Move content from README to here instead
# To show the 2D, we could use nbFile to read in the code that generates a slideshow and then link to it. Iframe peraps?
#   embedded slideshow block?

nbSave()