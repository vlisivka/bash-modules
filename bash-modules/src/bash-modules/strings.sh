##!/bin/bash
# Copyright (c) 2009-2021 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
# License: LGPL2+

#>>> strings - various functions to manipulate strings.

#>>
#>> Functions:

#>>
#>> * strings::trim_spaces VARIABLE VALUE
#>>    Trim white space characters around value and assign result to variable.
strings::trim_spaces() {
  local -n __strings__VAR="$1"
  local __strings__VALUE="${2:-}"

  # remove leading whitespace characters
  __strings__VALUE="${__strings__VALUE#"${__strings__VALUE%%[![:space:]]*}"}"
  # remove trailing whitespace characters
  __strings__VALUE="${__strings__VALUE%"${__strings__VALUE##*[![:space:]]}"}"

  __strings__VAR="$__strings__VALUE"
}

#>>
#>> * strings::trim_spaces_at_left VARIABLE VALUE
#>>    Trim white space characters at begining of value and assign result to variable.
strings::trim_spaces_at_left() {
  local -n __strings__VAR="$1"
  local __strings__VALUE="${2:-}"

  # remove leading whitespace characters
  __strings__VALUE="${__strings__VALUE#"${__strings__VALUE%%[![:space:]]*}"}" #"

  __strings__VAR="$__strings__VALUE"
}

#>>
#>> * strings::trim_spaces_at_right VARIABLE VALUE
#>>    Trim white space characters at end of value and assign result to variable.
strings::trim_spaces_at_right() {
  local -n __strings__VAR="$1"
  local __strings__VALUE="${2:-}"

  # remove trailing whitespace characters
  __strings__VALUE="${__strings__VALUE%"${__strings__VALUE##*[![:space:]]}"}" #"

  __strings__VAR="$__strings__VALUE"
}

#>>
#>> * strings::split_by_delimiter ARRAY DELIMITERS VALUE
#>>    Split value by delimiter(s) and assign result to array. Use
#>>    backslash to escape delimiter in string.
#>>    NOTE: Temporary file will be used.
strings::split_by_delimiter() {
  local __strings__VAR="$1"
  local IFS="$2"
  local __strings__VALUE="${3:-}"

  # We can use "for" loop and strip elements item by item, but we are
  # unable to assign result to named array, so we must use "read -a" and "<<<" here.

  # TODO: use regexp and loop instead.
  read -a "$__strings__VAR" <<<"${__strings__VALUE:-}"
}

#>>
#>> * strings::basename VARIABLE FILE [EXT]
#>>    Strip path and optional extension from  full file name and store
#>>    file name in variable.
strings::basename() {
  local -n __strings__VAR="$1"
  local __strings__FILE="${2:-}"
  local __strings__EXT="${3:-}"

  __strings__FILE="${__strings__FILE##*/}" # Strip everything before last "/"
  __strings__FILE="${__strings__FILE%$__strings__EXT}" # Strip .sh extension

  __strings__VAR="$__strings__FILE"
}

#>>
#>> * strings::dirname VARIABLE FILE
#>>    Strip file name from path and store directory name in variable.
strings::dirname() {
  local -n __strings__VAR="$1"
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

  __strings__VAR="$__strings__DIR"
}

#>>
#>> * strings::random_string VARIABLE LENGTH
#>>    Generate random string of given length using [a-zA-Z0-9]
#>>    characters and store it into variable.
strings::random_string() {
  local -n __strings__VAR="$1"
  local __strings__LENGTH="${2:-8}"

  local __strings__ALPHABET="0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"
  local __strings__ALPHABET_LENGTH=${#__strings__ALPHABET}

  local __strings__I __strings__RESULT=""
  for((__strings__I=0; __strings__I<__strings__LENGTH; __strings__I++))
  do
    __strings__RESULT="$__strings__RESULT${__strings__ALPHABET:RANDOM%__strings__ALPHABET_LENGTH:1}"
  done

  __strings__VAR="$__strings__RESULT"
}

#>>
#>> * strings::chr VARIABLE CHAR_CODE
#>>    Convert decimal character code to its ASCII representation.
strings::chr() {
  local __strings__VAR="$1"
  local __strings__CODE="$2"

  local __strings__OCTAL_CODE
  printf -v __strings__OCTAL_CODE '%03o' "$__strings__CODE"
  printf -v "$__strings__VAR" "\\$__strings__OCTAL_CODE"
}

#>>
#>> * strings::ord VARIABLE CHAR
#>>    converts ASCII character to its decimal value.
strings::ord() {
  local __strings__VAR="$1"
  local __strings__CHAR="$2"

  printf -v "$__strings__VAR" '%d' "'$__strings__CHAR"
}

# Alternative version of function:
#  strings::quote_to_bash_format() {
#    local -n __strings__VAR="$1"
#    local __strings__STRING="$2"
#
#    local __strings__QUOTE="'\\''"
#    local __strings__QUOTE="'\"'\"'"
#    __strings__VAR="'${__strings__STRING//\'/$__strings__QUOTE}'"
#  }

#>>
#>> * strings::quote_to_bash_format VARIABLE STRING
#>>    Quote the argument in a way that can be reused as shell input.
strings::quote_to_bash_format() {
  local __strings__VAR="$1"
  local __strings__STRING="$2"

  printf -v "$__strings__VAR" "%q" "$__strings__STRING"
}

#>>
#>> * strings::unescape_backslash_sequences VARIABLE STRING
#>>    Expand backslash escape sequences.
strings::unescape_backslash_sequences() {
  local __strings__VAR="$1"
  local __strings__STRING="$2"

  printf -v "$__strings__VAR" "%b" "$__strings__STRING"
}

#>>
#>> * strings::to_identifier VARIABLE STRING
#>>    Replace all non-alphanumeric characters in string by underscore character.
strings::to_identifier() {
  local -n __strings__VAR="$1"
  local __strings__STRING="$2"

  # We need a-zA-Z letters only.
  # 'z' can be in middle of alphabet on some locales.
  __strings__VAR="${__strings__STRING//[^abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]/_}"
}

#>>
#>> * strings::find_string_with_prefix VAR PREFIX [STRINGS...]
#>>    Find first string with given prefix and assign it to VAR.
strings::find_string_with_prefix() {
  local -n __strings__VAR="$1"
  local __strings__PREFIX="$2"
  shift 2

  local __strings__I
  for __strings__I in "$@"
  do
    [[ "${__strings__I}" != "${__strings__PREFIX}"* ]] || {
      __strings__VAR="${__strings__I}"
      return 0
    }
  done
  return 1
}
