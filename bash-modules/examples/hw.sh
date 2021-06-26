#!/bin/bash
# hw.sh - hello, world! Use --help for details.

. import.sh strict log arguments

# Name of someone to grit
NAME="${HW_NAME:-world}"

hw() {
  local NAME="${1:?ERROR: Argument is required: a name to grit.}"
  info "Hello, $NAME!"
  return 0
}

main() {
  hw "$NAME" || panic "Cannot greet \"$NAME\"."

  exit 0
}

arguments::parse \
    '-n|--name)NAME;String,Required' \
    -- "$@" || panic "ERROR" "Cannot parse arguments."

main "${ARGUMENTS[@]}"; exit $?

#>> Usage: hw.sh [OPTIONS]
#>>
#>> Options:
#>>   -h | --help  show this help text.
#>>   --man        show documentation.
#>>   -n NAME | --name[=]NAME  name of someone to greet. Default value: "world".
#>>
#> Environment variables:
#>
#> HW_NAME - name of someone to grit. Default value: "world".
#>
#> Examples:
#>   * ./hw.sh --name user
#>   * HW_NAME="user" ./hw.sh
