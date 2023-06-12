# Package

version       = "0.2.2"
author        = "Hugo Granström"
description   = "Reveal.js theme for nimib"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 1.4.0"
requires "nimib >= 0.3.9"

import os

task docsDeps, "install dependencies required to build docs":
    exec "nimble -y install ggplotnim@0.5.6 karax numericalnim nimibook"

task buildDocs, "build all .nim files in docsrc/":
    for (kind, path) in walkDir("docsrc/"):
        if path.endsWith(".nim"):
            if "index" in path: continue 
            echo "Building: " & path
            let buildCommand = "nim r " & path
            exec buildCommand
            if "showcase" in path:
                let buildCommand = "nim r -d:themeWhite " & path
                exec buildCommand

task buildBook, "Builds the nimiBook docs":
    selfExec(" r -d:release nbook.nim init")
    selfExec(" r -d:release nbook.nim build")

task docs, "Generate automatic docs":
    exec "nim doc --project --index:on --git.url:https://github.com/HugoGranstrom/nimiSlides --git.commit:master --outdir:docs/docs src/nimiSlides.nim"

