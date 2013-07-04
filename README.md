bash-modules
============

Simple module system for bash.

Main goal of the project is to provide developers with set of bash subroutines, which are:
  * useful;
  * work in strict mode (set -ue);
  * correctly handle strings with spaces and special characters;
  * covered by test cases;
  * use as little external commands as possible;
  * well documented.

Example:

    #!/bin/bash
    . import.sh log arguments
    
    NAME="world"
    
    parse_arguments "-n|--name)NAME;S" -- "$@" || {
      error "Cannot parse command line."
      exit 1
    }
    
    info "Hello, $NAME!"
    
