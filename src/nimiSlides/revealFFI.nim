when defined(js):
  import std / [jsffi, dom, strutils]

  type
    RevealType* = ref object of JsObject
    RevealEvent* = ref object of JsObject
      indexh*: cint
      indexv*: cint
      previousSlide*, currentSlide*: Element
      fragment*: Element

  var Reveal* {.importjs, nodecl.}: RevealType

  proc isAnimatedCode*(el: Element): bool =
    for node in el.attributes:
      if node.nodeName == "data-line-numbers":
        return true

  proc getFragmentIndex*(el: Element): int =
    for node in el.attributes:
      # use custom attribute as reveal changes data-fragment-index from what we gave it
      if node.nodeName == "data-fragment-index-nimib".cstring:
        let fragmentIndex = ($node.nodeValue).parseInt
        return fragmentIndex
    raise newException(ValueError, "Element doesn't have a data-fragment-index field")

  proc on*(reveal: RevealType, event: cstring, listener: proc (event: RevealEvent)) {.importjs: "#.on(#, #)".}
  template onReveal*(revealEvent: cstring, listener: proc (event: RevealEvent)) =
    window.addEventListener("load", proc (event: Event) =
      Reveal.on(revealEvent, listener)
    )
  
  proc isReady*(reveal: RevealType): bool {.importjs: "#.isReady()".}

  template onRevealReady*(body: untyped) =
    window.addEventListener("load", proc (event: Event) =
      # if reveal already is ready, then run the code directly as the event won't trigger anymore.
      if Reveal.isReady():
        body
      else:
        window.addEventListener("load", proc (e: Event) =
          Reveal.on("ready", proc (event: RevealEvent) =
            body
          )
        )
    )

  proc getRevealElement*(reveal: RevealType): Element {.importjs: "#.getRevealElement()".}
