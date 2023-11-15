proc toHSlice*(h: HSlice[int, int]): HSlice[int, int] = h
proc toHSlice*(h: int): HSlice[int, int] = h .. h


proc toSet*(x: set[range[0..65535]]): set[range[0..65535]] = x
proc toSet*(x: int): set[range[0..65535]] = {x}
proc toSet*(x: Slice[int]): set[range[0..65535]] =
  for y in x:
    result.incl y
proc toSet*(x: seq[Slice[int]]): set[range[0..65535]] =
  for s in x:
    result.incl s.toSet()
proc toSet*(x: set[range[0..255]]): set[range[0..65535]] =
  for y in x:
    result.incl y