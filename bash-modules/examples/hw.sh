#!/bin/bash
. import.sh strict log arguments

# Name of someone to greet
NAME="${HW_NAME:-world}"

# Number of times to greet someone
TIMES_TO_GREET=1

hw() {
  local name="${1:?ERROR: Argument is required: a name to greet.}"

  info "Hello, $name!"

  return 0
}

main() {
  local i
  for((i=0; i<TIMES_TO_GREET; i++))
  do
    hw "$NAME" || panic "Cannot greet \"$NAME\"."
  done
}

arguments::parse \
    '-n|--name)NAME;String,Required' \
    '-m|--more)TIMES_TO_GREET;Incremental,((TIMES_TO_GREET<=3))' \
    -- "$@" || panic "Cannot parse arguments."

main "${ARGUMENTS[@]}" || exit $?

# "#>" is doc comment, which will be shown by --man option.
# "#>>" is help comment, which will be shown by --help and --man.

#>> Usage: hw.sh [OPTIONS]
#>>
#>> Options:
#>>   -h | --help  show this help text.
#>>   --man        show documentation.
#>>   -n NAME | --name[=]NAME  name of someone to greet. Default value: "world".
#>>   -m | --more              greet one more time. Up to 3 times.
#>>
#> Environment variables:
#>
#> HW_NAME - name of someone to greet. Default value: "world".
#>
#> Examples:
#>   * ./hw.sh --name user
#>   * HW_NAME="user" ./hw.sh
