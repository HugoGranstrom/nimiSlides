# Package

version       = "0.2.4"
author        = "Hugo Granström"
description   = "Reveal.js theme for nimib"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 1.4.0"
requires "nimib >= 0.3.9"

import os

task docsDeps, "install dependencies required to build docs":
    exec "nimble -y install ggplotnim@0.5.6 karax numericalnim nimibook@#head"

task buildDocs, "build all .nim files in docsrc/":
    for path in ["showcase.nim", "nimconf2022.nim", "miscSlides.nim", "index_old.nim", "fragments.nim"]:
        let path = "docsrc" / path
        echo "Building: " & path
        let buildCommand = "nim r " & path
        exec buildCommand
        if "showcase" in path:
            let buildCommand = "nim r -d:themeWhite " & path
            exec buildCommand

task buildBook, "Builds the nimiBook docs":
    selfExec(" r nbook.nim init")
    selfExec(" r nbook.nim build")

task docs, "Generate automatic docs":
    exec "nim doc --project --index:on --git.url:https://github.com/HugoGranstrom/nimiSlides --git.commit:main --outdir:docs/docs src/nimiSlides.nim"

