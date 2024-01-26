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
  autoAnimateSlides(5):
    showUntil(3):
      nbText: "Shows at slides 1, 2, 3"
    showAt(2):
      nbText "Shows only at slide 2"
    nbText: "Always shown"
    showFrom(3):
      nbText: "Shows at slides 3, 4, 5"

nbText: hlMd"""
Neat huh? `autoAnimateSlides(5)` will create the `slide:`s for us and it will create 5 slides. These 5 slides will be indexed
1-5 (i.e. 1-indexed). Inside you have three constructs to use:
- `showAt`: only shows its content on the specified slides. You can either give a list of indices or a set. e.g. `showAt(1, 3, 5)` or `showAt({1..3, 6..9})`.
- `showFrom(i)`: only shows its content starting from slide number `i`.
- `showUntil(i)`: only shows its content **up and until** slide number `i`.  
"""

nbText: hlMd"""
# Auto-animate paragraphs
The examples above work fine if you want to animate **separate paragraphs** but it doesn't work for animations within paragraphs.
For that use the experimental `showText` construct:
"""

codeAndSlides:
  autoAnimateSlides(3):
    showText(@[
      ({}, "Hello"),
      ({2, 3}, " world"),
      ({3}, "!")
    ])

nbText: """
The API is ugly but it is what it is currently. The paragraph is given as a list of tuples.
Each tuple has a string and at which indices that string should be shown. An empty set (`{}`)
means that the string is always visible. `showText` can be used alongside the other auto-animation constructs showcased above. 
"""

nbText: hlMd"""
## Tips from the coach
It can be tempting to use cool animations like this all over the place, but I would
advice you to sprinkle it sparingly. Because of the code duplication, the build times may increase if they are used too much.
So I try to use it at most once per slide. But if there is a specific slide that I think could really
shine by having more I'll sprinkle on some more.

Typically I first have a slide with only the header, and then I auto-animate in all the content at once.
And to get the gradual reveal of the content of the slide I use [fragments](./fragments/index.html).
This gives a good balance of movement and simplicity.
"""

codeAndSlides:
  autoAnimateSlides(2):
    nbText: "# Cool header"

    showFrom(2):
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
  - Separate paragraphs
- Images

What typically doesn't work:
- Code blocks
- Columns
- Advanced blocks (e.g. `typewriter`)

See [Reveal.js docs on auto-animate](https://revealjs.com/auto-animate/#how-elements-are-matched) for detailed explanations.
"""

nbText: hlMd"""
## Old API
This section is here for completeness and it is suggested that you don't use this unless you have to as it is very boilerplatey.
The example slides are pretty good, though so scroll through them. 
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

nbSave
