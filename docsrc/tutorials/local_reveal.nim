import nimib, nimibook, nimiSlides

nbInit(theme = useNimibook)
nbText: hlMd"""
# Local Reveal.js installation
By default nimiSlide will use a CDN version of Reveal.js so it will only work if you are connected to the internet. If you want to use it offline you have to download a release from their [Github](https://github.com/hakimel/reveal.js). Unzip the zip file in your `homeDir` (specified in `nimib.toml` or else it is the same directory that your `.nim` file is in). For example if your nimib `homeDir` is in `docs`, you unzip the Reveal.js file there such that the folder structure is as follows (in this example Reveal.js 4.5.0 is used but your version might be different):
```
docs/
  reveal.js-4.5.0/
    css/
    dist/
    js/
    plugin/
    etc...
  *here your .nim and .html files would be*
```
There are two ways to specify the path of the local Reveal.js distribution:

### Option 1: Add path in nimib.toml
Add a `[nimislides]` section to your `nimib.toml` file and add a field `localReveal = "reveal.js-4.5.0"` where the path is relative to the `homeDir`. This will make all your slides in the repo use the local Reveal.js.

### Option 2: Call useLocalReveal in your presentation file
Call `useLocalReveal` with the path of the RevealJs folder relative to your nimib `homeDir`. This will only use the local Reveal.js for the specific slides that run this code:
"""

nbCode:
  nb.useLocalReveal("reveal.js-4.5.0")

nbSave
