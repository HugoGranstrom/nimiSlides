# nimiSlides 🛷

A Reveal.js theme for nimib.

An example can be found in `docs/` folder and the generated slides can be seen here: https://hugogranstrom.com/nimib-reveal/

# API
Reveal.js has two directions which you can add slides in. To the right and down.
With the commands `slideRight()` and `slideLeft()` you then create a new slide in that direction.
Ex:
```nim
# The first slide is automatically created, no need to create it.
nbText: "Start Page"

nbRight() # This creates a new slide to the right of the "Start Page" slide
nbText: "This is at the top"

nbDown() # This creates a new slide below the "This is at the top" slide
nbText: "This is as the bottom"
```

Schematically this generates this slides structure:
```
Start page → This is at the top
                     ↓
             This is at the bottom          
```

If you want more visual distinction between the slides in your code you can also use the block syntax:
```nim
# This generates the same code as the above example
nbText: "Start Page"

nbRight:
  nbText: "This is at the top"

nbDown:
  nbText: "This is as the bottom"
```

## Fragments (animations)
By default, the entire slide's content will be shown at once. But what if you want the header to be shown first and then the first paragraph and finally an image, how would you do that? That's where *fragments* come in! They allow you to divide your slide into multiple parts which are shown and animated after each other when you click forward in the animation. The best way to explain is probably with an example:
```nim
slideRight() # make a new slide

fragment(@[fadeIn]): # make a fragment with the fadeIn animation
  nbText: "Hello"
```
Here we see the `fragment` template in use. It accepts a seq of animations which are listed below. What it means is that the text "Hello" will be faded in when you press a button. If we add another animation like `highlightRed`:
```nim
fragment(@[fadeIn, highlightRed]):
  nbText: "Hello"
```
Now when we press the button the text will BOTH fadeIn and highlightRed at the same time. If we wanted to first make it fadeIn and then when we press the button once more make it highlightRed we could nest `fragment` calls:
```nim
fragment(@[fadeIn]): # first fadeIn
  fragment(@[highlightRed]): AFTERWARDS highlightRed
    nbText: "Hello"
```
This can be written in a more compact way:
```nim
fragment(@[fadeIn], @[highlightRed]):
  nbText: "Hello"
```
So if we pass *multiple seqs* to `fragment`, it will be as if we did multiple nested calls with each seq as the argument for each nested level. There are two more ways of writing fragments that could be convinient. First off, if you only want one animation you can skip the `@[]` and just write the single animation like this:
```nim
fragment(fadeIn): # same as fragment(@[fadeIn])
  nbText: "Hello"
```
The second way is if you don't give any animations at all, it will default to `fadeIn`:
```nim
fragment(): # same as fragment(fadeIn)
  nbText: "Hello"
```
That was the basics of using fragments, if you want to see this in action you can look at the [fragments example code](/docs/fragments.nim) and the final result is available [here](https://hugogranstrom.com/nimib-reveal/fragments.html).

It is worth keeping in mind that not all animations are compatible with each other, for example mixing `fadeUp` and `fadeDown` won't play out well. Also worth noting is that `fadeIn` is the default and don't have its own class in Reveal.js so it's overriden if any other animation is provided. For example `@[fadeIn, highlightBlue]` is the same to Reveal as just `@[highlightBlue]` so to get the `fadeIn` effect as well you have to put it in its own seq `@[fadeIn], @[highlightBlue]`. For single animations there is a shorthand for this but not for more advanced cases (varargs are messy basically):
```nim
fragmentFadeIn(highlightBlue): # same as fragment(@[fadeIn], @[highlightBlue])
  nbText: "Hello"
```
### List of fragment animations
- fadeIn (default)
- fadeOut
- fadeUp
- fadeDown
- fadeLeft
- fadeRight
- fadeInThenOut
- fadeInThenSemiOut
- grow
- semiFadeOut
- shrink
- strike
- highlightRed
- highlightGreen
- highlightBlue
- highlightCurrentRed
- highlightCurrentGreen
- highlightCurrentBlue

## Big Text
If you have a short snippet of text you want to show as big as possible, use `bigText` instead of `nbText`:
```nim
bigText: "This is a big text!"
```

## Hiding code output
If you want to not show the output of a code block, you can call `removeCodeOutput` right after your `nbCode` call like this:
```nim
nbCode:
  echo "Hello world! Just kidding, you can't see this!"

removeCodeOutput() # now the usual block showing "Hello world! Just kidding, you can't see this!" won't be visible and you save some space in your slide.
```

## Themes
There are some default themes for Reveal.js available using `setSlidesTheme`:
```nim
import nimib
import nimiSlides

nbInit(theme = revealTheme)
initReveal() # init the slide and introduce templates and variables
setSlidesTheme(White)
```
Available themes are: `Black`, `Beige`, `Blood`, `League`, `Moon`, `Night`, `Serif`, `Simple`, `Sky`, `Solarized`, `White`.
The same site as above can be view with `White` theme here: https://hugogranstrom.com/nimib-reveal/index_white.html

# Roadmap 🗺
- [x] Make available `fragments` (https://revealjs.com/fragments/)
  - [x] Make it work with default options
  - [x] Support fragment animations
  - [x] Make fragments nestable
  - [ ] Use `data-fragment-index` to allow ending blocks with an animation. Eg. fadeOut an entire block once it's finished. Right now it only can happen at the start of a block or must be done separatly for each sub-fragment. (Can we use a table/seq in ctx to store them and then populate it at render from the ctx? Eg. `"<div class=\"fragment end-animation\" data-fragment-index=\"{{frag-1}}\">"` where `ctx["frag-1"]` will be set to the next index after the block has finished.)
  - [ ] Make it work with lists
- [ ] Make available code animations (https://revealjs.com/code/)
  - [ ] Line numbers
  - [ ] Highlight lines
- [ ] Presenter mode note (https://revealjs.com/speaker-view/)
- [ ] Auto-slide (https://revealjs.com/auto-slide/)
- [x] Fit text (https://revealjs.com/layout/#fit-text)
- [ ] Backgrounds