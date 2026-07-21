import nimib, nimiSlides
import std / [strutils]

template initEmbeddedSlides*(slidesTheme: SlidesTheme = Black) =
  nbRawHtml: hlHtml"""
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/$2/reveal.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/$2/theme/$1.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/$2/plugin/highlight/monokai.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />

<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/$2/reveal.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/$2/plugin/highlight/highlight.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/$2/plugin/notes/notes.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/$2/plugin/math/math.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
""" % [($slidesTheme).toLower(), reveal_version]

  nbRawHtml: """
<style>
table tbody tr:nth-child(2n) {
  background: 0;
}
</style>
"""

  nb.populateNimiSlidesBlockPartials()

  nb.disableHighlightJs()

template embeddedSlides*(body: untyped) =
  currentFragment = 0
  currentSlideNumber = 0
  let id = "revealId" & $nb.doc.newId()
  nbRawHtml: hlHtmlF"""
  <div class="reveal" id="$1" style="height: 400px;">
    <div class="slides">
""" % [id]

  body

  nbRawHtml: hlHtml"""
    </div>
  </div>
  <script>
    let deck_$1 = new Reveal(document.getElementById("$1"), {
      embedded: true,
      keyboardCondition: 'focused',
      plugins: [
        RevealHighlight,
        RevealNotes,
        RevealMath.KaTeX
      ]
    })
    deck_$1.initialize()
  </script>
""" % [id]
  
template codeAndSlides*(body: untyped) =
  nbCodeSkip:
    body
  embeddedSlides:
    body