import nimibook

var book = initBookWithToc:
  entry("Documentation", "index.nim", numbered = false)
  section("Tutorials", "tutorials/index.md"):
    entry("Getting Started", "getting_started.nim")

nimibookCli(book)