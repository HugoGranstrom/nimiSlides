import nimib, nimiSlides
import std / [strutils]

template initEmbeddedSlides*(slidesTheme: SlidesTheme = Black) =
  nbRawHtml: hlHtml"""
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/reveal.min.css" integrity="sha512-USp+nLNMZ1hR0Ll/LpYDxIq47Ypcm3KfjIleOnyFrB1N5KfHLXjfPQD1wQlhv7kVHRRgPvNVtendDS72LyHviA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/theme/$1.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/plugin/highlight/monokai.min.css" integrity="sha512-z8wQkuDRFwCBfoj7KOiu1MECaRVoXx6rZQWL21x0BsVVH7JkqCp1Otf39qve6CrCycOOL5o9vgfII5Smds23rg==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/reveal.js" integrity="sha512-9dFFU5pcR8K4bvw4ng6mLMW5IjslYbA57amHEMtHn3TT9RkKivsDabKffqjUUJ4pCaojAyH05T1OESld199Gcw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/plugin/highlight/highlight.min.js" integrity="sha512-RCedMo/DOyawQOh4zYtqEHTZAfgrrVQctN3LVCX5kELGsN52TOdwZ8inRY0l9Mo4vtyDFn6oOAgRUilWXgb+wA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/plugin/notes/notes.min.js" integrity="sha512-MZ7Ehjbh2soaeCZJGaw6vBNAa7+eunl0SUmRPNESchLlboH73lHLEeUa6pZJ2Pcui4NcpDFatr6M+VlcmaH1QA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/plugin/math/math.min.js" integrity="sha512-skPZpuRwuUAnF9iEEFBXc4zJaucKcHUDgY1wDBTv0ILy82C2gn8MJsbcinzj2u8r/iZjD/78HRgw2/n//poOhQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
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