import nimib
import nimiSlides

nbInit(theme = revealTheme)
initReveal() # init the slide and introduce templates and variables
setSlidesTheme(Moon)
nb.useLatex

nbText: md"""
# Fragments
This slideshow is a showcase of the fragments capabilities of nimib-reveal. For the source code, look [here](https://github.com/HugoGranstrom/nimib-reveal/blob/main/docs/fragments.nim).
"""

slideRight:
  nbText: "### The basic animation is `fadeIn`:"
  fragment:
    nbText: "Fade in!"
  fragment(fadeInThenOut):
    nbText: "Fade in, then out!"
  fragment(@[fadeIn], @[highlightBlue]):
    nbText: "Fade in, then highlight text in blue!"
  fragmentFadeIn(highlightBlue):
    nbText: "Fade in, then highligt text in blue! (again but this time using `fragmentFadeIn`)"
  fragment(@[fadeIn], @[highlightBlue, shrink]):
    nbText: "And now the same but a shrink at the same time as the highlighting!!"

slideDown:
  nbText: "### Nesting of fragments"
  fragment:
    nbText: "This is the first part"
    fragment(fadeUp):
      nbCode: echo "This code faded up"
  fragment:
    nbText: "Now the entire second part is shown"
    nbCode: echo "This code was shown without any animations :("

slideDown:
  nbText: "### Ending animations"
  fragmentEnd(semiFadeOut): # When all code of the block has been run, everything in it will semiFadeOut. 
    # fragment(semiFadeOut) would instead semiFadeOut everything before the code in the block has even been shown.
    fragment:
      nbText: "This is first part"
      fragment(fadeUp):
        nbCode: echo "This is faded up!"
    fragment:
      nbText: "This is second part!"
      nbCode: echo "When all this has been shown, semiFadeOut!"

slideRight:
  let codeAnimations = [@[fadeIn], @[grow], @[shrink, semiFadeOut]] # you can save animations for easy reuse
  nbText: "### Let's make some animations to showcase code blocks one after another:"
  fragment(codeAnimations):
    nbCode:
      let s = """This code block will fadeIn,
              grow and then shrink and semiFadeOut!"""
  fragment(codeAnimations):
    nbCode:
      let t = "This code block will behave the same!"
  fragment(codeAnimations):
    nbCode:
      proc hello(world: string) =
        echo world
      let r = "This too!"
      hello(r)

slideRight:
  nbText: "Let's pass the green down the line!"
  for i in 0 .. 5:
    fragment(highlightCurrentGreen):
      nbText: $i

nbSave
