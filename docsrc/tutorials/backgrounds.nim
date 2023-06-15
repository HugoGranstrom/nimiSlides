import nimib, nimibook, nimiSlides
import ../utils/embeddedReveal

nbInit(theme = useNimibook)
initEmbeddedSlides()

nbText: hlMd"""
# Backgrounds
The background of a slide can be set through [slide options](./slide_options.html).
The types of background are:
- Solid color
- Image
- Video
- Iframe
All of these become fullscreen, hence backgrounds are the way to show fullscreen content in nimiSlides.

## Solid Color Background
The solid color is specified by passing a valid CSS color (e.g. `red`, `#F1B434`, etc)
to the `colorBackground` parameter of `slideOptions`:
"""

codeAndSlides:
  slide(slideOptions(colorBackground="#F1B434")):
    nbText: "Yellow Background!"

nbText: hlMd"""
## Image Background
The image is specified by passing a link
to the `imageBackground` parameter of `slideOptions`:
"""

codeAndSlides:
  slide(slideOptions(imageBackground="https://github.com/nim-lang/assets/raw/master/Art/logo-crown.png")):
    discard

nbText: hlMd"""
As you can see, I didn't add any content to the slide and instead used a `discard`.
You can add content to the slide, but it can be hard to see against an image.

## Video Background
The video background can play a concrete video file (mp4 etc),
but if you want to show a Youtube video you should use the Iframe background instead.
The image is specified by passing a link
to the `videoBackground` parameter of `slideOptions`:
"""

codeAndSlides:
  slide(slideOptions(videoBackground="https://user-images.githubusercontent.com/5092565/178597724-16287a00-5c31-4500-83d8-e07160a36369.mp4")):
    discard

nbText: hlMd"""
## Iframe Background (Youtube videos as well)
If you want to show a website or youtube video in fullscreen,
you should use an Iframe background. The background will be interactible
unless `iframeInteractive=false` is passed to the slide option.
The website is specified by passing a link
to the `iframeBackground` parameter of `slideOptions`:
"""

codeAndSlides:
  slide(slideOptions(iframeBackground="https://www.youtube-nocookie.com/embed/Sf1TndCcIlU")):
    discard

nbSave
