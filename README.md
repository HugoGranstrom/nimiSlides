# nimib-reveal

A Reveal.js theme for nimib.

An example can be found in `docs/` folder and the generated slides can be seen here: https://hugogranstrom.com/nimib-reveal/

## API
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

### Hiding code output
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
import nimibreveal

nbInit(theme = revealTheme)
initReveal() # init the slide and introduce templates and variables
setSlidesTheme(White)
```
Available themes are: `Black`, `Beige`, `Blood`, `League`, `Moon`, `Night`, `Serif`, `Simple`, `Sky`, `Solarized`, `White`.
The same site as above can be view with `White` theme here: https://hugogranstrom.com/nimib-reveal/index_white.html

## Roadmap 🗺

