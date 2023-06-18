import nimib, nimibook, nimiSlides
import ../../utils/embeddedReveal

nbInit(theme = useNimibook)
initEmbeddedSlides()

nbText: hlMd"""
# End-Fragments
As you might remember from the [fragments basics tutorial](./basics.html),
nesting multiple calls of `fragment` had the effect of running them one after another.
But what if we wanted to run some fragment after all of its nested fragments had finished?
That's what end fragments solves. It allows you to set a fragment that will run once all
the fragments inside of it has finished! The template is called `fragmentEnd` and has the same API
as the ordinary `fragment`. The following code will `semiFadeOut` all the text
 **after** all the other fragments has run:
"""

codeAndSlides:
  slide:
    fragmentEnd(semiFadeOut):
      fragment:
        nbText: "Fade in this"
      fragment(strike):
        nbText: "Strike this"

nbSave
