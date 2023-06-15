import nimib, nimibook

nbInit(theme = useNimibook)
nbText: hlMd"""
## Misc
This tutorial goes over a few features which doesn't have their own tutorial.
They can be previewed in the [accompanying slides](../miscSlides.html).
"""

nbText: hlMd"""
## Typewriter
The typewriter effect takes a text and writes it one character at a time.
The `typeSpeed` (default: 50) specifies the number of milliseconds between typing each letter (i.e. a high number means slow typing).
The `alignment` (default: center) specifies how to align the text (left, center, right).
"""

nbCodeSkip:
  typewriter("Hello there! This text is typed one character at a time.",
             alignment="center", typeSpeed=50)


nbText: hlMd"""
## Corner Image
An image can be put in any of the four corners using `cornerImage`.
The corners are specified using either of `UpperLeft, UpperRight, LowerLeft, LowerRight`.
"""

nbCodeSkip:
  cornerImage("image.png", UpperRight)


nbText: hlMd"""
## Footer
A footer that will be displayed at the bottom of each slide can be created using `footer`,
which accepts a markdown-formatted string:
"""

nbCodeSkip:
  footer("This is a *markdown*-**formatted** ***footer***")

nbText: hlMd"""
## Use scroll wheel to change slides
By running `useScrollWheel()`, the ability to change slides using the scroll wheel will be activated.
Try this out in the [accompanying slides](../miscSlides.html).

## Slide Numbers
To activate slide numbers in the lower right of the screen, run `showSlideNumber()`.
"""

nbSave
