import nimib, nimibook, nimiSlides
import ../utils/embeddedReveal

nbInit(theme = useNimibook)
initEmbeddedSlides()

nbText: hlMd"""
# Getting Started
## Installation
To get started with nimiSlides you have to install it. This is done the easiest using nimble:
```console
nimble install nimislides
```
Now that nimiSlides is installed we can create a Nim file, e.g., `slideshow.nim`, with the basic structure:
```nim
import nimib, nimiSlides

nbInit(theme = revealTheme)

# Your slides here

nbSave()
```
The comment `# Your slides here` shows where we will put the code that generates out slides. All examples in the following tutorials will only show the code that goes here and not the boilerplate around it.

## The slides API
The `slide` template is the core of nimiSlides. It delimits which content will be shown on each slide.
The basic syntax is that you put all the content you want in a slide inside a `slide:`:
"""

codeAndSlides:
  slide:
    nbText: "# 1"
  slide:
    nbText: "# 2"

nbText: hlMd"""
Above you can see a code snippet that generates two slides, one with the text "1" and a second one with the text "2". You can step forward in the slideshow if you focus on it using either `<Enter>`, the arrow keys or pressing the arrows in the slideshow (Using the arrow keys won't work here because that will step forward to the next chapter in the tutorial, but you can try it out in for example the [showcase slideshow](../showcase.html)). 

It doesn't stop here though, because you can create 2D-slideshows! Insane, right?! And it isn't hard to do either. All you have to do is to add another level of the `slide` template:
"""

codeAndSlides:
  slide:
    slide:
      nbText: "# 1.1"
    slide:
      nbText: "# 1.2"
  
  slide:
    slide:
      nbText: "# 2.1"
    slide:
      nbText: "# 2.2"

nbText: hlMd"""
If you are observant, you will see that the transitions are different between `1.1 -> 1.2` (downward motion) and `1.2 -> 2.1` (right motion). To get a better overview of this, focus on the slideshow and press `<ESC>`. This will zoom out to overview mode and allow you to view all the slides and their relative position to each other. We can see that there are two columns with two rows each. The outermost `slide` always creates a new column while the innermost `slide` creates a new row. 

If we compare this to the previous example, we only had a single `slide`. If we press `<ESC>` in that slideshow, we can see that the slides are aligned in columns with one row each in that case. These are the two main ways of creating slides, either you use only one level of `slide` and get a 1D-slideshow or you use two levels and get a 2D-slideshow. The advantage of a 2D-slideshow is that you can structure your slides easier. You can for example create one column for each topic of your presentation, that way you will be able to jump around much quicker when you are in overview mode.

## Adding text to you slides
Now you know how to create you slides, now you just have to fill them with content. The most basic thing to add to a slide is text. As you saw in the previous examples this can be accomplished using `nbText`. It accepts a string of markdown, so you can format you text using for example headers and *emphasis*:
"""

codeAndSlides:
  slide:
    nbText: """
# This is a header
## This is a smaller header
This is normal text!
"""

  slide:
    nbText: """
You can *emphasize* text in **different** ways.
- Lists works as well
- And links: [nimiSlides](https://github.com/HugoGranstrom/nimiSlides)
"""

nbText: hlMd"""
Tip: if you are using VSCodium/VSCode you can install my extension `NimiBoost` which allows you to get code highlighting of your markdown by adding `hlMd` in front of the string:
"""
nbCodeSkip:
  nbText: hlMd"""
Now *you* will be **able** to see the formatting!  

## Images
The second most common element of a presentation are images. They are added using `nbImage`:
"""

codeAndSlides:
  slide:
    nbImage("https://raw.githubusercontent.com/pietroppeter/nimib/main/assets/nimib-nimconf-thumbnail.png")

nbText: hlMd"""
Now you are ready to start creating your own slideshows in Nim! If you want to learn about more features look at the available tutorials in the sidebar to the left.
"""
nbSave
