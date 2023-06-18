import nimib, nimibook, nimiSlides
import ../../utils/embeddedReveal

nbInit(theme = useNimibook)
initEmbeddedSlides()

nbText: hlMd"""
# Advanced Fragments
This tutorial covers some of the more advanced and less common fragment features.

## `fragmentNext`
`fragmentNext` has the effect that it will run at the same time as the next fragment.
This might sound confusing so let's look at an example:
"""

codeAndSlides:
  slide:
    fragment(grows):
      fragment(strike):
        nbText: "Two steps"

    fragmentNext(grows):
      fragment(strike):
        nbText: "One step"

nbText: hlMd"""
As you can see, the `fragmentNext` ran at the same time as the nested `strike`,
compared to the nested `fragment` which ran after each other. Why not just use
`fragment(@[grows, strike])` in this case, you may ask? That's a valid question and you are correct,
in this case that would have been possible. But what if you had a templated that accepted a `body: untyped`
parameter and wanted to add a `grows` fragment to it? Then you wouldn't know about the `fragment(strike)` in this case.
That's a pretty advanced use-case, but this is the advanced tutorial after all.

## `fragmentThen`
`fragmentThen` has the effect of creating effects like `fadeInThenOut` where the second
part is run at the same time as the next fragment. Here's an example, note when the animation of the second text
starts in both cases:
"""

codeAndSlides:
  slide:
    fragment(fadeInThenOut):
      nbText: "fadeinThenOut"
    fragment:
      nbText: "Shows on second step"
  slide:
    fragment(@[fadeIn], @[fadeOut]):
      nbText: "fadeinThenOut"
    fragment:
      nbText: "Shows on third step"

nbText: hlMd"""
Do you notice the difference between the two slides? On the first slide the second text fades in at the same time
as the first text fades out. On the second slide the second text appears on the step *after* the first text has disappeared.
It's the behavior of the first slide that `fragmentThen` allows us to obtain for our own combination of fragments.
Let's create a `growsThenShrinks` animation using `fragmentThen` and compare it:
"""

codeAndSlides:
  slide:
    fragmentThen(grows, shrinks):
      nbText: "Grow then shrink"
    fragment:
      nbText: "Shows on second step"
  slide:
    fragment(@[grows], @[shrinks]):
      nbText: "Grow then shrink"
    fragment:
      nbText: "Shows on third step"

nbText: hlMd"""
I hope you understand what `fragmentThen` does now. It reduces the amount of click you have to do to go through your slides.
`fragmentThen` can also accept two `seq`s with the fragments to run at the two steps:
"""

codeAndSlides:
  slide:
    fragmentThen(@[fadeIn, highlightCurrentGreen], @[strike, semiFadeOut]):
      nbText: "Fade in & green, then semiFadeOut and strike"
    fragment:
      nbText: "Show on second step"

nbSave
