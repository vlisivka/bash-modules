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

[ "${__settings__DEFINED:-}" == "yes" ] || {
  __settings__DEFINED="yes"

  if [ "${1:-}" == '--usage' -o "${1:-}" == '--summary' ]
  then
    settings_summary() {
      echo "Import settings from files and directories."
    }

    settings_usage() {
      echo '
  import_settings [-e|--ext EXTENSION] FILE|DIR...

  Import settings (source them into current program) when file or
  directory exists. For directories, all files with given extension ("sh"
  by default) are imported, without recursion.
'
    }
  else

  import_settings() {
    local EXTENSION="sh"
    if [ "$1" == "-e" -o "$1" == "--ext" ]
    then
      EXTENSION="$2"
      shift 2
    fi

    local FILE_OR_DIR
    for FILE_OR_DIR in "${@:+$@}"
    do
      if [ -f "$FILE_OR_DIR" -a -r "$FILE_OR_DIR" -a -s "$FILE_OR_DIR" ]
      then
        source "$FILE_OR_DIR" || {
          echo "ERROR: Cannot import settings from \"$FILE_OR_DIR\" file: non-zero exit code returned: $?." >&2
          return 1
        }
      elif [ -d "$FILE_OR_DIR" -a -x "$FILE_OR_DIR" ]
      then
        local FILE
        for FILE in "$FILE_OR_DIR"/*."$EXTENSION"
        do
          if [ -f "$FILE" -a -r "$FILE" -a -s "$FILE" ]
          then
            source "$FILE" || {
              echo "ERROR: Cannot import settings from \"$FILE\" file: non-zero exit code returned: $?." >&2
              return 1
            }
          fi
        done
      fi
    done
    return 0
  }
  fi
}
