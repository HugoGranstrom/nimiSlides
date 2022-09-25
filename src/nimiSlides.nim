import std/[strutils, strformat, sequtils, os]
export os
import nimib
import nimib/capture
import toml_serialization
import markdown

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

  SlideOptions* = object
    autoAnimate*: bool
    colorBackground*: string
    imageBackground*: string
    videoBackground*: string
    iframeBackground*: string
    iframeInteractive*: bool

proc slideOptions*(autoAnimate = false, iframeInteractive = true, colorBackground, imageBackground, videoBackground, iframeBackground: string = ""): SlideOptions =
  SlideOptions(
    autoAnimate: autoAnimate, iframeInteractive: iframeInteractive, colorBackground: colorBackground,
    imageBackground: imageBackground, videoBackground: videoBackground,
    iframeBackground: iframeBackground
  )

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
  {{#nb_style}}
  <style>
  {{{ nb_style }}}
  </style>
  {{/nb_style}}
</head>
"""

const main = """
<div class="reveal">
  <div class="slides">
    {{#blocks}}
    {{&.}}
    {{/blocks}}
  </div>
  {{#revealFooter}}
  <div id="reveal-footer" style="position: absolute; text-align: center; width: 100%; bottom: 0%; visibility: hidden; opacity: {{footerOpacity}}; font-size: {{footerFontSize}}px">
    {{&revealFooter}}
  </div>
  {{/revealFooter}}
</div>
{{> revealJS }}
<script>
  Reveal.initialize({
    plugins: [ 
      RevealHighlight,
      RevealNotes,
      {{#latex}}
      RevealMath.KaTeX,
      {{/latex}}
    ],
    {{#useScrollWheel}}
    mouseWheel: true,
    {{/useScrollWheel}}
    {{#showSlideNumber}}
    slideNumber: 'c/t',
    {{/showSlideNumber}}
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.2.0/plugin/notes/notes.min.js" integrity="sha512-v2co+5nr0bgHekutTzF5jAB0UAjM95dpCF7VVw7WsFCjfxonbQo8Vwl487tNYl0iHWHHGV4o5xKBp5ifyhJkWg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
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
<script src="{path}/plugin/notes/notes.js"></script>
{latexStart}
<script src="{path}/plugin/math/math.js"></script>
{latexEnd}
  """

template setSlidesTheme*(theme: SlidesTheme) =
  nb.context["slidesTheme"] = ($theme).toLower

template useScrollWheel*() =
  ## Enable using the scroll-wheel to step forward in slides.
  nb.context["useScrollWheel"] = true

template showSlideNumber*() =
  nb.context["showSlideNumber"] = true

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
  doc.context["nb_style"] = ""


  try:
    let slidesConfig = Toml.decode(doc.rawCfg, NimiSlidesConfig, "nimislides")
    if slidesConfig.localReveal != "":
      echo "Using local Reveal.js installation specified in nimib.toml "
      doc.useLocalReveal(slidesConfig.localReveal)
  except TomlError:
    discard # if it doesn't exists, just let it be

proc addStyle*(doc: NbDoc, style: string) =
  doc.context["nb_style"] = doc.context["nb_style"].vString & "\n" & style

var currentFragment: int

template slide*(options: untyped, body: untyped): untyped =
  var attributes: string
  if options.autoAnimate:
    attributes.add "data-auto-animate "
  if options.colorBackground.len > 0:
    attributes.add """data-background-color="$1" """ % [options.colorBackground]
  elif options.imageBackground.len > 0:
    attributes.add """data-background-image="$1" """ % [options.imageBackground]
  elif options.videoBackground.len > 0:
    attributes.add """data-background-video="$1" """ % [options.videoBackground]
  elif options.iframeBackground.len > 0:
    attributes.add """data-background-iframe="$1" """ % [options.iframeBackground]
    if options.iframeInteractive:
      attributes.add "data-background-interactive "

  nbRawHtml: "<section $1>" % [attributes]
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
  nbRawHtml: "</section>"

template slide*(body: untyped) =
  slide(slideOptions()):
    body

template fragmentStartBlock(fragments: seq[Table[string, string]], animations: openArray[seq[FragmentAnimation]], endAnimations: openArray[seq[FragmentAnimation]], indexOffset: int, incrementCounter: bool) =
  newNbSlimBlock("fragmentStart"):
    for level in animations:
      var frag: Table[string, string]
      frag["classStr"] = join(level, " ") # eg. fade-in highlight-blue
      frag["fragIndex"] = $(currentFragment + indexOffset)
      if incrementCounter:
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

template fragmentCore*(animations: openArray[seq[FragmentAnimation]], endAnimations: openArray[seq[FragmentAnimation]], indexOffset: untyped, incrementCounter: untyped, body: untyped) =
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
  fragmentStartBlock(fragments, animations, endAnimations, indexOffset, incrementCounter)
  var startBlock = nb.blk # this *should* be the block created by fragmentStartBlock
  body
  fragmentEndBlock(fragments, animations, endAnimations, startBlock)

template fragmentCore*(animations: openArray[seq[FragmentAnimation]], endAnimations: openArray[seq[FragmentAnimation]], body: untyped) =
  fragmentCore(animations, endAnimations, 0, true, body)

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

template fragmentThen*(an1, an2: seq[FragmentAnimation], body: untyped) =
  fragmentCore(@[an2], newSeq[seq[FragmentAnimation]](), 1, false): # trigger these on the next animation, but don't increment the counter.
    fragmentCore(@[an1], newSeq[seq[FragmentAnimation]]()):
      body

template fragmentThen*(an1, an2: FragmentAnimation, body: untyped) =
  fragmentThen(@[an1], @[an2]):
    body

template fragmentNext*(an: FragmentAnimation, body: untyped) =
  fragmentCore(@[@[an]], newSeq[seq[FragmentAnimation]](), 0, false):
    body

template fragmentNext*(an: seq[FragmentAnimation], body: untyped) =
  fragmentCore(@[an], newSeq[seq[FragmentAnimation]](), 0, false):
    body

template fadeInNext*(body: untyped) =
  fragmentNext(fadeIn):
    body

template fragmentList*(list: seq[string], animation: varargs[seq[FragmentAnimation]]) =
  for s in list:
    fragment(animation):
      nbText: s

template fragmentList*(list: seq[string], animation: FragmentAnimation) =
  fragmentList(list, @[@[animation]])

template orderedList*(body: untyped) =
  nbRawHtml: "<ol>"
  body
  nbRawHtml: "</ol>"

template unorderedList*(body: untyped) =
  nbRawHtml: "<ul>"
  body
  nbRawHtml: "</ul>"

template listItem*(animation: seq[FragmentAnimation], body: untyped) =
  var classString: string
  for an in animation:
    classString &= $an & " "
  fadeInNext:
    nbRawHtml: """<li class="fragment $1" data-fragment-index="$2" data-fragment-index-nimib="$2">""" % [classString, $currentFragment]
    currentFragment += 1
    body
    nbRawHtml: "</li>"

template listItem*(animation: FragmentAnimation, body: untyped) =
  listItem(@[animation], body)

template listItem*(body: untyped) =
  listItem(fadeInThenSemiOut, body)
  

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

template newAnimateCodeBlock*(cmd: untyped, impl: untyped) =
  template `cmd`*(lines: varargs[seq[HSlice[int, int]]], body: untyped) =
    newNbCodeBlock(cmd.astToStr, body):
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
    impl(body)

  template `cmd`*(lines: varargs[HSlice[int, int], toHSlice], body: untyped) =
    var s: seq[seq[HSlice[int, int]]]
    for line in lines:
      s.add @[line]
    `cmd`(s):
      body

  nb.partials[cmd.astToStr] = nb.partials["animateCode"]
  nb.renderPlans[cmd.astToStr] = nb.renderPlans["animateCode"]

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
      var timeout: Timeout
      proc typewriterLocal() =
        echo "Typing ", fragindex
        var el = getElementById(id.cstring)
        if i < localText.len:
          el.innerHtml &= $localText[i]
          inc i
          timeout = setTimeout(typewriterLocal, speed)
      karaxHtml:
        p(id = id, style=style(textAlign, align.kstring)):
          text localText.cstring
      
      window.addEventListener("load", proc (event: Event) =
        echo "Loading ", fragIndex
        Reveal.on("fragmentshown",
          proc (event: RevealEvent) =
            if not event.fragment.isAnimatedCode:
              let index = event.fragment.getFragmentIndex()
              if fragIndex == index:
                var el = getElementById(id.cstring)
                el.innerHtml = ""
                i = 0
                echo "Starting ", fragIndex
                typewriterLocal()
              else:
                var el = getElementById(id.cstring)
                i = localText.len
                if not timeout.isNil:
                  timeout.clearTimeout()
                el.innerHtml = localText.cstring
              # else: save the timeout and end it and set innerhtml to full text
        )
        Reveal.on("fragmenthidden",
          proc (event: RevealEvent) =
            if not event.fragment.isAnimatedCode:
              let index = event.fragment.getFragmentIndex()
              if fragIndex == index:
                discard
        ))

template bigText*(text: string) =
  newNbSlimBlock("bigText"):
    nb.blk.output = text

template speakerNote*(text: string) =
  nbRawHtml: """
<aside class="notes">
  $1
</aside>
""" % [markdown(text)]

template align*(text: string, body: untyped) =
  nbRawHtml: """
<div style="text-align: $1;">
""" % text
  body
  nbRawHtml: "</div>"

template columns*(body: untyped) =
  nbRawHtml: """<div style="display: grid; grid-auto-flow: column;">"""
  body
  nbRawHtml: "</div>"

template column*(bodyInner: untyped) =
  ## column should always be used inside a `columns` block
  nbRawHtml: "<div>"
  bodyInner
  nbRawHtml: "</div>"

template footer*(text: string, fontSize: int = 20, opacity: range[0.0 .. 1.0] = 0.6, rawHtml = false) =
  nb.context["footerFontSize"] = fontSize
  nb.context["footerOpacity"] = opacity
  if rawHtml:
    nb.context["revealFooter"] = text
  else:
    nb.context["revealFooter"] = markdown(text, config=initGfmConfig()).dup(removeSuffix)

  nbJsFromCode:
    import nimiSlides/revealFFI
    import std / [dom, jsconsole]
    echo "Before"
    onRevealReady:
      echo "Doing something!"
      let deck = Reveal.getRevealElement()
      let footer = getElementById("reveal-footer").cloneNode(true)
      footer.style.setProperty("visibility", "visible")
      deck.appendChild(footer)
      Reveal.on("slidechanged", proc (event: RevealEvent) =
        echo "slidechanged!"
        let currentSlide = event.currentSlide
        console.log currentSlide
        for node in currentSlide.attributes:
          # hide footer if fullscreen content is shown
          if node.nodeName in ["data-background-video".cstring, "data-background-iframe".string, "data-background-image".string]:
            footer.style.setProperty("visibility", "hidden")
            return
        footer.style.setProperty("visibility", "visible")
      )