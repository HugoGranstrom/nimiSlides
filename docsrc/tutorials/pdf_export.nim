import nimib, nimibook

nbInit(theme = useNimibook)
nbText: hlMd"""
# Print / PDF Export
Reveal.js has support for exporting a slideshow to PDF using the print function in your browser.
See [their documentation](https://revealjs.com/pdf-export/) for instructions.
Here's a quick list of important notes:
- Change the url from, for example `http://localhost:8000/slides.html` to `http://localhost:8000/slides.html?view=print`. This will show a printer-friendly version of your slides.
- It only works reliably on Chromium based browsers.
"""

nbSave
