##!/bin/bash
# Copyright (c) 2009-2021 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
# License: GPL2+

#>>> settigngs -import settings from files and directories (AKA .d pattern)."

#>> * settings::import [-e|--ext EXTENSION] FILE|DIR...
#>>
#>> Import settings (source them into current program as shell script) when
#>> file or directory exists. For directories, all files with given extension
#>> (".sh" by default) are imported, without recursion.
settings::import() {
  local __settings_EXTENSION="sh"
  if [ "$1" == "-e" -o "$1" == "--ext" ]
  then
    __settings_EXTENSION="$2"
    shift 2
  fi

  local __settings_ENTRY
  for __settings_ENTRY in "${@:+$@}"
  do
    if [ -f "$__settings_ENTRY" -a -r "$__settings_ENTRY" -a -s "$__settings_ENTRY" ]
    then
      source "$__settings_ENTRY" || {
        echo "[settings] ERROR: Cannot import settings from \"$__settings_ENTRY\" file: non-zero exit code returned: $?." >&2
        return 1
      }
    elif [ -d "$__settings_ENTRY" -a -x "$__settings_ENTRY" ]
    then
      local __settings_FILE
      for __settings_FILE in "$__settings_ENTRY"/*."$__settings_EXTENSION"
      do
        if [ -f "$__settings_FILE" -a -r "$__settings_FILE" -a -s "$__settings_FILE" ]
        then
          source "$__settings_FILE" || {
            echo "[settings] ERROR: Cannot import settings from \"$__settings_FILE\" file: non-zero exit code returned: $?." >&2
            return 1
          }
        fi
      done
    fi
  done
  return 0
}
