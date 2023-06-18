import nimib, nimibook, nimiSlides
import utils/embeddedReveal

nbInit(theme = useNimibook)
initEmbeddedSlides()

nbText: hlMd"""
# Automation
Nim is a very powerful and flexible programming language,
and all of it is available to us when using nimiSlides.
This means that language constructs like if-statements
and for-loops can, and should, be used when applicable. 

## Conditional Slides

Let's say that you are making a presentation that you will
be having for two different audiences. For example a Master's
thesis presentation that you had both at the company and at school.
These are two different audiences that might be interested in different
aspects of your work. The company is interested in how your work could
be used at the company and the school is interested in the general use-cases
of your work. This can easily be taken into account using a simple if-statement:
"""

codeAndSlides:
  let schoolPresentation = true
  if schoolPresentation:
    slide:
      nbText: "School presentation"
  else:
    slide:
      nbText: "Company presentation"

nbText: hlMd"""
In this example you can switch between the two presentations
simply by changing the value of `schoolPresentation`.

## Loops - Less repetition
For loops are really powerful when you want to create multiple
slides with the same structure. Let's say you want to create 3
slides with a title and an image each.
Then you would have to write 3 `slide:`, 3 `nbText`, and 3 `nbImage/fitImage`.
The same holds if you want to modify them, you would have to change the code in 3 places.
If you instead use a for-loop it would reduce the amount of code needed.
The only things that change between the slides is the text and image so let's
make a list with them and loop over it instead:
"""

codeAndSlides:
  let url1 = "https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png"
  let url2 = "https://raw.githubusercontent.com/pietroppeter/nimib/main/assets/nimib-nimconf-thumbnail.png"
  let url3 = url1
  let slidesContent = [
    (title: "Title 1", src: url1),
    (title: "Title 2", src: url2), 
    (title: "Title 3", src: url3)   
  ]
  for (title, src) in slidesContent:
    slide:
      nbText: title
      fitImage(src)

nbText: hlMd"""
There are even more language constructs that could be used, like case-statements, templates and macros.
Out of these the template is probably the one I use the most. It allows me to create my own re-usable blocks,
so that I don't have to repeat the same code over and over again with just small changes. 

It only your own imagination that puts a stop to what you can accomplish with the power of Nim.
"""

nbSave
