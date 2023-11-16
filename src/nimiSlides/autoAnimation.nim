import nimib
import ./[conversions]

template autoAnimateSlides*(nSlides: int, body: untyped) =
  for autoAnimateCounter {.inject.} in 1 .. nSlides:
    slide(slideOptions(autoAnimate=true)):
      body

template showAt*(slideNrs: varargs[set[range[0..65535]], toSet], body: untyped) = # how to auto convert to set like in varargs?
  # use vararg and union all results!
  # This way you don't need to use the set syntax but can pass in `showOn(1, 2, 3)` instead.
  var totalSet: set[range[0..65535]]
  for x in slideNrs:
    totalSet.incl x

  if autoAnimateCounter in totalSet:
    body
  # The if-statement will cause some troubles for some code if it assumes it will be run in the same scope :/
  # To fix that we would need to require static inputs

template showFrom*(slideNr: int, body: untyped) =
  if autoAnimateCounter >= slideNr:
    body

template showUntil*(slideNr: int, body: untyped) =
  if autoAnimateCounter <= slideNr:
    body