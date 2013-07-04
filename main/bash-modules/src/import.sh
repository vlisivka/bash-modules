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


[ "${__IMPORT__DEFINED:-}" == "yes" ] || {
  __IMPORT__DEFINED="yes"


  __IMPORT_MINIMUM_VERSION=3
  [ ! "$BASH_VERSION" \< "$__IMPORT_MINIMUM_VERSION" ] || {
    echo "This script works only with Bash, version $__IMPORT_MINIMUM_VERSION or greater." >&2
    echo "Upgrade is strongly recommended." >&2
    exit 80
  }


  __IMPORT__BASE_PATH=( "${__IMPORT__BASE_PATH[@]:+${__IMPORT__BASE_PATH[@]}}" "/usr/share/bash-modules" )

  # Source default setting from system wide configuration file and from user home configuration file
  [ ! -f /etc/bash-modules/config.sh ] || source /etc/bash-modules/config.sh
  # Source user configuration file when run as non-root only
  [ $UID -ne 0 -o ! -f ~/.bash-modules/config.sh ] || source ~/.bash-modules/config.sh

  # Import single module only.
  # Argument: module name (without absolute path and without .sh extension)
  import_module() {
    local __MODULE="$1"

    local __PATH
    for __PATH in "${__IMPORT__BASE_PATH[@]}"
    do
      [ -f "$__PATH/$__MODULE.sh" ] || continue

      source "$__PATH/$__MODULE.sh" || return 1
      return 0
    done

    echo "[import.sh:import_module] ERROR: Cannot locate module: \"$__MODULE\". Search path: ${__IMPORT__BASE_PATH[*]}" >&2
    return 2
  }

  # Import list of modules at once and return error code
  # Arguments: module names (without absolute path and without .sh extension)
  import_modules() {
    local __MODULE __ERROR_CODE=0
    for __MODULE in "$@"
    do
      import_module "$__MODULE" || __ERROR_CODE=$?
    done
    return $__ERROR_CODE
  }

  # Print various information about module(s)
  __import_list_modules() {
    local __FUNC="$1" ; shift
    declare -a __MODULES
    local __PATH __MODULE __MODULES

    if [ $# -eq 0 ]
    then
      # If no arguments are given,
      # then add all modules in all directories
      for __PATH in "${__IMPORT__BASE_PATH[@]}"
      do
        for __MODULE in "$__PATH"/*.sh
        do
          [ -f "$__MODULE" ] || continue
          __MODULES[${#__MODULES[@]}]="$__MODULE"
        done
      done
    else
      # Argument can be directory or module path or module name.
      local __ARG
      for __ARG in "$@"
      do
        if [ -d "$__ARG" ]
        then
          # Directory. Add all modules in directory
          for __MODULE in "$__ARG"/*.sh
          do
            [ -f "$__MODULE" ] || continue
            __MODULES[${#__MODULES[@]}]="$__MODULE"
          done
        elif [ -f "$__ARG" ]
        then
          # Direct path. Add single module.
          __MODULES[${#__MODULES[@]}]="$__ARG"
        else
          # Module name. Find single module in path.
          for __PATH in "${__IMPORT__BASE_PATH[@]}"
          do
            [ -f "$__PATH/$__ARG.sh" ] || continue
            __MODULES[${#__MODULES[@]}]="$__PATH/$__ARG.sh"
          done
        fi
      done
    fi

    local __MODULE_PATH
    for __MODULE_PATH in "${__MODULES[@]}"
    do
        [ -f "$__MODULE_PATH" ] || continue
        __MODULE="${__MODULE_PATH##*/}" # Strip directory
        __MODULE="${__MODULE%.sh}" # Strip extension
        if [ "$__FUNC" == "" ]
        then
          # just print module name
          echo "$__MODULE"
        else
          # Call requested function on each module
          echo -n "MODULE $__MODULE: "
          (
            # Import module
            source "$__MODULE_PATH" --${__FUNC} || exit $? # Exit from subshell
            "${__MODULE}_${__FUNC}"
            echo
          ) || {
            echo "Module \"$__MODULE\" ($__MODULE_PATH) returned non-zero exit code: $?."
          }
        fi
    done
  }

  import_summary() {
    echo "source import.sh MODULE[...] | import.sh --list | import.sh --help MODULE[...]   import modules"
  }

  import_usage() {
    echo "

Usage:

  source import.sh MODULE[...]

  import.sh --list|-l

  import.sh --summary|-s [MODULE...]

  import.sh --usage|-u MODULE[...]

Description:

Imports given module(s) into current shell.

Use \"import.sh --list\" to print list of available modules.

Use \"import.sh --summary\" to print list of available modules with short
description.



Use \"import.sh --usage MODULE[...]\" to print longer description of
given module(s).

You can set __IMPORT__BASE_PATH array with list of your own directories
with modules, which will be prepended to search path.

"
  }

}

# If this is top level code and program name is .../import.sh
if [ "${FUNCNAME:+$FUNCNAME}" == "" -a "${0##*/}" == "import.sh" ]
then
  # import.sh called as standalone program
  if  [ "$#" -eq 0 ]
  then
    import_usage
  else
    case "$1" in
      --list|-l)
        shift 1
        __import_list_modules "" "${@:+$@}"
      ;;
      --summary|-s)
        shift 1
        __import_list_modules summary "${@:+$@}"
      ;;
      --usage|-u)
        shift 1
        __import_list_modules usage "${@:+$@}"
      ;;
      *)
        import_usage
      ;;
    esac
  fi

else
  # Import given modules when parameters are supplied.
  [ "$#" -eq 0 ] || import_modules "$@"
fi
