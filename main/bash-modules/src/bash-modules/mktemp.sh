##!/bin/bash
#
# Copyright (c) 2011-2013 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
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



[ "${__mktemp__DEFINED:-}" == "yes" ] || {
  __mktemp__DEFINED="yes"

                                                                                  
  mktemp_summary() {
    echo "mktemp implementation in pure bash for portability"
  }
  
  mktemp_usage() {
    echo '
SYNOPSIS
       mktemp [OPTION]... [TEMPLATE]

DESCRIPTION

       Create a temporary file or directory, safely, and print its name. 
       TEMPLATE must contain at least 3 consecutive "X"s in last
       component.  If TEMPLATEis not specified, use tmp.XXXXXXXXXX, and
       --tmpdir is implied.

       -d | --directory

              create a directory, not a file

       -u | --dry-run

              do not create anything; merely print a name (unsafe)

       -q | --quiet

              suppress diagnostics about file/dir-creation failure

       --suffix=SUFF

              append SUFF to TEMPLATE.  SUFF must not contain slash. 
              This option is implied if TEMPLATE does not end in X.

       -t | --tmpdir[=DIR]

              interpret TEMPLATE relative to DIR.  If DIR is not
              specified, use $TMPDIR if set, else /tmp.  With this
              option, TEMPLATE must not be an absolute name.  TEMPLATE
              may contain slashes, but mktemp creates only the final
              component.

'
  }

  mktemp() {
    ( # In subshell
      set -ue

      CREATE_DIR="no"
      DRY_RUN="no"
      QUIET="no"
      USE_TMP_DIR="no"
      TEMPORARY_DIR=""

      main() {
        local TEMPLATE="${1:-tmp.XXXXXXXXXX}"
        [ -n "${1:-}" ] || USE_TMP_DIR="yes"

        if [ -n "$TEMPORARY_DIR" ]
        then
          # --tmpdir option is used
          USE_TMP_DIR="yes"
        else
          # Initialize with default value for -t option
          TEMPORARY_DIR="${TMPDIR:-/tmp}"
        fi

        # When use temporary dir, use only last path element of template
        [ "$USE_TMP_DIR" == "no" ] || strings_basename TEMPLATE "$TEMPLATE"

        # Create private owned files and directories (0700)
        umask 077
        set -o noclobber

        local I
        for((I=0; I<100; I++))
        do
          local FILE_NAME="" RANDOM_STRING
          case "$TEMPLATE" in
            *XXXXXXXXXXXXXXXXXXXXXXXXX*) random_string RANDOM_STRING 25 ; FILE_NAME=${TEMPLATE//XXXXXXXXXXXXXXXXXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXXXXXXXXXXXXXXXXX*)  random_string RANDOM_STRING 24 ; FILE_NAME=${TEMPLATE//XXXXXXXXXXXXXXXXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXXXXXXXXXXXXXXXX*)   random_string RANDOM_STRING 23 ; FILE_NAME=${TEMPLATE//XXXXXXXXXXXXXXXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXXXXXXXXXXXXXXX*)    random_string RANDOM_STRING 22 ; FILE_NAME=${TEMPLATE//XXXXXXXXXXXXXXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXXXXXXXXXXXXXX*)     random_string RANDOM_STRING 21 ; FILE_NAME=${TEMPLATE//XXXXXXXXXXXXXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXXXXXXXXXXXXX*)      random_string RANDOM_STRING 20 ; FILE_NAME=${TEMPLATE//XXXXXXXXXXXXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXXXXXXXXXXXX*)       random_string RANDOM_STRING 19 ; FILE_NAME=${TEMPLATE//XXXXXXXXXXXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXXXXXXXXXXX*)        random_string RANDOM_STRING 18 ; FILE_NAME=${TEMPLATE//XXXXXXXXXXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXXXXXXXXXX*)         random_string RANDOM_STRING 17 ; FILE_NAME=${TEMPLATE//XXXXXXXXXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXXXXXXXXX*)          random_string RANDOM_STRING 16 ; FILE_NAME=${TEMPLATE//XXXXXXXXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXXXXXXXX*)           random_string RANDOM_STRING 15 ; FILE_NAME=${TEMPLATE//XXXXXXXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXXXXXXX*)            random_string RANDOM_STRING 14 ; FILE_NAME=${TEMPLATE//XXXXXXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXXXXXX*)             random_string RANDOM_STRING 13 ; FILE_NAME=${TEMPLATE//XXXXXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXXXXX*)              random_string RANDOM_STRING 12 ; FILE_NAME=${TEMPLATE//XXXXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXXXX*)               random_string RANDOM_STRING 11 ; FILE_NAME=${TEMPLATE//XXXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXXX*)                random_string RANDOM_STRING 10 ; FILE_NAME=${TEMPLATE//XXXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXXX*)                 random_string RANDOM_STRING  9 ; FILE_NAME=${TEMPLATE//XXXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXXX*)                  random_string RANDOM_STRING  8 ; FILE_NAME=${TEMPLATE//XXXXXXXX/$RANDOM_STRING} ;;
            *XXXXXXX*)                   random_string RANDOM_STRING  7 ; FILE_NAME=${TEMPLATE//XXXXXXX/$RANDOM_STRING} ;;
            *XXXXXX*)                    random_string RANDOM_STRING  6 ; FILE_NAME=${TEMPLATE//XXXXXX/$RANDOM_STRING} ;;
            *XXXXX*)                     random_string RANDOM_STRING  5 ; FILE_NAME=${TEMPLATE//XXXXX/$RANDOM_STRING} ;;
            *XXXX*)                      random_string RANDOM_STRING  4 ; FILE_NAME=${TEMPLATE//XXXX/$RANDOM_STRING} ;;
            *XXX*)                       random_string RANDOM_STRING  3 ; FILE_NAME=${TEMPLATE//XXX/$RANDOM_STRING} ;;
            *)
              error "Bad template string. TEMPLATE must contain at least 3 consecutive \"X\"s."
              exit 1
            ;;
          esac

          [ "$USE_TMP_DIR" == "no" ] || {
            FILE_NAME="$TEMPORARY_DIR/$FILE_NAME"
          }

          [ ! -e "$FILE_NAME" ] || continue

          [ "$DRY_RUN" == "no" ] || {
            echo "$FILE_NAME"
            return 0
          }

          if [ "$CREATE_DIR" == "no" ]
          then
            # Try to create file (noclobber option will not allow to
            # overwrite file).
            : >"$FILE_NAME" 2>/dev/null || continue
          else

            # Try to create director (mkdir will fail if directory
            # is already exists).
            mkdir "$FILE_NAME" 2>/dev/null || continue
          fi

          echo "$FILE_NAME"
          return 0

        done

        [ "$QUIET" == "no" ] || error "Cannot create temporary file after 100 attempts."
        return 1
      }

      . import.sh log arguments strings
      parse_arguments \
          "-d|--directory)CREATE_DIR;B" \
          "-u|--dry-run)DRY_RUN;B" \
          "-q|--quiet)QUIET;B" \
          "-t|--tmpdir)USE_TMP_DIR;B" \
          "--tmpdir)TEMPORARY_DIR;S" \
          -- "${@:+$@}" || {
        error "Cannot parse mktemp command line arguments."
        mktemp_usage
        exit 1
      }

      [ "${#ARGUMENTS[@]}" -le 1 ] || {
        error "Incorrect number of mktemp command line arguments. Put options before template."
        mktemp_usage
        exit 1
      }

      main "${ARGUMENTS[@]:+${ARGUMENTS[@]}}" || exit 1
    )
  }


}
