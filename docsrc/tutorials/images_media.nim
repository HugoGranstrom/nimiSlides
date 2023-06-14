import nimib, nimibook, nimiSlides
import ../utils/embeddedReveal

nbInit(theme = useNimibook)
initEmbeddedSlides()

nbText: hlMd"""
# Images & Media
Images are an important part of making a presentation more fun.
There are two ways of inserting an image into a slide: `nbImage` and `fitImage`.
`nbImage` will insert the image normally, while `fitImage` will fit an image to
take up the remaining space of a slide.
"""

codeAndSlides:
  slide:
    nbText: "nbImage"
    nbImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png")
  slide:
    nbText: "fitImage"
    fitImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png")

nbText: hlMd"""
As we can see, `nbImage` was too big and overflowed while `fitImage` resized the image to fit.
Then why not always use `fitImage`? It has two limitations:
- There can only be a single `fitImage` per slide.
- The `fitImage` must be a direct child to a `slide`. Thus this is **not allowed**:
"""

nbCodeSkip:
  slide:
    #<----- It must be at this indentation level!
    columns:
      column:
        fitImage("image.png") # not here!

nbText: hlMd"""
For columns specifically, `nbImage` will work well most of the time though,
as the column size limits the image size: 
"""

codeAndSlides:
  slide:
    columns:
      column:
        nbImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png")
      column:
        nbImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png")

nbText: hlMd"""
## Fullscreen images, videos and iframe
Fullscreen images, videos and iframes can be created by setting them as the background of a slide.
See [Backgrounds tutorial](./backgrounds.html).
"""

nbSave
