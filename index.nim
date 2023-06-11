import nimib
import nimiSlides

nbInit(theme = revealTheme)
when defined(themeWhite):
  nb.filename = "./index_white.html"
  setSlidesTheme(White)
else:
  setSlidesTheme(Black)

nb.useLatex

slide:
  nbText: """
  ## Welcome to [nimiSlides](https://github.com/HugoGranstrom/nimiSlides)!
  These slides will show you what this theme is capable of ⛄
  """

# Then we can add a slide to the right
slide:
  slide:
    nbText: "## Hello World Example"
    nbCode:
      echo "Hello World"

  slide:
    # And then we add one below the previous one, etc
    nbText: "Hello Down here"

  slide:
    nbText: "## A classic"
    nbText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

slide:
  nbText: "## Fragments (animations)"
  fragment:
    nbText: "fadeIn"
  fragment(fadeInThenOut):
    nbText: "fadeInTheOut"
  fragment(@[highlightGreen]):
    nbText: "highlightGreen"
  fragment(strike):
    nbText: "strike"
  fragment(@[fadeIn], @[grows], @[shrinks], @[semiFadeOut]):
    nbText: "fadeIn > grows > shrinks > semiFadeOut"
  fragment(fadeDown):
    nbCode: echo "Works on code as well!"

slide:
  nbText: "# Code example"
  nbCode:
    var this: int
    let is_a = 1
    proc code(b: int) =
      echo "block"
    
    code(this)

slide: 
  slide:
    nbText: "## Generating and showing images"
    nbCode:
      import ggplotnim, random, sequtils
      randomize(42)
      let df = seqsToDf({
        "Energy" : cycle(linspace(0.0, 10.0, 25).toRawSeq, 2),
        "Counts" : concat(toSeq(0 ..< 25).mapIt(rand(10.0)),
                          toSeq(0 ..< 25).mapIt(rand(10).float)),
        "Type" : concat(newSeqWith(25, "background"),
                        newSeqWith(25, "candidates")) })

  slide:
    nbCode:
      ggplot(df, aes("Energy", "Counts")) +
        geom_histogram() +
        theme_opaque() +
        ggsave("images/multi_layer_histogram_0.png")
    nbClearOutput() # this hides the usual ggplotnim hint that is printed normally

    nbImage("images/multi_layer_histogram_0.png")                                      

slide:
  nbText: """
## Math
You can typeset math as well (using `nb.useLatex`):

$$ e^{\pi i} = -1 $$
  """

slide:
  bigText: "This is big!"
  bigText: "This is also big!"
  nbText: "This is normal text!"

slide:
  nbText: """
And a final **reveal**: These slides were created just using Nim!
  """

nbSave()