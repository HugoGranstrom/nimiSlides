import nimib, nimibook, nimiSlides
import ../utils/embeddedReveal

nbInit(theme = useNimibook)
initEmbeddedSlides()

nbText: hlMd"""
# Layout
Controlling the layout of a slide can be done using a simple column-based system.
It works by creating a `columns` or `adaptiveColumns` environment and then all `column`
inside them will be in their own column.
"""

codeAndSlides:
  slide:
    nbText: "## 2 Columns"
    columns:
      column:
        nbText: "Left"
      column:
        nbText: "Right"
  slide:
    nbText: "## 3 Columns"
    adaptiveColumns:
      column:
        nbText: "Left"
      column:
        nbText: "Middle"
      column:
        nbText: "Right"
  
nbText: hlMd"""
The difference between the two environments is that
`columns` creates columns of equal size while `adaptiveColumns` only makes each column as big
as it needs. See the difference in this example:
"""

codeAndSlides:
  slide:
    nbText: "### columns vs adaptiveColumns"
    columns:
      column:
        nbText: "Short text"
      column:
        nbText: "Looooooooooooooooong text"
    adaptiveColumns:
      column:
        nbText: "Short text"
      column:
        nbText: "Looooooooooooooooong text"

nbText: hlMd"""
As we can see, the `adaptiveColumns` made the "Short text" column smaller because it didn't need more space.
This allowed the looong text to fit in one line.

## Text alignment
See `align` in [Text Formatting](./text_formatting.html)
"""

nbSave
