# Package

version       = "0.1"
author        = "Hugo Granström"
description   = "Reveal.js theme for nimib"
license       = "MIT"

# Dependencies

requires "nim >= 1.4.0"
requires "nimib >= 0.2.4"

import os

task buildDocs, "build all .nim files in docs/":
    for (kind, path) in walkDir("docs/"):
        if path.endsWith(".nim"):
            echo "Building: " & path
            let buildCommand = "nim r -d:nimibPreviewCodeAsInSource " & path
            exec buildCommand
