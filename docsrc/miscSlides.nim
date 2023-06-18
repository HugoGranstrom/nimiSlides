import nimib, nimiSlides

nbInit(theme = revealTheme)

useScrollWheel()
showSlideNumber()

slide:
  slide:
    nbText: """
## Typewriter
(typeSpeed=50, alignment=center)
"""
    typewriter("Hello there! This text is typed one character at a time.", alignment="center", typeSpeed=50)

  slide:
    nbText: """
## Typewriter
(typeSpeed=25, alignment=left)
"""
    typewriter("Hello there! This text is typed one character at a time.", alignment="left", typeSpeed=25)


slide:
  nbText: "## Footer"
  nimibCode:
    footer("This is a *markdown*-**formatted** ***footer***")

slide:
  slide:
    nbText: "## Corner Image"
    nimibCode:
      cornerImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png", UpperRight)
  slide:
    nbText: "## Corner Image"
    nimibCode:
      cornerImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png", LowerRight)
  slide:
    nbText: "## Corner Image"
    nimibCode:
      cornerImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png", LowerLeft)
  slide:
    nbText: "## Corner Image"
    nimibCode:
      cornerImage("https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png", UpperLeft)


nbSave()