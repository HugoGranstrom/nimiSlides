import nimib, nimibook, nimiSlides
import ../../utils/embeddedReveal
import std / strutils

nbInit(theme = useNimibook)
initEmbeddedSlides()

var names: array[FragmentAnimation, string]

names[fadeIn] = "fadeIn" # the default
names[fadeOut] = "fadeOut"
names[fadeUp] = "fadeUp"
names[fadeDown] = "fadeDown"
names[fadeLeft] = "fadeLeft"
names[fadeRight] = "fadeRight"
names[fadeInThenOut] = "fadeInThenOut"
names[fadeInThenSemiOut] = "fadeInThenSemiOut"
names[grows] = "grows"
names[semiFadeOut] = "semiFadeOut"
names[shrinks] = "shrinks"
names[strike] = "strike"
names[highlightRed] = "highlightRed"
names[highlightGreen] = "highlightGreen"
names[highlightBlue] = "highlightBlue"
names[highlightCurrentRed] = "highlightCurrentRed"
names[highlightCurrentGreen] = "highlightCurrentGreen"
names[highlightCurrentBlue] = "highlightCurrentBlue"

for (frag, x) in names.pairs:
  doAssert x.len > 0, "List of fragments not documented for fragment: $1" % [$frag]

nbText: hlMd"""
# List of Fragments
This document lists and shows all the fragments (animations) available in nimiSlides.
"""

for frag in FragmentAnimation:
  nbText: "## `$1`" % [names[frag]]
  embeddedSlides:
    slide:
      fragment(frag):
        nbText: names[frag]

nbSave
