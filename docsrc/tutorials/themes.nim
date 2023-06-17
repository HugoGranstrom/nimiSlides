import nimib, nimibook, nimiSlides
import std / strformat

nbInit(theme = useNimibook)
nbText: hlMd"""
# Themes & CSS
Reveal.js comes bundled with quite a few [themes](https://revealjs.com/themes/) to choose from.
See the link for an idea of what they look like. The available themes are:
"""

nbText:
  var list: string
  for t in SlidesTheme:
    list.add &"- `{t}`\n"
  list

nbText: hlMd"""
To specify which theme to use, `setSlidesTheme` is used:
"""

nbCode:
  setSlidesTheme(Moon)

nbText: hlMd"""
## CSS Customization
You can create your own theme and styling using CSS.
CSS is added using `nb.addStyle(cssString)` and Reveal.js exposes a few variables
that allows you to easily write a new theme, see list [here](https://github.com/hakimel/reveal.js/blob/master/css/theme/template/exposer.scss).
You can choose one of the builtin themes as a starting point and only modify certain aspects of it.
Here is an example of a Nim-theme based on the `Black` theme, but headings and links are Nim-yellow and the
background is different shade of black:
"""

nbCode:
  import strutils

  setSlidesTheme(Black)

  let nimYellow = "#FFE953"
  nb.addStyle: """
:root {
  --r-background-color: #181922;
  --r-heading-color: $1;
  --r-link-color: $1;
  --r-link-color-dark: darken($1 , 15%)
}
""" % [nimYellow]

nbSave
