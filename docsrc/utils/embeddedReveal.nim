import nimib, nimiSlides
import std / [strutils]

template initEmbeddedSlides*(slidesTheme: SlidesTheme = Black) =
  nbRawHtml: hlHtml"""
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/reveal.js" integrity="sha512-+Dy2HJZ3Z1DWerDhqFE7AH2HTfnbq8RC1pKOashfMwx1s01fjPUebWoHqrRedU1yFimkexmzJJRilKxjs7lz8g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/plugin/highlight/highlight.min.js" integrity="sha512-U3fPDUX5bMrn1wnYqjaK44MFA9E6MKS+zPAg9WPAGF5XhReBeDj3FGaA831CjueG+YJxYA3WaO/m33kMIoOs/A==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.1/plugin/math/math.min.js" integrity="sha512-8eviRBLZHoiXLqXeMl5XurkjNEGizTI8DHbSUoGxkYFd4RslHpIYTEQmLYtWUemc5FfMYOkPDFUcQKefPLjF7A==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/plugin/notes/notes.min.js" integrity="sha512-v2co+5nr0bgHekutTzF5jAB0UAjM95dpCF7VVw7WsFCjfxonbQo8Vwl487tNYl0iHWHHGV4o5xKBp5ifyhJkWg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/reveal.min.css" integrity="sha512-vFD6wFRj2whK8/X/dMgxJHinKfGlwMYtN+yRCxvxvmOgIiMIlgrFb5iOuCoqwCID+Qcq2/gY8DpmNHcAjfHWxw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/theme/$1.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/plugin/highlight/monokai.min.css" integrity="sha512-z8wQkuDRFwCBfoj7KOiu1MECaRVoXx6rZQWL21x0BsVVH7JkqCp1Otf39qve6CrCycOOL5o9vgfII5Smds23rg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
""" % [($slidesTheme).toLower()]

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