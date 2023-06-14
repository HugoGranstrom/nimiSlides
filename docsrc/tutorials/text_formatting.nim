import nimib, nimibook, nimiSlides
import ../utils/embeddedReveal

nbInit(theme = useNimibook)
initEmbeddedSlides()

nbText: hlMd"""
# Text Formatting
Text can be shown using the `nbText` template which accepts a string of markdown-formatted text.
This means that you can *emphasize* and **bold** text as well as make [links](#) easily.
"""

codeAndSlides:
  slide:
    nbText: """
# This is a header
## A smaller header
Here is some *text* formatted using **markdown**!    
"""

nbText: hlMd"""
## Latex Equations
You can also write equations in Latex if you enclose them in `$` or `$$`. For this to work, you must activate Latex support using `nb.useLatex()`
"""

codeAndSlides:
  nb.useLatex()
  slide:
    nbText: """
## Equation
Eulers identity:
$$ e ^ {\pi i} = -1 $$ 
"""

  slide:
    nbText: """
## Inline equation
Eulers identity: $e ^ {\pi i} = -1$    
"""

nbText: hlMd"""
## Big Text
Reveal.js has support for making a given text as big as it can fit on a slide.
This will make the text as big as possible while still fitting on a single line.
This way you don't have to worry about finding the right header size for the text to fit.
This can be accessed in nimiSlides using the `bigText` template:
"""

codeAndSlides:
  slide:
    nbText: "# Normal header that will overflow"
  slide:
    bigText: "Big text that will not overflow"

# Big text

nbText: hlMd"""
## Align Text
By default, everything is centered both horizontally and vertically.
But sometimes you might want align the text horizontally. For this you can use the `align` template.
It will align its content according to the inputted alignment.
"""

codeAndSlides:
  slide:
    align("left"):
      nbText: "Left"
    align("center"):
      nbText: "Center"
    align("right"):
      nbText: "Right"

# Align

nbSave
