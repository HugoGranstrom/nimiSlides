import std/[strutils, strformat, sequtils, os]
export os
import nimib
import nimib/capture
import toml_serialization

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
    grows = "grow"
    semiFadeOut = "semi-fade-out"
    shrinks = "shrink"
    strike = "strike"
    highlightRed = "highlight-red"
    highlightGreen = "highlight-green"
    highlightBlue = "highlight-blue"
    highlightCurrentRed = "highlight-current-red"
    highlightCurrentGreen = "highlight-current-green"
    highlightCurrentBlue = "highlight-current-blue"

  SlidesTheme* = enum
    Black, Beige, Blood, League, Moon, Night, Serif, Simple, Sky, Solarized, White

  NimiSlidesConfig* = object
    localReveal*: string

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
{{> customJS}}
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

proc useLocalReveal*(nb: var NbDoc, path: string) =
  let path = nb.srcDirRel.string / path
  let themeString = "{{{slidesTheme}}}"
  nb.partials["revealCSS"] = fmt"""
<link rel="stylesheet" href="{path}/dist/reveal.css"/>
<link rel="stylesheet" href="{path}/dist/theme/{themeString}.css"/>
<link rel="stylesheet" href="{path}/plugin/highlight/monokai.css"/>  
  """
  
  let latexStart = "{{#latex}}"
  let latexEnd = "{{/latex}}"
  nb.partials["revealJS"] = fmt"""
<script src="{path}/dist/reveal.js"></script>
<script src="{path}/plugin/highlight/highlight.js"></script>
{latexStart}
<script src="{path}/plugin/math/math.js"></script>
{latexEnd}
  """

template setSlidesTheme*(theme: SlidesTheme) =
  nb.context["slidesTheme"] = ($theme).toLower

proc revealTheme*(doc: var NbDoc) =
  doc.partials["document"] = document
  doc.partials["head"] = head
  doc.partials["main"] = main
  doc.partials["nbCodeSource"] = "<pre style=\"width: 100%\"><code class=\"nim hljs\" data-noescape data-line-numbers>{{&codeHighlighted}}</code></pre>"
  doc.partials["nbCodeOutput"] = "{{#output}}<pre style=\"width: 100%;\"><samp class=\"hljs\">{{output}}</samp></pre>{{/output}}"

  doc.partials["revealCSS"] = revealCSS
  doc.partials["revealJS"] = revealJS

  doc.partials["animateCode"] = "<pre style=\"width: 100%\"><code class=\"nim hljs\" data-noescape data-line-numbers=\"{{&highlightLines}}\">{{&codeHighlighted}}</code></pre>\n" & doc.partials["nbCodeOutput"]
  doc.renderPlans["animateCode"] = doc.renderPlans["nbCode"]

  doc.partials["fragmentStart"] = """
{{#fragments}}
<div class="fragment {{&classStr}}" data-fragment-index="{{&fragIndex}}" data-fragment-index-nimib="{{&fragIndex}}"> 
{{/fragments}}
  """

  doc.partials["fragmentEnd"] = """
{{#fragments}}
</div>
{{/fragments}}
  """

  doc.partials["bigText"] = """<h2 class="r-fit-text"> {{&outputToHtml}} </h2>"""
  doc.renderPlans["bigText"] = doc.renderPlans["nbText"]

  doc.context["slidesTheme"] = "black"

  try:
    let slidesConfig = Toml.decode(doc.rawCfg, NimiSlidesConfig, "nimislides")
    if slidesConfig.localReveal != "":
      echo "Using local Reveal.js installation specified in nimib.toml "
      doc.useLocalReveal(slidesConfig.localReveal)
  except TomlError:
    discard # if it doesn't exists, just let it be

var currentFragment: int

template slide*(autoAnimate: untyped, body: untyped): untyped =
  if autoAnimate:
    nbRawOutput: "<section data-auto-animate>"
  else:
    nbRawOutput: "<section>"
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
  nbRawOutput: "</section>"

template slide*(body: untyped) =
  slide(autoAnimate=false):
    body

template fragmentStartBlock(fragments: seq[Table[string, string]], animations: openArray[seq[FragmentAnimation]], endAnimations: openArray[seq[FragmentAnimation]]) =
  newNbSlimBlock("fragmentStart"):
    for level in animations:
      var frag: Table[string, string]
      frag["classStr"] = join(level, " ") # eg. fade-in highlight-blue
      frag["fragIndex"] = $currentFragment
      currentFragment += 1
      fragments.add frag

template fragmentEndBlock(fragments: seq[Table[string, string]], animations: openArray[seq[FragmentAnimation]], endAnimations: openArray[seq[FragmentAnimation]], startBlock: NbBlock) =
  # Fragments might be nested, so set fragIndex of endAnimations after the body has been run to get the correct indices
  newNbSlimBlock("fragmentEnd"):
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
  ## `fragment(@[@[fadeIn, highlightBlue], @[shrinks, semiFadeOut]]): block` will at the first click of a button fadeIn and highlightBlue
  ## the content of the block. At the second click the same content will shrink and semiFadeOut. This code is also equivilent with
  ## `fragment(@[@[fadeIn, highlightBlue]]): fragment(@[@[shrinks, semiFadeOut]]): block`.
  ## `fragment(@[@[fadeIn]], @[@[fadeOut]]): block` will first fadeIn the entire block and perform eventual animations in nested fragments. Once
  ## all of those are finished, it will run fadeOut on the entire block and its subfragments.
  var fragments: seq[Table[string, string]]
  fragmentStartBlock(fragments, animations, endAnimations)
  var startBlock = nb.blk # this *should* be the block created by fragmentStartBlock
  body
  fragmentEndBlock(fragments, animations, endAnimations, startBlock)

template fragment*(animations: varargs[seq[FragmentAnimation]] = @[@[fadeIn]], body: untyped): untyped =
  ## Creates a fragment of the content of body. Nesting works.
  ## animations: each seq of the varargs are animations that are to be applied at the same time. The first seq's animations
  ##             are applied on the first button click, and the second seq's animations on the second click etc.
  ## Example: 
  ## `fragment(@[fadeIn, highlightBlue], @[shrinks, semiFadeOut]): block` will at the first click of a button fadeIn and highlightBlue
  ## the content of the block. At the second click the same content will shrink and semiFadeOut. This code is also equivilent with
  ## `fragment(@[fadeIn, highlightBlue]): fragment(@[shrinks, semiFadeOut]): block`.
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

#[ template fragmentList*(list: seq[string], animation: varargs[seq[FragmentAnimation]]) =
  for s in list:
    fragment(animation):
      nbText: s

template fragmentList*(list: seq[string], animation: FragmentAnimation) =
  fragmentList(list, @[@[animation]]) ]#
  

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
  newNbCodeBlock("animateCode", body):
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

template customJS(code: string) =
  nb.partials["customJS"] = nb.partials.getOrDefault("customJS", "") & "\n" & code

template typewriter*(textMessage: string, typeSpeed = 50, alignment = "center") =
  let localText = textMessage
  let speed = typeSpeed
  let align = alignment
  # HTML and add eventlistener
  # check what we get back from reveal's event
  let fragIndex = currentFragment # important it is before fragmentFadeIn!
  let id = "typewriter" & $nb.newId()
  fragmentFadeIn:
    nbKaraxCode(id, localText, fragIndex, speed, align):
      import nimiSlides/revealFFI
      import karax / vstyles
      var i = 0
      proc typewriterLocal() =
        echo "Typing ", fragindex
        var el = getElementById(id.cstring)
        if i < localText.len:
          el.innerHtml &= $localText[i]
          inc i
          discard setTimeout(typewriterLocal, speed)
      karaxHtml:
        p(id = id, style=style(textAlign, align.kstring))
      
      window.addEventListener("load", proc (event: Event) =
        echo "Loading ", fragIndex
        Reveal.on("fragmentshown",
          proc (event: RevealEvent) =
            if not event.fragment.isAnimatedCode:
              let index = event.fragment.getFragmentIndex()
              if fragIndex == index:
                var el = getElementById(id.string)
                el.innerHtml = ""
                i = 0
                echo "Starting ", fragIndex
                typewriterLocal()
              # else: save the timeout and end it and set innerhtml to full text
        )
        Reveal.on("fragmenthidden",
          proc (event: RevealEvent) =
            if not event.fragment.isAnimatedCode:
              let index = event.fragment.getFragmentIndex()
              if fragIndex == index:
                discard
        ))

  #[ nbRawOutput: """
  <p id="test">hej</p>
  """
  # try using reveal's eventlistener instead by checking the current fragment index!
  # This requires the typewriter to be localted inside a fragment!
  customJS: """
  const text = "This text is typwritten"
  var i = 0
  const el = document.getElementById("test")

  function typewriter() {
    if (i < text.length) {
      el.innerHTML += text.charAt(i)
      i++
      setTimeout(typewriter, 100)
    }
  }

  var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      if(mutation.attributeName === 'style'){
        console.log("style change");
      }
    });    
  });

  // Notify me of style changes
  var observerConfig = {
    attributes: true, 
    attributeFilter: ["style"]
  };

  observer.observe(el, observerConfig)
  console.log(el)

  /*
  const observer = new IntersectionObserver((entries, observer) => {
    const ent = entries[0]
    const target = ent.target
    console.log(ent)
    if (ent.isIntersecting) {
      console.log("Visible!")
      setTimeout(typewriter, 1000)
    } else {
      console.log("Invisible")
      el.innerHTML = ""
      i = 0
    }
  }, {rootMargin: '0px', threshhold: 1.0});
  observer.observe(el);
  */
  """ ]#

template bigText*(text: string) =
  newNbSlimBlock("bigText"):
    nb.blk.output = text





