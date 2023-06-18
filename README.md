# nimiSlides 🛷 - Make beautiful presentations easily in Nim 👑

nimiSlides is Reveal.js theme for nimib which enables you to make beautiful slideshows just by writing Nim code.

https://user-images.githubusercontent.com/5092565/178597724-16287a00-5c31-4500-83d8-e07160a36369.mp4

A showcase of all nimiSlides' features can be found here: https://hugogranstrom.com/nimiSlides/showcase.html ([source code](https://github.com/HugoGranstrom/nimiSlides/blob/main/docsrc/showcase.nim))

# NimConf 2022
At NimConf 2022, I did a presentation on nimiSlides which can be viewed [here](https://www.youtube.com/watch?v=Sf1TndCcIlU&list=PLxLdEZg8DRwSQQaK0UVRd1DaetVc3lIwr&index=7). The slides from the talk can be viewed at [https://hugogranstrom.com/nimiSlides/nimconf2022.html](https://hugogranstrom.com/nimiSlides/nimconf2022.html).

# Our goal 🥇

Our goal is to provide the easiest way to create a slideshow in Nim, about Nim. And this while also providing
lots of flexibility so you can tailor it to your liking.

# Documentation & Learning Material
- [API Reference](https://hugogranstrom.com/nimiSlides/docs/nimiSlides.html)
- [Documentation](https://hugogranstrom.com/nimiSlides)

# Roadmap 🗺
- [X] Make available `fragments` (https://revealjs.com/fragments/)
  - [x] Make it work with default options
  - [x] Support fragment animations
  - [x] Make fragments nestable
  - [x] Use `data-fragment-index` to allow ending blocks with an animation. Eg. fadeOut an entire block once it's finished.
  - [X] Make it work with lists
- [X] Make available code animations (https://revealjs.com/code/)
  - [X] Line numbers
  - [x] Highlight lines
  - [x] Make overload for showing lines of code that aren't beside each other. (api: `animateCode(seq[HSlice[int, int]])`)
- [X] Presenter mode note (https://revealjs.com/speaker-view/)
- [ ] Auto-slide (https://revealjs.com/auto-slide/)
- [x] Fit text (https://revealjs.com/layout/#fit-text)
- [x] Backgrounds
- [ ] Transitions (https://revealjs.com/transitions/)
- [ ] Custom fragments ()
- [X] Automatic animations
- [X] Typewriter effect
