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
    
    main() {
      info "Hello, $NAME!"
    }
    
    parse_arguments \
      '-n|--name)NAME;String,Required' \
      -- "$@" || exit 1
    
    main
    
    __END__

    =pod
    
    Script built-in help text in POD format...
