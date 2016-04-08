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
  parse_arguments [-O|--LONG_OPTION)VARIABLE;FLAGS]... -- [ARGUMENTS]...

Where 
  -O		short option name
  --LONG_OPTION	long option name
  VARIABLE	shell variable name to assign value
  FLAGS:	one of:
    B			boolean (no value);
    I			incremental (no value) - increment variable by one;
    S			string value;
    A			array of string values (multiple options);
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

    local OPTION_DESCRIPTION OPTION_CASE OPTION_FLAGS OPTION_PARSER=""

    while [ $# -gt 0 ]
    do
      # Parse option description
      OPTION_DESCRIPTION="$1" ; shift
      OPTION_CASE="${OPTION_DESCRIPTION%%)*}"
      OPTION_VARIABLE="${OPTION_DESCRIPTION#*)}"
      OPTION_FLAGS="${OPTION_VARIABLE#*;}"
      OPTION_VARIABLE="${OPTION_VARIABLE%%;*}"

      # Generate option parser for boolean variable
      case "$OPTION_FLAGS" in
       *B*)
          OPTION_PARSER="$OPTION_PARSER
          $OPTION_CASE)
            $OPTION_VARIABLE=\"yes\"
            shift 1
          ;;
          "
        ;;
       *I*)
          OPTION_PARSER="$OPTION_PARSER
          $OPTION_CASE)
            let $OPTION_VARIABLE++ || :
            shift 1
          ;;
          "
        ;;
        *S*)
          OPTION_PARSER="$OPTION_PARSER
          $OPTION_CASE)
            $OPTION_VARIABLE=\"\${2:?Value is required for \\\"$OPTION_CASE\\\".}\"
            shift 2
          ;;
          $OPTION_CASE=*)
            $OPTION_VARIABLE=\"\${1#*=}\"
            shift 1
          ;;
          "
        ;;
        *A*)
          OPTION_PARSER="$OPTION_PARSER
          $OPTION_CASE)
            ${OPTION_VARIABLE}[\${#${OPTION_VARIABLE}[@]}]=\"\${2:?Value is required for \\\"$OPTION_CASE\\\".}\"
            shift 2
          ;;
          $OPTION_CASE=*)
            ${OPTION_VARIABLE}[\${#${OPTION_VARIABLE}[@]}]=\"\${1#*=}\"
            shift 1
          ;;
          "
        ;;
      esac

    done
    echo "
      __parse_arguments_sub() {
      # Global array to hold command line arguments
      ARGUMENTS=( )

      while [ \$# -gt 0 ]
      do
        case \"\$1\" in
        $OPTION_PARSER
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
          echo \"Unknown option: \\\"\$1\\\".\" >&2
          help 1
          return 1
        ;;
        *)
          break; # Do not parse rest of the command line
        ;;
        esac
      done
      [ \$# -eq 0 ] || ARGUMENTS=( \"\$@\" ) # Store rest of the command line arguments into the ARGUMENTS array
      }
    "
  }

}

# Helper function, to put at end of source, before documentation part.
__END__() {
  exit $?
}

[ $# -eq 0 ] || parse_arguments "$@"
