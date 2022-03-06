import std/[strutils, sequtils, algorithm, strformat]
import nimib
import nimib/renders

const document = """
<!DOCTYPE html>
<html>
  {{> head}}
  <body>
  {{> main}}
  </body>
</html>
"""

const head = """
<head>
  <meta content="text/html; charset=utf-8" http-equiv="content-type">
  {{> revealCSS }}
</head>
"""

const main = """
<div class="reveal">
  <div class="slides">
    {{#blocks}}
    {{&.}}
    {{/blocks}}
  </div>
</div>
{{> revealJS }}
<script>
  Reveal.initialize({
    plugins: [ 
      RevealHighlight,
      {{#latex}}
      RevealMath.KaTeX
      {{/latex}}
    ]
  });
</script>
"""

const revealCSS = """
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/reveal.min.css" integrity="sha512-vFD6wFRj2whK8/X/dMgxJHinKfGlwMYtN+yRCxvxvmOgIiMIlgrFb5iOuCoqwCID+Qcq2/gY8DpmNHcAjfHWxw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/theme/{{{slidesTheme}}}.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/plugin/highlight/monokai.min.css" integrity="sha512-z8wQkuDRFwCBfoj7KOiu1MECaRVoXx6rZQWL21x0BsVVH7JkqCp1Otf39qve6CrCycOOL5o9vgfII5Smds23rg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
"""

const revealJS = """
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/reveal.js" integrity="sha512-+Dy2HJZ3Z1DWerDhqFE7AH2HTfnbq8RC1pKOashfMwx1s01fjPUebWoHqrRedU1yFimkexmzJJRilKxjs7lz8g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/plugin/highlight/highlight.min.js" integrity="sha512-U3fPDUX5bMrn1wnYqjaK44MFA9E6MKS+zPAg9WPAGF5XhReBeDj3FGaA831CjueG+YJxYA3WaO/m33kMIoOs/A==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
{{#latex}}
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.1/plugin/math/math.min.js" integrity="sha512-8eviRBLZHoiXLqXeMl5XurkjNEGizTI8DHbSUoGxkYFd4RslHpIYTEQmLYtWUemc5FfMYOkPDFUcQKefPLjF7A==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
{{/latex}}
"""

type
  FragmentAnimation* = enum
    fadeIn = "fade-in" # the default
    fadeOut = "fade-out"
    fadeUp = "fade-up"
    fadeDown = "fade-down"
    fadeLeft = "fade-left"
    fadeRight = "fade-right"
    fadeInThenOut = "fade-in-then-out"
    fadeInThenSemiOut = "fade-in-then-semi-out"
    grow = "grow"
    semiFadeOut = "semi-fade-out"
    shrink = "shrink"
    strike = "strike"
    highlightRed = "highlight-red"
    highlightGreen = "highlight-green"
    highlightBlue = "highlight-blue"
    highlightCurrentRed = "highlight-current-red"
    highlightCurrentGreen = "highlight-current-green"
    highlightCurrentBlue = "highlight-current-blue"
  Slide* = ref object
    pos*: tuple[start: int, finish: int]
    notes*: seq[string]
  SlidesCtx* = ref object
    sections*: seq[seq[Slide]]
  SlidesTheme* = enum
    Black, Beige, Blood, League, Moon, Night, Serif, Simple, Sky, Solarized, White

################################
# This is modified code from nimib.
# We need to render code blocks using the context to populate the {{ endFragment-i }} fields.
################################

#[ proc renderHtmlTextOutput*(output: string, doc: NbDoc): string =
  renderMarkdown(output.strip).render(doc.context)

proc renderHtmlBlock*(blk: NbBlock, doc: NbDoc): string =
  case blk.kind
  of nbkText:
    result = blk.output.renderHtmlTextOutput(doc)
  of nbkCode:
    result = blk.code.renderHtmlCodeBody
    if blk.output != "":
      result.add blk.output.renderHtmlCodeOutput
  of nbkImage:
    let
      image_url = blk.code
      caption = blk.output
    result = fmt"""
<figure>
<img src="{image_url}" alt="{caption}">
<figcaption>{caption}</figcaption>
</figure>
""" & "\n" ]#
###########################
###########################

template initReveal*() =
  ## Call this after nbInit
  ##var slidesCtx {.inject.} = SlidesCtx(sections: @[@[Slide(pos: (start: 0, finish: -1))]])
  nb.context["currentFragment"] = 0
  nb.context["currentEndFragment"] = 0

#[   template slideRight() =
    ## Add a slide to the right of the current one
    slidesCtx.sections[^1][^1].pos.finish = nb.blocks.len - 1
    slidesCtx.sections.add @[Slide(pos: (start: nb.blocks.len, finish: -1))]

  template slideDown() =
    ## Add a slide below the current one
    slidesCtx.sections[^1][^1].pos.finish = nb.blocks.len - 1
    slidesCtx.sections[^1].add (Slide(pos: (start: nb.blocks.len, finish: -1))) ]#

  template slideRight(body: untyped) =
    nbText: "<section>"
    body
    nbText: "</section>"
  
  template slideDown(body: untyped) =
    nbText: "<section>"
    body
    nbText: "</section>"

  template fragmentCore2(animations: openArray[seq[FragmentAnimation]] = @[], endAnimations: openArray[seq[FragmentAnimation]] = @[], body: untyped) =
    newNbBlock("fragment", nb, nb.blk, body):
      discard

  template fragmentCore(animations: openArray[seq[FragmentAnimation]] = @[], endAnimations: openArray[seq[FragmentAnimation]] = @[], body: untyped) =
    ## Creates a fragment of the content of body. Nesting works.
    ## animations: each seq in animations are animations that are to be applied at the same time. The first seq's animations
    ##             are applied on the first button click, and the second seq's animations on the second click etc.
    ## endAnimations: animations that should be applied AT THE END of block. 
    ## Example: 
    ## `fragment(@[@[fadeIn, highlightBlue], @[shrink, semiFadeOut]]): block` will at the first click of a button fadeIn and highlightBlue
    ## the content of the block. At the second click the same content will shrink and semiFadeOut. This code is also equivilent with
    ## `fragment(@[@[fadeIn, highlightBlue]]): fragment(@[@[shrink, semiFadeOut]]): block`.
    ## `fragment(@[@[fadeIn]], @[@[fadeOut]]): block` will first fadeIn the entire block and perform eventual animations in nested fragments. Once
    ## all of those are finished, it will run fadeOut on the entire block and its subfragments.
    var endIds: seq[string]
    for level in animations: # level are the animations to be applied simulataniously to a fragment
      let classStr = join(level, " ")
      let dataIndexStr = "data-fragment-index=\"" & $(nb.context["currentFragment"].vInt) & "\""
      nbText: "<div class=\"fragment " & classStr & "\" " & dataIndexStr & ">"
      nb.context["currentFragment"] = nb.context["currentFragment"].vInt + 1
    for level in endAnimations:
      let classStr = join(level, " ")
      let id = "endFragment-" & $(nb.context["currentEndFragment"].vInt)
      let dataIndexStr = "data-fragment-index=\"" & "{{ " & id & " }}" & "\""
      nbText: "<div class=\"fragment " & classStr & "\" " & dataIndexStr & ">"
      nb.context["currentEndFragment"] = nb.context["currentEndFragment"].vInt + 1
      endIds.add id
    body
    for id in endIds:
      # Add the end indices after the block:
      nb.context[id] = $(nb.context["currentFragment"].vInt)
      echo "\n\n\n\n\n" & id, " ", nb.context[id]
      nb.context["currentFragment"] = nb.context["currentFragment"].vInt + 1
    nbText: "</div>".repeat(animations.len + endAnimations.len) # add a closing tag for every level

  template fragment(animations: varargs[seq[FragmentAnimation]] = @[@[fadeIn]], body: untyped): untyped =
    ## Creates a fragment of the content of body. Nesting works.
    ## animations: each seq of the varargs are animations that are to be applied at the same time. The first seq's animations
    ##             are applied on the first button click, and the second seq's animations on the second click etc.
    ## Example: 
    ## `fragment(@[fadeIn, highlightBlue], @[shrink, semiFadeOut]): block` will at the first click of a button fadeIn and highlightBlue
    ## the content of the block. At the second click the same content will shrink and semiFadeOut. This code is also equivilent with
    ## `fragment(@[fadeIn, highlightBlue]): fragment(@[shrink, semiFadeOut]): block`.
    fragmentCore(@animations):
      body

  template fragment(animation: FragmentAnimation, body: untyped) =
    ## fragment(animation) is shorthand for fragment(@[animation])
    fragmentCore(@[@[animation]]):
      body

  template fragmentFadeIn(animation: FragmentAnimation, body: untyped) =
    fragmentCore(@[@[fadeIn], @[animation]]):
      body

  template fragmentEnd(endAnimation: varargs[seq[FragmentAnimation]], body: untyped) =
    fragmentCore(endAnimations = @endAnimation):
      body

  template fragmentEnd(endAnimation: FragmentAnimation, body: untyped) =
    fragmentCore(endAnimations = @[@[endAnimation]]):
      body

  template animateCode(lines: varargs[HSlice[int, int]], body: untyped) =
    ## Shows code and its output just like nbCode, but highlights different lines of the code in the order specified in `lines`.
    ## lines: Specify which lines to highlight and in which order. (Must be specified as a HSlice)
    ## Ex: 
    ## ```nim
    ## animateCode(1..1, 2..3, 5..5, 4..4): body
    ## ```
    ## This will first highlight line 1, then lines 2 and 3, then line 5 and last line 4.
    newNbBlock("animateCode", nb, nb.blk, body):
      var linesString: string
      if lines.len > 0:
        linesString &= "|"
      for line in lines:
        linesString &= $line.a & "-" & $line.b & "|"
      if lines.len > 0:
        linesString = linesString[0 .. ^2]
      nb.blk.context["highlightLines"] = linesString
      body


  template bigText(text: string) =
    nbText: "<h2 class=\"r-fit-text\">" & text & "</h2>"

  template removeCodeOutput =
    if nb.blocks.len > 0:
      var blk = nb.blocks[^1]
      if blk.kind == nbkCode:
        blk.output = ""

  template setSlidesTheme(theme: SlidesTheme) =
    nb.context["slidesTheme"] = ($theme).toLower

  template useLocalReveal(path: string) =
    discard
    # set nb.partials["revealCSS/JS"]
    # Should we set it relative to homeDir or srcDir?

#[   proc renderSlide(doc: NbDoc, slide: Slide): string =
    let upper = 
      if slide.pos.finish != -1: slide.pos.finish
      else: doc.blocks.len - 1
    
    result = "<section>\n"
    for i in slide.pos.start .. upper:
      result &= doc.blocks[i].renderHtmlBlock(doc)
    result &= "</section>\n"

  proc renderReveal*(doc: NbDoc): string =
    var content: string
    for horiz in slidesCtx.sections:
      content &= "<section>\n" # this is the top level section
      for vertical in horiz:
        # vertical corresponds to a single slide with many blocks. Must loop over them all and call `renderHTMLBlock` 
        # if vertical.finish == -1: it is the last slide, grab the rest of all blocks
        content &= doc.renderSlide(vertical)
      content &= "</section>\n"
    doc.context["slides"] = content
    # This is neccecary because it will show the <span> tag otherwise:
    result = "{{> document}}".render(doc.context).replace("<code class=\"nim hljs\">", "<code class=\"nim hljs\" data-noescape>")
    result = result.replace("<pre><samp", "<pre style=\"width: 100%;\"><samp class=\"hljs\"") # add some background to code output block
    result = result.replace("<pre>", "<pre style=\"width: 100%\">") # this makes code blocks a little bit wider

  nb.render = renderReveal ]#    

proc revealTheme*(doc: var NbDoc) =
  doc.partials["document"] = document
  doc.partials["head"] = head
  doc.partials["main"] = main
  doc.partials["nbCodeSource"] = "<pre style=\"width: 100%\"><code class=\"nim hljs\" data-noescape>{{&codeHighlighted}}</code></pre>"
  doc.partials["nbCodeOutput"] = "{{#output}}<pre style=\"width: 100%;\"><samp class=\"hljs\">{{output}}</samp></pre>{{/output}}"

  doc.partials["revealCSS"] = revealCSS
  doc.partials["revealJS"] = revealJS

  doc.partials["animateCode"] = "<pre style=\"width: 100%\"><code class=\"nim hljs\" data-noescape data-line-numbers=\"{{&highlightLines}}\">{{&codeHighlighted}}</code></pre>"
  doc.renderPlans["animateCode"] = doc.renderPlans["nbCode"]

  doc.context["slidesTheme"] = "black"


