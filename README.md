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
    #>>> hw.sh - hello, world! See --help for details.
    
    . import.sh strict log arguments
    
    #>
    #> Environment variables:
    
    #>
    #> HW_NAME -  name of someone to greet. Default value: "world".
    NAME="${HW_NAME:-world}"
    
    #>
    #> Functions:
    
    #>
    #> hw NAME - greet someone by name.
    hw() {
      local NAME="${1:?ERROR: Argument is required: a name to greet.}"
      info "Hello, $NAME!"
    }
    
    #>
    #> main - main function.
    main() {
      #>>
      #>> Usage:
      #>> hw.sh [OPTIONS]
      #>>
      #>> Options:
      #>>   * -h | --help - show this text.
      #>>   * --man - show documentation.
      #>>   * -n | --name NAME - name of someone to greet. Default value: "world".
      arguments::parse \
        '-n|--name)NAME;String' \
        -- "$@" || exit 1
    
      hw "$NAME"
      exit $?
    }
    
    main "$@"
    
    #>
    #> See also:
    #>   * import.sh --list  - show list of available modules.
    #>   * import.sh --usage arguments  - show usage information for 
