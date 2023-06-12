import nimib
import nimiSlides

nbInit(theme = revealTheme)
nb.useLatex()

when defined(themeWhite):
  nb.filename = "./showcase_white.html"
  setSlidesTheme(White)
else:
  setSlidesTheme(Moon)

useScrollWheel()
showSlideNumber()
footer("You can have a footer. It's handy for [links](https://github.com/HugoGranstrom/nimiSlides)")

slide:
  bigText: "Welcome to [nimiSlides](https://github.com/HugoGranstrom/nimiSlides)! 🛷" 
  nbText: "These slides will show you what this [nimib](https://github.com/pietroppeter/nimib) theme is capable of."
  speakerNote "This is a note"

slide:
  slide:
    nbText: "You can have text, but also code:"
    nbCode:
      let a = 2
      let b = 3
      echo a * b
    nbText: "Look! 👆 It even runs the code and shows the output!"
    nbText: "Next slide this way ↓"
  slide:
    nbText: "You can animate the code as well! 🎞"
    animateCode(1, 3..4, 5):
      echo "First this!"
      echo "But not this!"
      echo "Then..."
      echo "...these"
      echo "And last this!"
    nbClearOutput()
    nbText: "Pretty cool if you ask me! 😎"

slide:
  speakerNote "This is another note"
  nbText: "## Typewriter Effect"
  typewriter("This text will be typed one letter at a time with the speed and alignement specified.",
    typeSpeed=30, alignment="left")

slide:
  slide:
    bigText: "Fragments (animations)"
    fragmentEnd(semiFadeOut):
      fragmentFadeIn:
        nbText: "### Who doesn't like animations? ▶"
      fragmentFadeIn(strike):
        nbText: "Strike!"
      fragmentFadeIn(highlightGreen):
        nbText: "Green!"
      fragmentFadeIn(@[grows], @[shrinks], @[fadeOut]):
        nbText: "fadeIn > grows > shrinks > fadeOut"
      fragmentFadeIn:
        nbText: "And now that all is finished, semiFadeOut everything!"
  
  slide:
    nbText: "### You can do pretty complex animations:"
    fragmentEnd(fadeOut):
      fragmentFadeIn:
        nbText: "First show something here"
      fragmentFadeIn:
        nbText: "And when we are done here, hide this and show the next part"
      fragmentFadeIn:
        nbText: "Abra kadabra! 🧙"
    fragmentFadeIn:
      nbText: "Where did it go?"

  slide:
    nbText: "### Using a for loop you can automate tedious repetition"
    let texts = ["First", "Second", "Third", "Fourth", "Fifth"]
    for text in texts:
      fragment(highlightCurrentBlue):
        nbText: text
  
  slide(slideOptions(autoAnimate=true)):
    nbText: "## Automatic animation"
    nbText: """
- One element
"""
  slide(slideOptions(autoAnimate=true)):
    nbText: "## Automatic animation"
    nbText: """
- One element
- Two elements    
"""
  slide(slideOptions(autoAnimate=true)):
    nbText: "## Automatic animation"
    nbText: """
- One element
- Two elements
- Three elements
"""
  slide:
    nbText: "## Fragment list"
    fragmentList(@[
    "First",
    "Second",
    "Third"
    ], fadeIn)


slide:
  nbText: md"""
# Math ➕
You can show off all your fancy equations ⚛
$$ e^{\pi i} = -1 $$
$$ \int_0^{\infty} \frac{1}{1 + e^x} dx$$
"""

slide:
  slide:
    nbText: md"""    
# Images 🖼️
You can have the code generating an image in the slides and then load the image. This way it's always up to date! 
"""
    animateCode(1, 2..5, 6..9, 10..11, 12):
      import numericalnim, ggplotnim, std/[sequtils, math]
      # Coarse grid sampled spline
      let xSample = linspace(0.0, 1.0, 20)
      let ySample = xSample.mapIt(sin(20*it))
      let spline = newHermiteSpline(xSample, ySample)
      # Dense grid
      let x = linspace(0.0, 1.0, 100)
      let y = x.mapIt(sin(20*it))
      let ySpline = spline.eval(x)
      # Build dataframe
      var df = toDf({"x": x, "exact": y, "spline": ySpline})
      df = df.gather(["exact", "spline"], value="y", key="type")

  slide:
    nbText: "### Now let's load the image we just created!"
    nbCode:
      ggplot(df, aes("x", "y", color="type")) +
        geom_line() +
        ggsave("images/splineComp.png")

    nbClearOutput() # this hides the usual ggplotnim hint that is printed normally
    fragment(fadeUp):
      nbImage("images/splineComp.png")      

slide:
  slide(slideOptions(colorBackground="#f1b434")):
    nbText: "You can have different backgrounds"

  slide(slideOptions(imageBackground="https://images.freeimages.com/images/large-previews/3d0/london-1452422.jpg")):
    nbText: "Image background"

  slide(slideOptions(videoBackground="https://user-images.githubusercontent.com/5092565/178597724-16287a00-5c31-4500-83d8-e07160a36369.mp4")):
    nbText: "Video background"

  slide(slideOptions(iframeBackground="https://pietroppeter.github.io/nimib/", iframeInteractive=true)):
    nbText: "Iframe background"

slide:
  slide:
    nbText: "## 2 Columns"
    columns:
      column:
        nbText: "Left"
      column:
        nbText: "Right"
  slide:
    nbText: "## 3 Columns"
    columns:
      column:
        nbText: "Left"
      column:
        nbText: "Middle"
      column:
        nbText: "Right"

  slide:
    nbText: "### columns vs adaptiveColumns"
    columns:
      column:
        nbText: "Using `columns`, all columns will have the same width..."
      column:
        nbText: "... regardless of their content."
    adaptiveColumns:
      column:
        nbText: "Using `adaptiveColumns`, a columns will only take the space it needs..."
      column:
        nbText: "... like this."

slide:
  nbText: "## Incremental lists"
  align("left"):
    orderedList:
      listItem(@[fadeInThenSemiOut, highlightCurrentGreen]):
        nbText: "First"
      listItem(@[fadeInThenSemiOut, highlightCurrentGreen]):
        nbText: "Second"
      unorderedList:
        listItem(@[fadeInThenSemiOut, highlightCurrentGreen]):
          nbText: "You can nest them as well"
        orderedList:
          listItem(@[fadeInThenSemiOut, highlightCurrentGreen]):
            nbText: "And mix ordered and unordered lists"

slide:
  nbText: "## Corner images"
  cornerImage("https://hugogranstrom.com/images/avatar.png", LowerLeft, 100)
  cornerImage("https://hugogranstrom.com/images/avatar.png", LowerRight, 100)
  cornerImage("https://hugogranstrom.com/images/avatar.png", UpperLeft, 100)
  cornerImage("https://hugogranstrom.com/images/avatar.png", UpperRight, 100)
  



nbSave()