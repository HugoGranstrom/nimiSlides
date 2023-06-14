import nimib, nimibook, nimiSlides
import ../utils/embeddedReveal

nbInit(theme = useNimibook)
initEmbeddedSlides()

nbText: hlMd"""
# Slide Options
The `slide` template can accept a `SlideOptions` object with some options.
The options are related to [auto-animation](./auto_animate.html) and [backgrounds](./backgrounds.html),
see their respective tutorials for more details.

A `SlideOptions` is created using the proc `slideOptions`:
"""

codeAndSlides:
  slide(slideOptions(colorBackground="#F1B434")):
    nbText: "Yellow background!"



nbSave
