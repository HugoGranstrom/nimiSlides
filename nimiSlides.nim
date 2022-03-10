import std/[strutils, strformat, sequtils]
import nimib
import nimib/capture

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

  SlidesTheme* = enum
    Black, Beige, Blood, League, Moon, Night, Serif, Simple, Sky, Solarized, White

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

proc revealTheme*(doc: var NbDoc) =
  doc.partials["document"] = document
  doc.partials["head"] = head
  doc.partials["main"] = main
  doc.partials["nbCodeSource"] = "<pre style=\"width: 100%\"><code class=\"nim hljs\" data-noescape>{{&codeHighlighted}}</code></pre>"
  doc.partials["nbCodeOutput"] = "{{#output}}<pre style=\"width: 100%;\"><samp class=\"hljs\">{{output}}</samp></pre>{{/output}}"

  doc.partials["revealCSS"] = revealCSS
  doc.partials["revealJS"] = revealJS

  doc.partials["rawBlock"] = "{{&output}}"

  doc.partials["animateCode"] = "<pre style=\"width: 100%\"><code class=\"nim hljs\" data-noescape data-line-numbers=\"{{&highlightLines}}\">{{&codeHighlighted}}</code></pre>\n" & doc.partials["nbCodeOutput"]
  doc.renderPlans["animateCode"] = doc.renderPlans["nbCode"]

  doc.partials["fragmentStart"] = """
{{#fragments}}
<div class="fragment {{&classStr}}" data-fragment-index="{{&fragIndex}}"> 
{{/fragments}}
  """

  doc.partials["fragmentEnd"] = """
{{#fragments}}
</div>
{{/fragments}}
  """
  doc.context["slidesTheme"] = "black"

template useLocalReveal*(path: string) =
  discard
  # set nb.partials["revealCSS/JS"]
  # Should we set it relative to homeDir or srcDir?

template setSlidesTheme*(theme: SlidesTheme) =
  nb.context["slidesTheme"] = ($theme).toLower

template initReveal*() =
  ## Call this after nbInit
  discard

var currentFragment: int

template rawBlock*(body: untyped) =
  newNbBlock("rawBlock", nb, nb.blk, body):
    nb.blk.output = block:
      body

template slide*(autoAnimate: untyped, body: untyped): untyped =
  if autoAnimate:
    rawBlock: "<section data-auto-animate>"
  else:
    rawBlock: "<section>"
  when declaredInScope(CountVarNimiSlide):
    when CountVarNimiSlide < 2:
      static: inc CountVarNimiSlide
      body
      static: dec CountVarNimiSlide
    else:
      {.error: "You can only nest slides once!".}
  else:
    var CountVarNimiSlide {.inject, compileTime.} = 1 # we just entered the first level
    body
    static: dec CountVarNimiSlide
  rawBlock: "</section>"

template slide*(body: untyped) =
  slide(autoAnimate=false):
    body

template fragmentStartBlock(fragments: seq[Table[string, string]], animations: openArray[seq[FragmentAnimation]], endAnimations: openArray[seq[FragmentAnimation]], body: untyped) =
  newNbBlock("fragmentStart", nb, nb.blk, body):
    for level in animations:
      var frag: Table[string, string]
      frag["classStr"] = join(level, " ") # eg. fade-in highlight-blue
      frag["fragIndex"] = $currentFragment
      currentFragment += 1
      fragments.add frag

template fragmentEndBlock(fragments: seq[Table[string, string]], animations: openArray[seq[FragmentAnimation]], endAnimations: openArray[seq[FragmentAnimation]], startBlock: NbBlock) =
  # Fragments might be nested, so set fragIndex of endAnimations after the body has been run to get the correct indices
  newNbBlock("fragmentEnd", nb, nb.blk, body):
    for level in endAnimations:
      var frag: Table[string, string]
      frag["classStr"] = join(level, " ") # eg. fade-in highlight-blue
      frag["fragIndex"] = $currentFragment
      currentFragment += 1
      fragments.add frag
  nb.blk.context["fragments"] = fragments # set for end block
  assert nb.blk != startBlock
  startBlock.context["fragments"] = fragments # set for start block

template fragmentCore*(animations: openArray[seq[FragmentAnimation]], endAnimations: openArray[seq[FragmentAnimation]], body: untyped) =
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
  var fragments: seq[Table[string, string]]
  fragmentStartBlock(fragments, animations, endAnimations, body)
  var startBlock = nb.blk # this *should* be the block created by fragmentStartBlock
  body
  fragmentEndBlock(fragments, animations, endAnimations, startBlock)

template fragment*(animations: varargs[seq[FragmentAnimation]] = @[@[fadeIn]], body: untyped): untyped =
  ## Creates a fragment of the content of body. Nesting works.
  ## animations: each seq of the varargs are animations that are to be applied at the same time. The first seq's animations
  ##             are applied on the first button click, and the second seq's animations on the second click etc.
  ## Example: 
  ## `fragment(@[fadeIn, highlightBlue], @[shrink, semiFadeOut]): block` will at the first click of a button fadeIn and highlightBlue
  ## the content of the block. At the second click the same content will shrink and semiFadeOut. This code is also equivilent with
  ## `fragment(@[fadeIn, highlightBlue]): fragment(@[shrink, semiFadeOut]): block`.
  fragmentCore(@animations, newSeq[seq[FragmentAnimation]]()):
    body

template fragment*(animation: FragmentAnimation, body: untyped) =
  ## fragment(animation) is shorthand for fragment(@[animation])
  fragment(@[@[animation]]):
    body

template fragment*(body: untyped) =
  fragment(@[@[fadeIn]]):
    body

template fragmentFadeIn*(animation: FragmentAnimation, body: untyped) =
  fragment(@[@[fadeIn], @[animation]]):
    body

template fragmentFadeIn*(animation: varargs[seq[FragmentAnimation]], body: untyped) =
  fragment(concat([@[@[fadeIn]], @animation])):
    body

template fragmentFadeIn*(body: untyped) =
  fragment(@[@[fadeIn]]):
    body

template fragmentEnd*(endAnimation: varargs[seq[FragmentAnimation]], body: untyped) =
  fragmentCore(newSeq[seq[FragmentAnimation]](), @endAnimation):
    body

template fragmentEnd*(endAnimation: FragmentAnimation, body: untyped) =
  fragmentCore(newSeq[seq[FragmentAnimation]](), @[@[endAnimation]]):
    body

proc toHSlice*(h: HSlice[int, int]): HSlice[int, int] = h
proc toHSlice*(h: int): HSlice[int, int] = h .. h

template animateCode*(lines: varargs[seq[HSlice[int, int]]], body: untyped) =
  ## Shows code and its output just like nbCode, but highlights different lines of the code in the order specified in `lines`.
  ## lines: Specify which lines to highlight and in which order. (Must be specified as a seq[HSlice])
  ## Ex: 
  ## ```nim
  ## animateCode(@[1..1], @[3..4, 6..6]): body
  ## ```
  ## This will first highlight line 1, then lines 3, 4 and 6.
  newNbBlock("animateCode", nb, nb.blk, body):
    var linesString: string
    if lines.len > 0:
      linesString &= "|"
    for lineBundle in lines:
      for line in lineBundle:
        linesString &= $line.a & "-" & $line.b & ","
      linesString &= "|"
    if lines.len > 0:
      linesString = linesString[0 .. ^3]
    nb.blk.context["highlightLines"] = linesString
    captureStdout(nb.blk.output):
      body

template animateCode*(lines: varargs[HSlice[int, int], toHSlice], body: untyped) =
  ## Shows code and its output just like nbCode, but highlights different lines of the code in the order specified in `lines`.
  ## lines: Specify which lines to highlight and in which order. (Must be specified as a HSlice)
  ## Ex: 
  ## ```nim
  ## animateCode(1..1, 2..3, 5..5, 4..4): body
  ## ```
  ## This will first highlight line 1, then lines 2 and 3, then line 5 and last line 4.
  var s: seq[seq[HSlice[int, int]]]
  for line in lines:
    s.add @[line]
  animateCode(s):
    body


template bigText*(text: string) =
  rawBlock: "<h2 class=\"r-fit-text\">" & text & "</h2>"

template removeCodeOutput*() =
  if nb.blocks.len > 0:
    var blk = nb.blocks[^1]
    if blk.command in ["nbCode", "animateCode"]:
      blk.output = ""
      blk.context["output"] = ""




