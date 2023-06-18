import nimib, nimibook, nimiSlides
import ../../utils/embeddedReveal

nbInit(theme = useNimibook)
initEmbeddedSlides()

nbText: hlMd"""
# Basics of Fragments
The foundation of using fragments in nimiSlides is the `fragment` template.
You can input which fragments (animations) you want to use, and then the content
of the template will get these fragments. If you don't specify any fragment at all,
the default is a fade-in animation:
"""

codeAndSlides:
  slide:
    fragment:
      nbText: "This text faded in!"

# one fragment
nbText: hlMd"""
If you specify any of the supported fragments (see [list of fragments](./list_fragments.html))
it will use it instead of the default fade-in:
"""

codeAndSlides:
  slide:
    fragment(grows):
      nbText: "This text will grow!"

# multiple fragments at same time

nbText: hlMd"""
## Multiple fragments at once
Let's say you want to do two animations at the same time,
like grow the text at the same time as it turns green.
Then you can provide `fragment` with a `seq` of fragments instead: 
"""

codeAndSlides:
  slide:
    fragment(@[grows, highlightBlue]):
      nbText: "Blue and grow!"

# multiple fragments after each other

nbText: hlMd"""
## Multiple fragments after each other
Now let's say you have two animations that you want
to happen after each other. Like first fading in,
and then shrink. Then you have two options:
1. Nesting fragments have the effect of running them from the outside in:
"""

codeAndSlides:
  slide:
    fragment(fadeIn):           # will run first
      fragment(highlightGreen): # second
        fragment(grows):         # third
          nbText: "Fade in, then green, then grow."

nbText: hlMd"""
2. If you pass multiple `seq`s to `fragment`, it will run the `seq`s of fragments in order. This is equivalent to the nested example:
"""

codeAndSlides:
  slide:
    fragment(@[fadeIn], @[highlightGreen], @[grows]):
      nbText: "Fade in, then green, then grow."

nbText: hlMd"""
Because `fadeIn` is such a common fragment, we have made a template `fragmentFadeIn(seq)` which is equivalent to
`fragment(@[fadeIn], seq)`:
"""

codeAndSlides:
  slide:
    fragmentFadeIn(highlightGreen):
      nbText: "Fade in, then green."
    
    fragmentFadeIn(@[highlightBlue, grows], @[shrinks]):
      nbText: "Fade in, then blue & grow, lastly shrink."

nbSave
