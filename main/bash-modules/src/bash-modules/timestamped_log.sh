##!/bin/bash
#
# Copyright (c) 2013 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
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

# Import log module and then override some functions
. import.sh log


#>>> timestamped_log - print timestamped logs. Drop-in replacement for log module.
#>>> Warning: call to logging function will invokes `date` command to generate timestamp.

#>
#> Variables:

#>
#> * __timestamped_log_format - format of timestamp. Default value: "%F %T" (full date and time).
__timestamped_log_format="%F %T"


#>>
#>> Functions:

#>>
#>> * timestamped_log::set_format FORMAT  Set format for date. Default value is "%F %T".
timestamped_log::set_format() {
  __timestamped_log_format="$1"
}

#>
#> * timestamped_log::wrap BEFORE AFTER FUNCTION_NAME[...]
#>    Create wrapper for a function(s). Execute given commands before and after
#>    each function. Original function is available as timestamped_log::orig_FUNCTION_NAME.
timestamped_log::wrap() {
  local BEFORE="$1"
  local AFTER="$2"
  shift 2
  local FUNCTION_NAME
  for FUNCTION_NAME in "$@"
  do
    eval "
# Rename original function
function timestamped_log::orig_$(declare -fp $FUNCTION_NAME)

# Redefine function
function $FUNCTION_NAME() {
  $BEFORE

  # Call original function
  timestamped_log::orig_$FUNCTION_NAME \"\$@\"

  $AFTER
}
"
  done
}

#>>
#>> Wrapped functions:
#>> log::info, info, debug - print timestamp to stdout and then log message.
timestamped_log::wrap \
  'echo -n "$(date "+$__timestamped_log_format")"' \
  '' \
  log::info \
  info \
  debug

#>> log::error, log::warn, error, warn - print timestamp to stderr and then log message.
timestamped_log::wrap \
  'echo -n "$(date "+$__timestamped_log_format")" >&2' \
  '' \
  log::error \
  log::warn \
  error \
  warn \
  panic

#>>
#>> See log module usage for details about log functions. Original functions
#>> are available with prefix "timestamped_log::orig_".
