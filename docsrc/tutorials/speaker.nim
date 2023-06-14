import nimib, nimibook, nimiSlides
import ../utils/embeddedReveal

nbInit(theme = useNimibook)

initEmbeddedSlides()

nbText: hlMd"""
# Speaker View
Reveal.js has support for Speaker View, where you can see the current slide, the next slide and speaker notes.
It can be accessed by pressing `<S>` when focusing on a slide. Doing so will open up a new window.
The notes can be created using `speakerNote` which accepts a markdown-formatted string.
"""

codeAndSlides:
  slide:
    nbText: "Slide 1"
    speakerNote("Note 1")
  slide:
    nbText: "Slide 2"
    speakerNote("Note 2")

nbText: hlMd"""
You will see that the speaker note changes when you change slide in the speaker view.

> Note: 
> Because this slideshow is embedded the inside a bigger page,
> the view will look a big odd here. But you can go to for example
> the [showcase](../showcase.html) and look at the speaker view there instead.
"""

nbSave
