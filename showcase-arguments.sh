#!/bin/bash
. import.sh strict log arguments

NAME="John"
AGE=42
MARRIED="no"


main() {
  info "Name: $NAME"
  info "Age: $AGE"
  info "Married: $MARRIED"
  info "Other arguments: $*"
}

arguments::parse \
  "-n|--name)NAME;String,Required" \
  "-a|--age)AGE;Number,(( AGE >= 18 ))" \
  "-m|--married)MARRIED;Yes" \
  -- "$@" || panic "Cannot parse arguments. Use \"--help\" to show options."

main "${ARGUMENTS[@]}" || exit

# Comments marked by "#>>" are shown by --help.
# Comments marked by "#>" and "#>>" are shown by --man.

#> Example of a script with parsing of arguments.
#>>
#>> Usage: showcase-arguments.sh [OPTIONS] [--] [ARGUMENTS]
#>>
#>> OPTIONS:
#>>
#>>   -h|--help       show this help screen.
#>>   --man           show complete manual.
#>>   -n|--name NAME  set name. Name must not be empty. Default name is "John".
#>>   -a|--age  AGE   set age. Age must be >= 18. Default age is 42.
#>>   -m|--married    set married flag to "yes". Default value is "no".
#>>
