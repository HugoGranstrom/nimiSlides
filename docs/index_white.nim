import nimib
import nimibreveal

nbInit(theme = revealTheme)
initReveal() # init the slide and introduce templates and variables
setSlidesTheme(White)
nb.useLatex

# The first slide is created by default, no need to add it.
nbText: """
## Welcome to [nimib-reveal](https://github.com/HugoGranstrom/nimib-reveal)!
These slides will show you what this theme is capable of ⛄
"""

# The we can add a slide to the right
slideRight()
nbText: "## Hello World Example"
nbCode:
  echo "Hello World"

# And then we add one below the previous one, etc
slideDown()
nbText: "Hello Down here"

slideDown()
nbText: "## A classic"
nbText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

slideRight()
nbText: "# Code example"
nbCode:
  var this: int
  let is_a = 1
  proc code(b: int) =
    echo "block"
  
  code(this)

slideRight()
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

slideDown()
nbCode:
  ggplot(df, aes("Energy", "Counts")) +
    geom_histogram() +
    theme_opaque() +
    ggsave("images/multi_layer_histogram_0.png")
removeCodeOutput # this hides the usual ggplotnim hint that is printed normally

nbImage("images/multi_layer_histogram_0.png")                                      

slideRight:
  nbText: """
## Math
You can typeset math as well (using `nb.useLatex`):

$$ e^{\pi i} = -1 $$
  """

slideRight:
  nbText: """
And a final **reveal**: These slides were created just using Nim!
  """

nbSave()