import nimib, nimibook, nimiSlides
import ../utils/embeddedReveal

nbInit(theme = useNimibook)
initEmbeddedSlides()

nbText: hlMd"""
# Inline HTML
The beauty of nimib is that you can customize it a lot.
And one really handy feature is the ability to inline whatever HTML you want in your document using `nbRawHtml`.
This allows **you** to create your own custom blocks!
One area where this is useful is images. There are quite a lot of attributes you could change,
and covering all of them is quite a bit of work. So instead you can just inline your own `<img/>`
tag, exactly as you want it!

Here is an example where we create a template that inlines the HTML required to produce an image that is rotated by
a certain amount of degrees. By setting this angle as the input, we can reuse this template in multiple places! 
"""

codeAndSlides:
  import strutils
  template rotatedImage(src: string, degrees: float) =
    nbRawHtml: hlHtml"""
      <img src="$1" style="rotate: $2deg; max-height: 200px;"/>
""" % [src, $degrees]

  let url = "https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png"

  slide:
    nbText: "0 degrees"
    rotatedImage(url, 0)

  slide:
    nbText: "45 degrees"
    rotatedImage(url, 45)
  
  slide:
    nbText: "90 degrees"
    rotatedImage(url, 90)

nbText: hlMd"""
There are two things to note here. Firstly, we use `"$1 $2" % [s1, s2]` (and not `strformat`'s `&"{x}"`) for string interpolation because
it works better in templates. Secondly you can see that I put a `hlHtml` before the string, this allows me to get code highlighting of the
HTML code in the string if I have [nimiBoost](https://github.com/HugoGranstrom/nimiBoost) installed in VSCodium/VSCode.
This is sooo useful to make sure you have matching tags and strings. 
"""

nbSave
