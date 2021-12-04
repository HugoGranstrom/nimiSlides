import std/[strutils]
import nimib
import nimib/renders

const document = """
<html>
  <head>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/reveal.min.css" integrity="sha512-vFD6wFRj2whK8/X/dMgxJHinKfGlwMYtN+yRCxvxvmOgIiMIlgrFb5iOuCoqwCID+Qcq2/gY8DpmNHcAjfHWxw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/theme/black.min.css" integrity="sha512-DKeDMgkMDBNgY3g8T6H6Ft5cB7St0LOh5d69BvETIcTrP0E3d3KhANTMs5QOTMnenXy6JVKz/tENmffCLeXPiQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/plugin/highlight/monokai.min.css" integrity="sha512-z8wQkuDRFwCBfoj7KOiu1MECaRVoXx6rZQWL21x0BsVVH7JkqCp1Otf39qve6CrCycOOL5o9vgfII5Smds23rg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  </head>
  <body>
    <div class="reveal">
      <div class="slides">
        {{{ slides }}}
      </div>
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/reveal.js" integrity="sha512-+Dy2HJZ3Z1DWerDhqFE7AH2HTfnbq8RC1pKOashfMwx1s01fjPUebWoHqrRedU1yFimkexmzJJRilKxjs7lz8g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/plugin/highlight/highlight.min.js" integrity="sha512-U3fPDUX5bMrn1wnYqjaK44MFA9E6MKS+zPAg9WPAGF5XhReBeDj3FGaA831CjueG+YJxYA3WaO/m33kMIoOs/A==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script>
      Reveal.initialize({
        plugins: [ RevealHighlight ]
      });
    </script>
  </body>
</html>
"""

type
  SlidesCtx* = ref object
    sections*: seq[seq[tuple[start: int, finish: int]]]

template initReveal*() =
  ## Call this after nbInit
  var slidesCtx {.inject.} = SlidesCtx(sections: @[@[(start: 0, finish: -1)]])

  template slideRight() =
    ## Add a slide to the right of the current one
    slidesCtx.sections[^1][^1].finish = nb.blocks.len - 1
    slidesCtx.sections.add @[(start: nb.blocks.len, finish: -1)]

  template slideDown() =
    ## Add a slide below the current one
    slidesCtx.sections[^1][^1].finish = nb.blocks.len - 1
    slidesCtx.sections[^1].add (start: nb.blocks.len, finish: -1)

  template slideRight(body: untyped) =
    slideRight()
    body
  
  template slideDown(body: untyped) =
    slideDown()
    body

  proc renderReveal*(doc: NbDoc): string =
    var content: string
    for horiz in slidesCtx.sections:
      content &= "<section>\n" # this is the top level section
      for vertical in horiz:
        # vertical corresponds to a single slide with many blocks. Must loop over them all and call `renderHTMLBlock` 
        # if vertical.finish == -1: it is the last slide, grab the rest of all blocks
        let upper = 
          if vertical.finish != -1: vertical.finish
          else: doc.blocks.len - 1
        
        content &= "<section>\n"
        for i in vertical.start .. upper:
          content &= doc.blocks[i].renderHtmlBlock
        content &= "</section>\n"
      content &= "</section>\n"

    doc.context["slides"] = content
    # This is neccecary because it will show the <span> tag otherwise:
    result = "{{> document}}".render(doc.context).replace("<code class=\"nim hljs\">", "<code class=\"nim hljs\" data-noescape>")
    result = result.replace("<pre><samp", "<pre style=\"background: #262623\"><samp") # add some background to code output block
    result = result.replace("<pre", "<pre style=\"width: 100%\" ") # this makes code blocks a little bit wider

  nb.render = renderReveal    

proc revealTheme*(doc: var NbDoc) =
  doc.partials["document"] = document


