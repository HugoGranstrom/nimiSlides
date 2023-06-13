import nimibook

var book = initBookWithToc:
  entry("Documentation", "index.nim", numbered = false)
  section("Tutorials", "tutorials/index.md"):
    entry("Getting Started", "getting_started.nim")
    entry("Code Blocks", "code_block.nim")
    entry("Text Formatting", "text_formatting.nim")
    entry("Images & Media", "images_media.nim")
    entry("Layout", "layout.nim")
    section("Fragments (Animations)", "fragments/index.nim"):
      entry("Basics of Fragments", "basics.nim")
      entry("Animated Lists", "lists.nim")
      entry("List of Fragments", "list_fragments.nim")
      entry("End Fragments", "end_fragments.nim")
      entry("Advanced Fragments", "advanced_fragments.nim")
    entry("Slide Options", "slide_options.nim")
    entry("Backgrounds", "backgrounds.nim")
    entry("Themes", "themes.nim")
    entry("Speaker View", "speaker.nim")
    entry("Local Reveal.js installation", "local_reveal.nim")
    entry("Misc", "misc.nim")

  entry("Gotchas", "gotchas.nim")

nimibookCli(book)