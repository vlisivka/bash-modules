##!/bin/bash
#
# Copyright (c) 2009-2013 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
#
# This file is part of bash-modules (http://trac.assembla.com/bash-modules/).
#
# bash-modules is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 2.1 of the License, or
# (at your option) any later version.
#
# bash-modules is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with bash-modules  If not, see <http://www.gnu.org/licenses/>.

[ "${__arguments__DEFINED:-}" == "yes" ] || {
  __arguments__DEFINED="yes"

  # Get path to main file
  __arguments_IND="${#BASH_SOURCE[*]}"
  __arguments__APP="${BASH_SOURCE[__arguments_IND-1]}"
  unset __arguments_IND

  arguments_summary() {
    echo "Parse commandline arguments."
  }

  arguments_usage() {
    echo '
parse_arguments		Parse arguments and assign them to variables

Usage:
  parse_arguments [-O|--LONG_OPTION)VARIABLE;FLAGS[,COND]...]... -- [ARGUMENTS]...

Where 
  -O		short option name
  --LONG_OPTION	long option name
  VARIABLE	shell variable name to assign value
  FLAGS:	one of (case sensitive):
    B | Bul | Boolean		boolean (no value);
    I | Inc | Incremental	incremental (no value) - increment variable by one;
    S | Str | String		string value;
    N | Num | Number		numeric value;
    A | Array			array of string values (multiple options);
  COND:		post conditions:
    R | Req | Requires		option is required, i.e. it must be not empty;
    any code 			executed after option parsing to check post conditions
				e.g. (( FOO > 3 )), (( FOO > BAR ))
  -- separator between option descriptions and commandline arguments
  ARGUMENTS	command line arguments to parse

Value for option can be set as -opt VALUE or as -opt=VALUE, but this
will work for last option name in case of multiple options. If option
description is "-b|--bar", then --bar=VALUE will work, but -b=VALUE will
not. If you will exchange options: "--bar|-b", then -b=VALUE will work,
but --bar=VALUE will not. You will need to create two separate option
descriptions for that to work in both cases.

Grouping of one-letter options is NOT supported. -abc will be parsed as
option -abc, not as -a -b -c.

By default, function supports -h|--help, --man and --debug options.
Options --help and --man are calling help() function with 1 or 2 as
argument. Override that function if you want to provide your own help.

For --help and --man to work, you need to add documentation in POD(Plain
Old Documentation) format into your program and perl distribution must
be installed. See perlpod for details. If perlpod is not found in path,
then help function will just display all text after first "=pod" line in
main source file.

Unlike many other parsers, this function stops option parsing at first
non-option argument.

Use -- in commandline arguments to strictly separate options and arguments.

After option parsing, unparsed command line arguments are stored in
ARGUMENTS array.

Example:

  parse_arguments "-f|--foo)FOO;B" "-b|--bar)BAR;S" "-B|--baz)BAZ;A" "-i|--inc)TIMES;I" -- "${@:+$@}"
  echo "Foo: $FOO, Bar: $BAR."
  IND=0; for I in "${BAZ[@]}"; do let IND++; echo "BAZ[$IND]=$I"; done
  echo "--inc option used $TIMES times."
  echo "Arguments count: ${#ARGUMENTS[@]}."
  echo "Arguments: ${ARGUMENTS[@]:+${ARGUMENTS[@]}}."

This module also contains helper function: __END__, which can be used to
separate source and documentation at end of source. It equivalent of "exit $?".

'
  }

  #
  # Display text section and the end of the main file
  #
  help() {
    local LEVEL="${1:-1}"
    if which pod2usage >/dev/null
    then
      pod2usage -verbose "$LEVEL" "$__arguments__APP"
    else
      local LINE POD="no"
      while read LINE
      do
        [ "$POD" == "no" ] || {
          echo "$LINE"
        }
        [ "$LINE" != "=pod" ] || {
          POD="yes"
        }
      done <"$__arguments__APP"
    fi
  }

  # Parse arguments and assign them to variables
  #
  # Format: -O|--long-option)VARIABLE;FLAGS ... -- ARGUMENTS...
  # Flags:
  # B - boolean (no value);
  # S - string value;
  # A - array of string values.
  parse_arguments() {

    # Global array to hold command line arguments
    ARGUMENTS=( )

    # Local variables
    local OPTION_DESCRIPTIONS PARSER
    declare -a OPTION_DESCRIPTIONS
    # Initialize array, because declare -a is not enough anymore for -u opt
    OPTION_DESCRIPTIONS=( )

    # Split arguments list at "--"
    while [ $# -gt 0 ]
    do
      [ "$1" != "--" ] || {
        shift
        break
      }

      OPTION_DESCRIPTIONS[${#OPTION_DESCRIPTIONS[@]}]="$1" # Append argument to end of array
      shift
    done

    # Generate parser and execute it
    PARSER="$(__generate_arguments_parser "${OPTION_DESCRIPTIONS[@]:+${OPTION_DESCRIPTIONS[@]}}")"
    eval "$PARSER" || return 1
    [ $# -eq 0 ] || __parse_arguments_sub "$@"
  }

  __generate_arguments_parser() {

    local OPTION_DESCRIPTION OPTION_CASE OPTION_FLAGS OPTION_TYPE OPTION_OPTIONS OPTIONS_PARSER="" OPTION_POSTCONDITIONS=""

    # Parse option description and generate code to parse that option from script arguments
    while [ $# -gt 0 ]
    do
      # Parse option description
      OPTION_DESCRIPTION="$1" ; shift

      # Check option syntax
      case "$OPTION_DESCRIPTION" in
        *')'*';'*) ;; # OK
        *)
          error "Incorrect syntax of option: \"$OPTION_DESCRIPTION\". Option syntax: -S|--FULL)VARIABLE;TYPE[,CHECK]... . Example: '-f|--foo)FOO;String,Required'."
          __log__DEBUG=yes; backtrace
          return 1
        ;;
      esac

      OPTION_CASE="${OPTION_DESCRIPTION%%)*}" # Strip everything after first ')': --foo)BAR -> --foo
      OPTION_VARIABLE="${OPTION_DESCRIPTION#*)}" # Strip everything before first ')': --foo)BAR -> BAR
      OPTION_FLAGS="${OPTION_VARIABLE#*;}" # Strip everything before first ';': BAR;Baz -> Baz
      OPTION_VARIABLE="${OPTION_VARIABLE%%;*}" # String everything after first ';': BAR;Baz -> BAR

      IFS=',' read -a OPTION_OPTIONS <<<"$OPTION_FLAGS" # Convert string into array: 'a,b,c' -> [ a b c ]
      OPTION_TYPE="${OPTION_OPTIONS[0]:-}" ; unset OPTION_OPTIONS[0] ; # First element of array is option type

      # Generate option parser for boolean variable
      case "$OPTION_TYPE" in
       B|Bool|Boolean) # Boolean - "yes" or "no"
          OPTIONS_PARSER="$OPTIONS_PARSER
          $OPTION_CASE)
            $OPTION_VARIABLE=\"yes\"
            shift 1
          ;;
          "
        ;;
       I|Incr|Incremental) # Incremental - any use of this option will increment variable by 1
          OPTIONS_PARSER="$OPTIONS_PARSER
          $OPTION_CASE)
            let $OPTION_VARIABLE++ || :
            shift 1
          ;;
          "
        ;;
        S|Str|String) # Regular strings
          OPTIONS_PARSER="$OPTIONS_PARSER
          $OPTION_CASE)
            $OPTION_VARIABLE=\"\${2:?ERROR: String value is required for \\\"$OPTION_CASE\\\" option. See --help for details.}\"
            shift 2
          ;;
          $OPTION_CASE=*)
            $OPTION_VARIABLE=\"\${1#*=}\"
            shift 1
          ;;
          "
        ;;
        N|Num|Number) # Same as string
          OPTIONS_PARSER="$OPTIONS_PARSER
          $OPTION_CASE)
            $OPTION_VARIABLE=\"\${2:?ERROR: Numeric value is required for \\\"$OPTION_CASE\\\" option. See --help for details.}\"
            shift 2
          ;;
          $OPTION_CASE=*)
            $OPTION_VARIABLE=\"\${1#*=}\"
            shift 1
          ;;
          "
        ;;
        A|Array) # Array of strings
          OPTIONS_PARSER="$OPTIONS_PARSER
          $OPTION_CASE)
            ${OPTION_VARIABLE}[\${#${OPTION_VARIABLE}[@]}]=\"\${2:?Value is required for \\\"$OPTION_CASE\\\". See --help for details.}\"
            shift 2
          ;;
          $OPTION_CASE=*)
            ${OPTION_VARIABLE}[\${#${OPTION_VARIABLE}[@]}]=\"\${1#*=}\"
            shift 1
          ;;
          "
        ;;
        *)
          echo "ERROR: Unknown option type: \"$OPTION_TYPE\"." >&2
          return 1
        ;;
      esac

      # Parse option options, e.g "Required". Any other text is treated as condition, e.g. (( VAR > 10 && VAR < 20 ))
      local OPTION_OPTION
      for OPTION_OPTION in "${OPTION_OPTIONS[@]:+${OPTION_OPTIONS[@]}}"
      do
        case "$OPTION_OPTION" in
          R|Req|Required)
            OPTION_POSTCONDITIONS="$OPTION_POSTCONDITIONS
              [ -n \"\$${OPTION_VARIABLE}\" ] || { echo \"ERROR: Option $OPTION_CASE is required. See --help for details.\" >&2; return 1; }
            "
          ;;
          *) # Any other code after option type i
            OPTION_POSTCONDITIONS="$OPTION_POSTCONDITIONS
              $OPTION_OPTION || { echo \"ERROR: Condition for $OPTION_CASE option is failed. See --help for details.\" >&2; return 1; }
            "
          ;;
        esac
      done

    done
    echo "
      __parse_arguments_sub() {
      # Global array to hold command line arguments
      ARGUMENTS=( )

      while [ \$# -gt 0 ]
      do
        case \"\$1\" in
        $OPTIONS_PARSER
        -h|--help)
          help 1
          exit 0
        ;;
        --man)
          help 2
          exit 0
        ;;
        --debug)
          log_enable_debug_mode
          shift
        ;;
        --)
          shift; break; # Do not parse rest of the command line arguments
        ;;
        -*)
          echo \"ERROR: Unknown option: \\\"\$1\\\".\" >&2
          help 1
          return 1
        ;;
        *)
          break; # Do not parse rest of the command line
        ;;
        esac
      done
      [ \$# -eq 0 ] || ARGUMENTS=( \"\$@\" ) # Store rest of the command line arguments into the ARGUMENTS array
      $OPTION_POSTCONDITIONS
      }
    "
  }

  # Helper function, to put at end of source, before documentation part.
  __END__() {
    exit $?
  }

}

