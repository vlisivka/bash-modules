bash-modules
============

## Simple module system for bash.

Module loader and collection of modules for bash scripts, to quickly write safe bash scripts in unofficial bash strict mode.

Currentyl, bash-modules are targetting users of Linux OS, such as system administrators.

bash-modules is developed at Fedora Linux and requires bash 4 or higher.

## Syntax

```bash
. import.sh MODULE[...]
```

## Example

```bash
#!/bin/bash
. import.sh log
info "Hello, world!"
```

See more examples in [bash-modules/examples](bash-modules/examples) directory.

## License

Bash-modules is licensed under terms of LGPL2+ license, like glibc. You are not allowed to copy-paste the code of this project into an your non-GPL project, but are free to use, modify, or distribute it as a separate library.

## Vision

My vision for the project is to create a loadable set of bash subroutines, which are:

  * useful;
  * work in strict mode (set -ue);
  * correctly handle strings with spaces and special characters;
  * use as little external commands as possible;
  * easy to use;
  * well documented;
  * well covered by test cases.

## Features:

* module for logging;
* module for parsing of arguments;
* module for unit testing;
* full support for unofficial strict mode.

## TODO:

* [x] implement module loader;
* [x] implement few modules with frequently used functions and routines;
* [ ] implement a repository for extra modules;
* [ ] implement a package manager for modules or integrate with an existing PM.

## Showcase - log module

```bash
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

main "${ARGUMENTS[@]}"
```


## Showcase - arguments module


```bash
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
  "-m|--married)MARRIED;Boolean" \
  -- "$@" || panic "Cannot parse arguments. Use \"--help\" to show options."

main "${ARGUMENTS[@]}"
exit

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
```

