# Changelog

## v0.2
- Update to use nimib v0.3.1.
- `slide` now accepts a `SlideOptions` created through `slideOptions` proc instead of a bool. It has the following fields:
  - `autoAnimate` - same as previously, it tries to automatically animate the transition of slides.
  - `colorBackground` - set the background color of the slide.
  - `imageBackground` - set the background to an image.
  - `videoBackground` - set the background to a video file (not Youtube, use iframe for it)
  - `iframeBackground` - set the background to an iframe of a website (fullscreen).
  - `iframeInteractive` - make the iframe interactive.
- Add `showSlideNumber` template to enable showing the current slide number.
- Add `useScrollWheel` template to enable stepping through the slides with the scroll wheel.
- `columns` template to create equally wide columns:
```nim
slide:
  columns:
    column:
      nbText: "Left column"
    column:
      nbText: "Right column"
```
- `footer(text: string, fontSize=20, opacity=0.6, rawHtml=false)` template to a footer to every slide. The input is a string with markdown, unless the argument `rawHtml=true` in which case it is treated as raw HTML.
  - The footer will be shown on all slides except those with image-, video- or iframe-backgrounds.
- Support for making lists that incrementally reveal the list items are supported using the templates `orderedList`, `unorderedList` and `listItem`.
- `addStyle` allows you to add CSS to the document.
- Experimental features - the API for these are not yet stable and might change in the future:
  - `fragmentThen` - Allows the construction of fragments like `growThenShrink` by `fragmentThen(grows, shrinks)`. The second animations happens at the same time as the next animation, reducing the number of clicks needed.
  - `align` template to simply align its content like this: `align("left"):`
