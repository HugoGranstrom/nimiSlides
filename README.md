# nimiSlides 🛷 - Make beautiful presentations easily in Nim 👑

nimiSlides is Reveal.js theme for nimib which enables you to make beautiful slideshows just by writing Nim code.

https://user-images.githubusercontent.com/5092565/178597724-16287a00-5c31-4500-83d8-e07160a36369.mp4

An example can be found in `docs/` folder and the generated slides can be seen here: https://hugogranstrom.com/nimiSlides/

A showcase of all nimiSlides' features can be found here: https://hugogranstrom.com/nimiSlides/showcase.html

# NimConf 2022
At NimConf 2022, I did a presentation on nimiSlides which can be viewed [here](https://www.youtube.com/watch?v=Sf1TndCcIlU&list=PLxLdEZg8DRwSQQaK0UVRd1DaetVc3lIwr&index=7). The slides from the talk can be viewed at [https://hugogranstrom.com/nimiSlides/nimconf2022.html](https://hugogranstrom.com/nimiSlides/nimconf2022.html).

# Our goal 🥇

Our goal is to provide the easiest way to create a slideshow in Nim, about Nim. And this while also providing
lots of flexibility so you can tailor it to your liking.

# Table of contents
- [API](#api)
  - [Animate Code](#animate-code)
  - [Fragments (animations)](#fragments-animations)
    - [End animations](#end-animations)
    - [List of fragments](#list-of-fragment-animations)
    - [Fragment-animated lists](#fragment-animated-lists)
  - [Big Text](#big-text)
  - [Hiding code output](#hiding-code-output)
  - [Themes](#themes)
  - [Slide Options](#slide-options)
    - [Auto-animation](#automatic-animation)
    - [Backgrounds](#backgrounds)
  - [Typewriter](#typewriter)
  - [Speaker View](#speaker-view)
  - [Local Reveal.js installation](#use-local-revealjs-installation)
  - [Misc. Config](#misc-configuration)
- [Roadmap](#roadmap-🗺)

# API
These lines are needed at the top of your nim files:
```nim
import nimib
import nimiSlides

nbInit(theme = revealTheme)
```

Reveal.js has two directions which you can add slides in. To the right and down.
By nesting slides you can make use of both directions. Right is the primary direction and down the secondary.
Ex:
```nim
slide:
  nbText: "Start Page"

slide: # This creates a new slide to the right of the "Start Page" slide
  nbText: "To the right"

slide: # By nesting you can make verical slides as well
  slide: # This slide will be shown to the right of the "To the right" slide
    nbText: "This is at the top"
  slide: # This creates a new slide below the "This is at the top" slide
    nbText: "This is as the bottom"
```

Schematically this generates this slides structure:
```
Start page → To the right → This is at the top
                                     ↓
                            This is at the bottom          
```

## Animate Code
[Reveal.js supports highlighting lines of code](https://revealjs.com/code/#line-numbers-%26-highlights) and nimiSlides gives you convinient access to that feature using `animateCode`. It works like nimib's `nbCode` but accepts the lines and in which order they should be highlighted:
```nim
slide:
  animateCode(1..1, 2..3, 5..5, 4..4):
    echo "This is shown first"
    echo "Then..."
    echo "...these"
    echo "This is shown last"
    echo "This is shown before the line above it"
```
You pass in the lines as `HSlice`s in the order you want to highlight them and then the presentation will step through your code when you click forward. If you want to highlight lines that aren't beside each other at the same time (eg. line 4 and 6) you can't just create a range for that. Instead you can pass in `seq`s of ranges then:
```nim
slide:
  animateCode(@[1..1], @[4..4, 6..6]):
    echo "First this"
    echo "not this"
    echo "not this"
    echo "Then this ..."
    echo "not this"
    echo "... and this"
```
Here line 1 will be highlighted first and then line 4 and 6 will be highlighted at the same time.

## Fragments (animations)
By default, the entire slide's content will be shown at once. But what if you want the header to be shown first and then the first paragraph and finally an image, how would you do that? That's where *fragments* come in! They allow you to divide your slide into multiple parts which are shown and animated after each other when you click forward in the animation. The best way to explain is probably with an example:
```nim
slide:
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
  fragment(@[highlightRed]): # after that, highlightRed
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
That was the basics of using fragments, if you want to see this in action you can look at the [fragments example code](/docs/fragments.nim) and the final result is available [here](https://hugogranstrom.com/nimiSlides/fragments.html).

It is worth keeping in mind that not all animations are compatible with each other, for example mixing `fadeUp` and `fadeDown` won't play out well. Also worth noting is that `fadeIn` is the default and don't have its own class in Reveal.js so it's overriden if any other animation is provided. For example `@[fadeIn, highlightBlue]` is the same to Reveal as just `@[highlightBlue]` so to get the `fadeIn` effect as well you have to put it in its own seq `@[fadeIn], @[highlightBlue]`. There is a shorthand for this:
```nim
fragmentFadeIn(highlightBlue): # same as fragment(@[fadeIn], @[highlightBlue])
  nbText: "Hello"

fragmentFadeIn(@[highlightBlue], @[grow]): # same as fragment(@[fadeIn], @[highlightBlue], @[grows])
  nbText: "This will first fadeIn, then highlightBlue and lastly grows"
```

### End animations
You might also want to do an animation *after* a block has been shown. For example fading it out. This can be done similairly using the `fragmentEnd` template which accept inputs the same way as `fragment` does:
```nim
fragmentEnd(@[semiFadeOut, shrinks]): # when the animations inside have run, semiFadeOut and shrink all of it 
  fragment(highlightBlue):
    nbText: "This turns blue"
  fragment(shrinks):
    nbText: "This shrinks"
```
What will happen here is that the first text will turn blue, then the second text will shrink. And after that, *both* texts will semiFadeOut and shrink.

### List of fragment animations
- fadeIn (default)
- fadeOut
- fadeUp
- fadeDown
- fadeLeft
- fadeRight
- fadeInThenOut
- fadeInThenSemiOut
- grows
- semiFadeOut
- shrinks
- strike
- highlightRed
- highlightGreen
- highlightBlue
- highlightCurrentRed
- highlightCurrentGreen
- highlightCurrentBlue

### Fragment-animated lists
A common use-case for using animations is to reveal a list of list-items one at a time. This can be achieved using `fragmentList`:
```nim
slide:
  fragmentList(@[
    "First",
    "Second",
    "Third"
  ], fadeIn)
```
Here the three strings will be reveal one after another when a key is pressed.

If you want nested lists or more control over then list you can use `orderedList`, `unorderedList` and `listItem`:
```nim
orderedList:
  listItem:
    nbText: "First"
  listItem:
    nbText: "Second"
  unorderedList:
    listItem:
      nbText: "You can nest them as well"
    orderedList:
      listItem:
        nbText: "And mix ordered and unordered lists"
```
`listItem` accepts as argument `FragmentAnimation` or `seq[FragmentAnimation]`. By default it uses `fadeInThenSemiOut`.

## Big Text
If you have a short snippet of text you want to show as big as possible, use `bigText` instead of `nbText`:
```nim
bigText: "This is a big text!"
```

## Hiding code output
If you want to not show the output of a code block, you can call `nbClearOutput` right after your `nbCode` or `animateCode` call like this:
```nim
nbCode:
  echo "Hello world! Just kidding, you can't see this!"

nbClearOutput() # now the usual block showing "Hello world! Just kidding, you can't see this!" won't be visible and you save some space in your slide.
```

## Themes
There are some default themes for Reveal.js available using `setSlidesTheme`:
```nim
import nimib
import nimiSlides

nbInit(theme = revealTheme)
setSlidesTheme(White)
```
Available themes are: `Black`, `Beige`, `Blood`, `League`, `Moon`, `Night`, `Serif`, `Simple`, `Sky`, `Solarized`, `White`.
The same site as above can be view with `White` theme here: https://hugogranstrom.com/nimiSlides/index_white.html

## Slide options
There are some settings that has to be assigned to a slide to work, like a background image. Below are the available settings.

### Automatic animation
Reveal.js has support for [auto-animation](https://revealjs.com/auto-animate/) which when possible, smoothly animates the transition between slides. Here is an example where the second list element will be smoothly added after the first one:
```nim
slide:
  slide(slideOptions(autoAnimate=true)):
    nbText: """
- One element
"""
  slide(slideOptions(autoAnimate=true)):
    nbText: """
- One element
- Two elements
"""
```

### Backgrounds
There are multiple [background types](https://revealjs.com/backgrounds/) available:
- A single color:
```nim
slide:
  slide(slideOptions(colorBackground="#f1b434")):
    nbText: "Yellow background"
```
- Image background:
```nim
slide:
  slide(slideOptions(imageBackground="path/to/image/or/url")):
    discard
```
- Video background:
```nim
slide:
  slide(slideOptions(videoBackground="path/to/video/or/url")):
    discard
```
- Iframe background:
```nim
slide:
  slide(slideOptions(iframeBackground="url/to/website", iframeInteractive=true)):
    discard
```

## Typewriter
Do you want the effect of someone writing your text letter by letter? Then `typewriter` is what you are looking for!
```nim
slide:
  typewriter("This text will be typed one letter at a time with the speed and alignement specified.",
    typeSpeed=50, alignment="center")
```
`typeSpeed` is the number of milliseconds between each character. 

## Speaker view
Reveal.js's [speaker mode](https://revealjs.com/speaker-view/) is enabled by default and can be accessed by pressing "S". To add speaker notes use `speakerNote`:
```nim
slide:
  speakerNote: "This note will be visible on the speaker view"
```

## Use local Reveal.js installation
By default nimiSlide will use a CDN version of Reveal.js so it will only work if you are connected to the internet. If you want to use it offline you have to download a release from their [Github](https://github.com/hakimel/reveal.js). There are two ways to specify this:

### Add path in nimib.toml
Add a `[nimislides]` section to your `nimib.toml` file and add a field `localReveal = "path-to-reveal-folder"` where the path is relative to the `homeDir` (which hopefully is specified in the `nimib.toml` file).

### Call useLocalReveal in your presentation file
Call `useLocalReveal` with the path of the RevealJs folder relative to your nimib `homeDir`, which you specify in `nimib.toml` or else is the same folder as the `.nim` file is in. For example if your nimib `homeDir` is in `docs`, you unzip the Reveal.js file there such that the folder structure is as follows:
```
docs/
  revealjsfolder/
    css/
    dist/
    js/
    plugin/
    etc...
  *here your .nim and .html files would be*
```

Then in your presentation `.nim` file add this line:
```nim
nb.useLocalReveal("revealjsfolder")
```

## Misc. Configuration
- `useScrollWheel()`, this enables stepping forward in the presentation using the scroll-wheel.
- `showSlideNumber()`, this enables the current slide number being shown in the corner.
- `footer(text: string, fontSize=16, opacity=0.6, rawHtml=false)`, this will create a footer at the bottom of every slide. By default the text is treated as markdown, but if `rawHtml=true` it will inline the text as raw HTML.
- `cornerImage(image: string, corner: Corner, size: int = 100)` allows you to place an image in the corners: `UpperLeft, UpperRight, LowerLeft, LowerRight`.

# Roadmap 🗺
- [X] Make available `fragments` (https://revealjs.com/fragments/)
  - [x] Make it work with default options
  - [x] Support fragment animations
  - [x] Make fragments nestable
  - [x] Use `data-fragment-index` to allow ending blocks with an animation. Eg. fadeOut an entire block once it's finished.
  - [X] Make it work with lists
- [X] Make available code animations (https://revealjs.com/code/)
  - [X] Line numbers
  - [x] Highlight lines
  - [x] Make overload for showing lines of code that aren't beside each other. (api: `animateCode(seq[HSlice[int, int]])`)
- [X] Presenter mode note (https://revealjs.com/speaker-view/)
- [ ] Auto-slide (https://revealjs.com/auto-slide/)
- [x] Fit text (https://revealjs.com/layout/#fit-text)
- [x] Backgrounds
- [ ] Transitions (https://revealjs.com/transitions/)
- [X] Automatic animations
- [X] Typewriter effect
