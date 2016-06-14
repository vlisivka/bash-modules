#!/bin/bash
#>>> hw.sh - hello, world! Use --help for details.

. import.sh strict log arguments

#>
#> Environment variables:

#>
#> HW_NAME - name of someone to grit. Default value: "world".
NAME="${HW_NAME:-world}"

#>
#> Functions:

#>
#> hw NAME - greet someone by name.
hw() {
  local NAME="${1:?ERROR: Argument is required: a name to grit.}"
  info "Hello, $NAME!"
  return 0
}

#>
#> main - main function.
main() {
  #>>
  #>> Usage:
  #>>   hw.sh [OPTIONS]
  #>>
  #>> Options:
  #>>   * -h | --help - show this text.
  #>>   * --man - show documentation.
  #>>   * -n | --name NAME - name of someone to greet. Default value: "world".
  arguments::parse \
    '-n|--name)NAME;String' \
    -- "$@" || log::panic "ERROR" "Cannot parse arguments."

  hw "$NAME" || panic "Cannot greet \"$NAME\"."

  exit 0
}

main "$@"

#>
#> Examples:
#>   * ./hw.sh --name user
#>   * HW_NAME="user" ./hw.sh
#>
#> See also:
#>   * import.sh --list  - show list of available modules.
#>   * import.sh --usage arguments  - show usage information for 
