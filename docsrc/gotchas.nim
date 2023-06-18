import nimib, nimibook

nbInit(theme = useNimibook)

nbText: hlMd"""
# Gotchas
This is a list of a few rough corners that you might encounter when using nimiSlides.

- If you create a slideshow with too many slides, you will get a `[GC] cannot register global variable; too many global variables` error.
This is an unfortunate effects of the design of nimib where a couple of global variables are created for each block you create. The easiest solution if you run into this is to split your presentation into multiple separate slideshows.
- When [exporting to pdf](./tutorials/pdf_export.html), a Chromium browser has to be used. In addition, the way the pdf
is created a separate copy of each image will be stored. So corner-images and image-backgrounds that are used on multiple slides can cause the size of the resulting pdf to explode.
- `fitImage` only works directly inside a `slide` and there can only be one `fitImage` per slide.
"""

nbSave
