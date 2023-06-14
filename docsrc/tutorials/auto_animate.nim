import nimib, nimibook, nimiSlides
import ../utils/embeddedReveal

nbInit(theme = useNimibook)
initEmbeddedSlides()

nbText: hlMd"""
# Auto-Animate
Auto-animation is a feature of Reveal.js where two similar slides can be transitioned smoothly between each other.
For example when adding a new piece of text to a slide, step-by-step:
"""

codeAndSlides:
  slide(slideOptions(autoAnimate=true)):
    nbText: """
# Only title first    
"""

  slide(slideOptions(autoAnimate=true)):
    nbText: """
# Only title first
Then both title and text! 
"""

  slide(slideOptions(autoAnimate=true)):
    nbText: """
# Only title first
Then both title and text! 

And finally an image:
"""
    fitImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png")

nbText: hlMd"""
As you can see, first only the header is shown. But when the text comes in, the header **moves up** to make room for it.
And then both the text and header move upwards to make room for the new text and image.
It looks pretty cool, but it requires a fair bit of duplication.
Auto-animation is activated for a slide by passing in the slide option `slideOptions(autoAnimate=true)`.
This is a bit lengthy to write, so we have created a `slideAutoAnimate` template that is equivalent to this.
Here are the same slides **without auto-animation**:
"""

codeAndSlides:
  slide:
    nbText: """
# Only title first    
"""

  slide:
    nbText: """
# Only title first
Then both title and text! 
"""

  slide:
    nbText: """
# Only title first
Then both title and text! 

And finally an image:
"""
    fitImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png")


nbText: hlMd"""
You can also add new content inbetween two existing objects:
"""

codeAndSlides:
  slideAutoAnimate:
    nbText: "Text Above"
    nbText: "Text Below"
  slideAutoAnimate:
    nbText: "Text Above"
    fitImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png")
    nbText: "Text Below"


nbText: hlMd"""
## Tips from the coach
It can be tempting to use cool animations like this all over the place, but I would
advice you to sprinkle it sparingly. Because of the code duplication, if you have to change something,
you will have to change it in all the slides of the auto-animation.
So I try to use it at most once per slide. But if there is a specific slide that I think could really
shine by having more I'll sprinkle on some more.

Typically I first have a slide with only the header, and then I auto-animate in all the content at once.
And to get the gradual reveal of the content of the slide I use [fragments](./fragments/index.html).
This gives a good balance of movement and simplicity.
"""

codeAndSlides:
  slideAutoAnimate:
    nbText: "# Cool header"

  slideAutoAnimate:
    nbText: "# Cool header"
    fragment:
      nbText: "The header moved up and this faded in."
    fragment:
      nbText: "Some more text."


nbText: hlMd"""
## Caveats and Limitations
The largest caveat is that Reveal.js isn't able to always see that two elements are the same between two slides because of
how nimiSlides generates its HTML. The gist of it is that there must be two elements that are identical between two slides for it to work.
What typically works are:
- Text
  - Separate `nbText` blocks
  - Separate paragraphs delimited by newlines in single `nbText`
- Images

What typically doesn't work:
- Code blocks
- Columns
- Advanced blocks (e.g. `typewriter`)

See [Reveal.js docs on auto-animate](https://revealjs.com/auto-animate/#how-elements-are-matched) for detailed explanations.
"""

nbSave
