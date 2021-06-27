bash-modules
============

## Simple module system for bash.

Main goal of the project is to provide developers with set of bash subroutines, which are:

  * useful;
  * work in strict mode (set -ue);
  * correctly handle strings with spaces and special characters;
  * covered by test cases;
  * use as little external commands as possible;
  * well documented.

Our goals:

* [x] implement module loader;
* [x] implement few modules with frequently used functions and routines;
* [ ] implement a repository for extra modules;
* [ ] implement a package manager for modules.

## Features:

* module for logging;
* module for parsing of arguments;
* module for unit testing;
* full support for unofficial strict mode.

## Full example:

```bash
#!/bin/bash
. import.sh strict log arguments

# Name of someone to grit
NAME="world"

# Number of times to grit someone
TIMES_TO_GRIT=1

hw() {
  local name="${1:?ERROR: Argument is required: a name to grit.}"

  info "Hello, $name!"

  return 0
}

main() {
  local i
  for((i=0; i<TIMES_TO_GRIT; i++))
  do
    hw "$NAME" || panic "Cannot greet \"$NAME\"."
  done
}

arguments::parse \
    '-n|--name)NAME;String,Required' \
    '-m|--more)TIMES_TO_GRIT;Incremental,((TIMES_TO_GRIT<=3))' \
    -- "$@" || panic "Cannot parse arguments."

main "${ARGUMENTS[@]}"
exit $?

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
#> Examples:
#>   * ./hw.sh --name user
#>   * HW_NAME="user" ./hw.sh
```
