#!/bin/bash
. ./import.sh strict log arguments

# Generate documentation for each source file and store it into ./docs/
# directory as .md (markdown) files, then use static site generator to
# convert makdown to HTML.

DOCS_DIR="./docs"
INDEX="index.md"

main() {
  mkdir -p "$DOCS_DIR" || panic "Can't create \"$DOCS_DIR\" directory to store documentation."

  info "Copying documentation files to \"$DOCS_DIR\"."
  cp -f README.md  TODO.md LICENSE "$DOCS_DIR/" || panic "Can't copy documentation files to \"$DOCS_DIR\"."

  echo -n "" > "$DOCS_DIR/$INDEX"
  echo "* [README](README.html)" >> "$DOCS_DIR/$INDEX"
  echo "* [TODO](TODO.html)" >> "$DOCS_DIR/$INDEX"
  echo "* [LICENSE](LICENSE)" >> "$DOCS_DIR/$INDEX"

  info "Generating doucumentation for import.sh script."
  ./import.sh --man >"$DOCS_DIR/import.sh.md" || panic "Can't generate documetation in Markdown format for \"import.sh\" script."

  echo "* [import.sh main script](import.sh.html)" >> "$DOCS_DIR/$INDEX"

  local source_file module
  for source_file in ./bash-modules/src/bash-modules/*.sh
  do
    module="${source_file##*/}"
    module="${module%.sh}"

    info "Generating doucumentation for \"$module\" module."
    ./import.sh --doc "$source_file" > "$DOCS_DIR/$module.md" || panic "Can't generate documetation in Markdown format for \"$module\" module."

    echo "* [$module module]($module.html)" >> "$DOCS_DIR/$INDEX"
  done

  local md_file html_file title
  for md_file in docs/*.md
  do
    html_file="${md_file%.md}.html"
    title="${md_file##*/}"
    title="${title%.md}"

    info "Converting \"$md_file\" markdown file to \"$html_file\" HTML file."
    pandoc -f markdown -t html --standalone --metadata "title=$title" -o "$html_file" "$md_file" || panic "Can't convert \"$md_file\" markdown file to \"$html_file\" HTML file."
  done
}

main "$@"
