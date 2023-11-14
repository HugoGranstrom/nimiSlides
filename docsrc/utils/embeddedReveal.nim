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

  nb.partials["nbCodeSource"] = "<pre style=\"width: 100%\"><code class=\"nim hljs\" data-noescape data-line-numbers>{{&codeHighlighted}}</code></pre>"
  nb.partials["nbCodeOutput"] = "{{#output}}<pre style=\"width: 100%;\"><samp class=\"hljs\">{{output}}</samp></pre>{{/output}}"

  nb.partials["animateCode"] = "<pre style=\"width: 100%;\"><code class=\"nim hljs\" data-noescape data-line-numbers=\"{{&highlightLines}}\">{{&codeHighlighted}}</code></pre>\n" & nb.partials["nbCodeOutput"]
  nb.renderPlans["animateCode"] = nb.renderPlans["nbCode"]

  nb.partials["fragmentStart"] = """
{{#fragments}}
<div class="fragment {{&classStr}}" data-fragment-index="{{&fragIndex}}" data-fragment-index-nimib="{{&fragIndex}}"> 
{{/fragments}}
  """

  nb.partials["fragmentEnd"] = """
{{#fragments}}
</div>
{{/fragments}}
  """

  nb.partials["bigText"] = """<h2 class="r-fit-text"> {{&outputToHtml}} </h2>"""
  nb.renderPlans["bigText"] = nb.renderPlans["nbText"]

  nb.context["disableHighlightJs"] = true

template embeddedSlides*(body: untyped) =
  currentFragment = 0
  currentSlideNumber = 0
  let id = "revealId" & $nb.newId()
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