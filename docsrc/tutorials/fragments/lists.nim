import nimib, nimibook, nimiSlides
import ../../utils/embeddedReveal

nbInit(theme = useNimibook)
initEmbeddedSlides()

nbText: hlMd"""
# Animated Lists
Lists, the standard use-case for fragments. You want to reveal one list item at the time.
NimiSlides has a convinient API to create such lists with good defaults.

## Ordered & Unordered Lists
An animated ordered list is created using `orderedList` and an unordered list using `unorderedList`.
The list items are created using `listItem` and it's them that you can attach fragments to.
The default fragment for a list item is `fadeInThenSemiOut`. All list items has an implicit fade-in
animation so you do not have to add it yourself.
"""

codeAndSlides:
  slide:
    orderedList:
      listItem:
        nbText: "First"
      listItem(fadeInThenOut):
        nbText: "Second"
      listItem(@[fadeInThenSemiOut, highlightCurrentGreen]):
        nbText: "Third"

nbText: hlMd"""
The same can be done for an `unorderedList`.

## Nested Lists
Ordered/Unordered lists can be nested inside each other.
When doing so the list items will be revealed from top to bottom as expected: 
"""

codeAndSlides:
  slide:
    unorderedList:
      listItem:
        nbText: "Normal list item"
      orderedList:
        listItem:
          nbText: "Nested 1"
        listItem:
          nbText: "Nested 2"
      listItem:
        nbText: "Unordered again"

nbText: hlMd"""
## Aligning Lists
As you can see, the lists are centered because that's the default behavior of Reveal.js.
If you want to left-align your lists, wrap them in a `align("left")`:
"""

codeAndSlides:
  slide:
    align("left"):
      orderedList:
        listItem:
          nbText: "First"
        listItem:
          nbText: "Second"

nbSave
