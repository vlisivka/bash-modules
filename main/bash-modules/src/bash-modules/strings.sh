##!/bin/bash
#
# Copyright (c) 20011-2013 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
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



[ "${__strings__DEFINED:-}" == "yes" ] || {
  __strings__DEFINED="yes"

  strings_summary() {
    echo "Various functions related to string manipulations"
  }

  strings_usage() {
    echo '

    trim_spaces VAR VALUE

        Trim white space characters around VALUE and assign result to
        VAR.

    trim_spaces_at_left  VAR VALUE

        Trim white space characters at begining of VALUE and assign
        result to VAR.

    trim_spaces_at_right  VAR VALUE

        Trim white space characters at end of VALUE and assign result to
        VAR.

    split_by_delimiter ARRAY DELIMITERS VALUE

        Split VALUE by DELIMITERS and assign result to ARRAY. Use
        backslash to escape delimiter in string. Temporary file will be
        used.

    strings_basename VAR FILE [EXT]

        Strip path and optional extension from  full file name and store
        file name in VAR variable.

    strings_dirnname VAR FILE

        Strip file name from path and store directory name in VAR
        variable.

    random_string VAR LENGTH

        Generate random string of given length using [a-zA-Z0-9]
        characters and store it into VAR variable.

    chr VAR CHAR_CODE

        Convert decimal value to its ASCII character representation.

    ord VAR CHAR

        converts ASCII character to its decimal value.

    quote_to_bash_format VAR STRING

        Quote the argument in a way that can be reused as shell input.

    unescape_backslash_sequences VAR STRING

        Expand backslash escape sequences.

    to_identifier VAR STRING

        Replace all non-alphanumeric characters in string by \"_\"
        character.

    WARNING: Do not use variables with prefix "__" in their names - they
are used internally, so functions are unable to export some of them.

'
  }

  trim_spaces() {
    local __strings__VAR="$1"
    local __strings__VALUE="${2:-}"

    # remove leading whitespace characters
    __strings__VALUE="${__strings__VALUE#"${__strings__VALUE%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    __strings__VALUE="${__strings__VALUE%"${__strings__VALUE##*[![:space:]]}"}"

    export -n "$__strings__VAR"="$__strings__VALUE"
  }

  trim_spaces_at_left() {
    local __strings__VAR="$1"
    local __strings__VALUE="${2:-}"

    # remove leading whitespace characters
    __strings__VALUE="${__strings__VALUE#"${__strings__VALUE%%[![:space:]]*}"}" #"

    export -n "$__strings__VAR"="$__strings__VALUE"
  }

  trim_spaces_at_right() {
    local __strings__VAR="$1"
    local __strings__VALUE="${2:-}"

    # remove trailing whitespace characters
    __strings__VALUE="${__strings__VALUE%"${__strings__VALUE##*[![:space:]]}"}" #"

    export -n "$__strings__VAR"="$__strings__VALUE"
  }

  split_by_delimiter() {
    local __strings__VAR="$1"
    local IFS="$2"
    local __strings__VALUE="${3:-}"

    # We can use "for" loop and strip elements item by item, but we are
    # unable to assign result to named array using "export -n", so we
    # must use "read -a" and "<<<" here.

    # Note: "<<<" operator will create temporary file.
    read -a "$__strings__VAR" <<<"${__strings__VALUE:-}"
  }

  strings_basename() {
    local __strings__VAR="$1"
    local __strings__FILE="${2:-}"
    local __strings__EXT="${3:-}"

    __strings__FILE="${__strings__FILE##*/}" # Strip everything before last "/"
    __strings__FILE="${__strings__FILE%$__strings__EXT}" # Strip .sh extension

    export -n "$__strings__VAR"="$__strings__FILE"
  }

  strings_dirname() {
    local __strings__VAR="$1"
    local __strings__FILE="${2:-}"

    local __strings__DIR=""
    case "$__strings__FILE" in
      */*)
        __strings__DIR="${__strings__FILE%/*}" # Strip everything after last "/'
      ;;
      *)
        __strings__DIR="."
      ;;
    esac

    export -n "$__strings__VAR"="$__strings__DIR"
  }

  random_string() {
    local __strings__VAR="$1"
    local __strings__LENGTH="${2:-8}"

    local __strings__ALPHABET="0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"
    local __strings__ALPHABET_LENGTH=${#__strings__ALPHABET}

    local __strings__I __strings__RESULT=""
    for((__strings__I=0; __strings__I<__strings__LENGTH; __strings__I++))
    do
      __strings__RESULT="$__strings__RESULT${__strings__ALPHABET:RANDOM%__strings__ALPHABET_LENGTH:1}"
    done
    export -n "$__strings__VAR"="$__strings__RESULT"
  }

  chr() {
    local __strings__VAR="$1"
    local __strings__CODE="$2"

    local __strings__OCTAL_CODE
    printf -v __strings__OCTAL_CODE '%03o' "$__strings__CODE"
    printf -v "$__strings__VAR" "\\$__strings__OCTAL_CODE"
  }

  ord() {
    local __strings__VAR="$1"
    local __strings__CHAR="$2"

    printf -v "$__strings__VAR" '%d' "'$__strings__CHAR"
  }

# Alternative version of function
#  quote_to_bash_format() {
#    local __strings__VAR="$1"
#    local __strings__STRING="$2"
#
#    local __strings__QUOTE="'\\''"
#    local __strings__QUOTE="'\"'\"'"
#    export -n "$__strings__VAR"="'${__strings__STRING//\'/$__strings__QUOTE}'"
#  }

  quote_to_bash_format() {
    local __strings__VAR="$1"
    local __strings__STRING="$2"

    printf -v "$__strings__VAR" "%q" "$__strings__STRING"
  }

  unescape_backslash_sequences() {
    local __strings__VAR="$1"
    local __strings__STRING="$2"

    printf -v "$__strings__VAR" "%b" "$__strings__STRING"
  }

  to_identifier() {
    local __strings__VAR="$1"
    local __strings__STRING="$2"

    # We need a-zA-Z letters only.
    # z can be in middle of alphabet on some locales.
    export -n "$__strings__VAR"="${__strings__STRING//[^abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]/_}"
  }
  
  find_string_with_prefix() {
    local __strings__VAR="$1"
    local __strings__PREFIX="$2"
    shift 2
    
    local __strings__I
    for __strings__I in "$@"
    do
      [[ "${__strings__I}" != "${__strings__PREFIX}"* ]] || {
        export -n "${__strings__VAR}"="${__strings__I}"
        return 0
      }
    done
    return 1
  }

}
