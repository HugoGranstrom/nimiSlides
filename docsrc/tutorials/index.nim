import nimib, nimibook
import std / strformat
nbInit(theme = useNimibook)

nbText: hlMd"""
# Tutorials
This section contains tutorials covering the features of nimiSlides. 
Below is a table with all the features that each of the tutorials cover.
"""

let tutorials = [
  (title: "Getting Started", link: "getting_started" , list: @["slide", "nbText", "nbImage"]),
  ("Code Blocks", "code_block", @["nbCode", "nbCodeInBlock", "nbClearOutput", "animateCode"]),
  ("Text Formatting", "text_formatting", @["nbText", "useLatex", "bigText", "align"]),
  ("Images & Media", "images_media", @["nbImage", "fitImage"]),
  ("Layout", "layout", @["columns", "adaptiveColumns", "column", "disableVerticalCentering"]),
  ("Basics of Fragments", "fragments/basics", @["fragment", "fragmentFadeIn"]),
  ("Animated Lists", "fragments/lists", @["orderedList", "unorderedList", "listItem"]),
  ("End-Fragments", "fragments/end_fragments", @["fragmentEnd"]),
  ("Advanced Fragments", "fragments/advanced_fragments", @["fragmentNext", "fragmentThen"]),
  ("Slide Options", "slide_options", @["slideOptions"]),
  ("Auto-Animate", "auto_animate", @["slideOptions", "autoAnimate", "slideAutoAnimate"]),
  ("Backgrounds", "backgrounds", @["slideOptions", "colorBackground", "gradientBackground", "imageBackground", "videoBackground", "iframeBackground"]),
  ("Themes & CSS", "themes", @["setSlidesTheme", "addStyle"]),
  ("Speaker View", "speaker", @["speakerNote"]),
  ("Local Reveal.js installation", "local_reveal", @["localReveal", "useLocalReveal"]),
  ("Inline HTML", "inline_html", @["nbRawHtml"]),
  ("Print / PDF Export", "pdf_export", @[""]),
  ("Misc", "misc", @["typewriter", "cornerImage", "footer", "useScrollWheel", "showSlideNumber"])
]

var tableString = """
Tutorial | Keywords
---------|---------
"""
for (title, link, list) in tutorials:
  tableString.add &"[{title}]({link}.html) | "
  for word in list:
    if word.len > 0:
      tableString.add &" `{word}`,"
  tableString = tableString[0 .. ^2]
  tableString.add "\n"

echo tableString

nbText: tableString

nbSave
