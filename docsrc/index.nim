import nimib, nimiSlides, nimiBook
import ./utils/embeddedReveal

nbInit(theme = useNimibook)

nbText: hlMd"""
# Documentation - nimiSlides
nimiSlides is Reveal.js theme for nimib which enables you to make beautiful slideshows just by writing Nim code.

nimiSlides is a [nimib](https://github.com/pietroppeter/nimib) library. Check out [nimib's documentation](https://pietroppeter.github.io/nimib/) as well.

## API Reference
All procs and templates are documented in the [API Reference](./docs/nimiSlides.html). For easier CTRL-F see [the index](./docs/theindex.html).

## Tutorials
See the [tutorials](./tutorials/index.html) section in the sidebar to the left. If you are new to nimiSlides, [getting started](./tutorials/getting_started.html) is a good place to start.
The [tutorials](./tutorials/index.html) page provides a table showing which features (procs/template names) are covered in each tutorial. It's a handy place to CTRL-F to see if there are any tutorials for a specific feature.


## Examples
Here is a list of slideshows along with links to their source code.
- [Showcase](./showcase.html) ([source code](https://github.com/HugoGranstrom/nimiSlides/blob/main/docsrc/showcase.nim)) 
  Showcases many of the features of nimiSlides.
- [NimConf 2022 nimiSlides](./nimconf2022.html) ([source code](https://github.com/HugoGranstrom/nimiSlides/blob/main/docsrc/nimconf2022.nim)) 
  The slides from my 2022 NimConf talk about nimiSlides.
- [NimConf 2022 nimib](https://pietroppeter.github.io/nimconf22-nimib/) ([source code](https://github.com/pietroppeter/nimconf22-nimib)) 
  The slides from the 2022 NimConf talk about nimib.

## Reveal.js
As nimiSlides generates Reveal.js slideshows, it's worth having a look at the [Reveal.js documentation](https://revealjs.com/).
"""

# TODO:
# List tutorials
# Add links to existing slides
# Move content from README to here instead
# To show the 2D, we could use nbFile to read in the code that generates a slideshow and then link to it. Iframe peraps?
#   embedded slideshow block?

nbSave()