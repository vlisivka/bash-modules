#!/bin/bash
. import.sh strict log arguments

main() {
  debug "A debug message (use --debug option to show debug messages)."

  info "An information message. Arguments: $*"

  warn "A warning message."

  error "An error message."

  todo "A todo message."

  unimplemented "Not implemented."
}

arguments::parse -- "$@" || panic "Cannot parse arguments."

dbg ARGUMENTS

main "${ARGUMENTS[@]}" || exit
