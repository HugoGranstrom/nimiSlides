import nimib, nimibook, nimiSlides
import ../utils/embeddedReveal

nbInit(theme = useNimibook)

initEmbeddedSlides()

nbText: hlMd"""
# Code Blocks
The perhaps biggest reason why you are using nimiSlides is that you want to show off some Nim code.
Showing a code block and optionally its printed output is done using the `nbCode` or `nbCodeInBlock` templates.
The difference is that `nbCode` does not open a new scope, and as such variables defined in a `nbCode` block can be accessed in later blocks.
`nbCodeInBlock` on the other hand opens a new block and the variables defined there can't be accessed outside it.
This is important because `nbCodeInBlock` will allow us to reuse the same variable name multiple times.
Here's an example where both are used:
"""

codeAndSlides:
  slide:
    nbCode:
      let x = 1
      let y = 2
      echo x + y
  slide:
    nbCodeInBlock:
      let a = 10
      # note that x is from the previous nbCode block:
      echo a + x

nbText: hlMd"""
We can see that both the code and the echo'd `3` is shown on the first slide.
And on the second slide we can see that we access `x` because it was defined in a `nbCode` block.  

But what if we don't want to show the output? Either because it is too long or just irrelevant.
Then we can use `nbClearOutput()` directly after the call to `nbCode/nbCodeInBlock`:
"""

codeAndSlides:
  slide:
    nbCodeInBlock:
      let x = 1
      let y = 2
      echo x + y
    nbClearOutput()

nbText: hlMd"""
Poof! The output is gone! 

## Animated Code Blocks
One cool feature of Reveal.js is the animated code blocks.
It allows you to create a code block like the ones we have created above, but highlight specific lines.
This is done using the `animateCode` template by providing which lines to highlight and in which order.
The lines can be specified either as a slice `x..y`, a single line number `x`, or a set of lines `{x, y}`.
Note that the first line has line number 1 (and not 0).
"""


codeAndSlides:
  slide:
    animateCode(1, 2..3, 5, {2, 4}):
      let x1 = 1
      let x2 = 2
      let x3 = 3
      let x4 = 4
      let x5 = 5

nbText: hlMd"""
As you can see, first line 1 is highlighted, then lines 2 through 3, then line 5 and lastly line 2 through 4. Neat!
Note that there exists no `animateCodeInBlock` currently, but you can always wrap your `animateCode` inside a `block:` to get the same effect.
The animated code block is also useful if you have a very long code snippet that you want to show as it will auto-scroll for you:
"""

codeAndSlides:
  slide:
    animateCode(1, 16, 5, 13, 1):
      let y1 = 1
      let y2 = 2
      let y3 = 3
      let y4 = 4
      let y5 = 5
      let y6 = 6
      let y7 = 7
      let y8 = 8
      let y9 = 9
      let y10 = 10
      let y11 = 11
      let y12 = 12
      let y13 = 13
      let y14 = 14
      let y15 = 15
      let y16 = 16

nbSave
