#!/bin/bash
#
# Copyright (c) 2009-2011 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
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



[ "${__ini_parser__DEFINED:-}" == "yes" ] || {
  __ini_parser__DEFINED="yes"

  . import.sh log strings

  ini_parser_summary() {
    echo "Generate shell function from INI file."
  }

  ini_parser_usage() {
    echo '
    generate_function_from_ini_file FUNC_NAME INI_FILE

        Generate shell function from INI file. Generated shell function
will be defined as:

    FUNC_NAME VAR [SECTION [KEY]]

        Assign value of key KEY in section SECTION of ini file to
variable VAR. Section name and key can be omitted, then list of sections
or keys in section will be assigned to variable.

    Special values:

        __INDEX__ - return list of sections or keys. List items are
separated by new line character. Use split_by_delimiter function from
strings module to convert string to array.

        __TOP__ - section name for items which are found prior to any
other section.

    WARNING: Do not use variables with prefix "__" in their names - they
are used internally, so functions are unable to export some of them.

'
}


  generate_function_from_ini_file() {
    local __FUNC_NAME="$1"
    local __FILE="$2"

    [ -f "$__FILE" ] || {
      error "Cannot find file \"$__FILE\"."
      return 1
    }

    local __LF=$'\n'

    local __FUNCTION="
$__FUNC_NAME() {
local __VAR=\"\$1\"
local __SECTION=\"\${2:-__INDEX__}\"
local __KEY=\"\${3:-__INDEX__}\"
case \"\$__SECTION\" in
  __TOP__)
    case \"\$__KEY\" in
"
    local __LINE __KEYS=( ) __SECTIONS=( )
    while read -d $'\n' -r __LINE
    do
      # Skip comments and empty lines
      [[ ! "$__LINE" =~ ^\s*$ ]] || continue
      [[ ! "$__LINE" =~ ^\s*\# ]] || continue
      [[ ! "$__LINE" =~ ^\s*\; ]] || continue

      if [[ "$__LINE" =~ ^\s*\[ ]]
      then
        local __SECTION="${__LINE#*[}" # Trim everything before first [
        __SECTION="${__SECTION%%]*}" # Trim everything after last ]

        quote_to_bash_format __SECTION "$__SECTION"

        local __OLD_IFS="$IFS"
        local IFS=''
        __FUNCTION="$__FUNCTION      __INDEX__) __VALUE=${__KEYS[*]:-} ;;$__LF"
        IFS="$__OLD_IFS"

        __FUNCTION="$__FUNCTION      *) return 1 ;;
    esac
  ;;
  $__SECTION)
    case \"\$__KEY\" in
"

        # Reset list of keys in this section
        __KEYS=( )

        # Append section name to list of sections.
        # Append newline to separate sections when will
        # inline them with ${SECTIONS[*]} and empty IFS.
        __SECTIONS[${#__SECTIONS[@]}]="$__SECTION\$'\\n'"
      elif [[ "$__LINE" == *=* ]]
      then
        local __KEY
        trim_spaces __KEY "${__LINE%%=*}"
        quote_to_bash_format __KEY "$__KEY"

        local __VALUE
        trim_spaces __VALUE "${__LINE#*=}"

        if [[ "$__VALUE" == '"'* ]] 
        then
          # Double-quoted value: strip quotes and unescape value
          __VALUE="${__VALUE#\"}" # Strip first double quote
          __VALUE="${__VALUE%\"*}" # Strip everything after last double quote
          unescape_backslash_sequences __VALUE "$__VALUE"
        elif [[ "$__VALUE" == "'"* ]] 
        then
          # Single-quoted value: strip quotes and unescape value (only '' is supported)
          __VALUE="${__VALUE#\'}" # Strip first single quote
          __VALUE="${__VALUE%\'*}" # Strip everything after last single quote
          local __Q="'"
          __VALUE="${__VALUE//$__Q$__Q/$__Q}" # Replace two single quotes with one
        else
          # Unquoted value: strip embeded comments
          __VALUE="${__VALUE% #*}" # Strip embeded #-style comments
          __VALUE="${__VALUE% ;*}" # Strip embeded ;-style comments
        fi

        quote_to_bash_format __VALUE "$__VALUE"

        __FUNCTION="$__FUNCTION      $__KEY) __VALUE=$__VALUE ;;$__LF"

        # Append key name to list of section keys.
        # Append  newline to separate keys when will
        # inline them with ${KEYS[*]} and empty IFS.
        __KEYS[${#__KEYS[@]}]="$__KEY\$'\\n'"
      else
        warn "Incorrect line in ini-file \"$__FILE\": $__LINE."
      fi

    done < "$__FILE"

    local __OLD_IFS="$IFS"
    local IFS=''
    __FUNCTION="$__FUNCTION      __INDEX__) __VALUE=${__KEYS[*]:-} ;;
      *) return 1 ;;
    esac
  ;;
  __INDEX__) __VALUE=${__SECTIONS[*]:-} ;;
  *) return 1 ;;
esac
export -n \"\$__VAR\"=\"\$__VALUE\"
}
"
    IFS="$__OLD_IFS"

    eval "$__FUNCTION"
  }

}
