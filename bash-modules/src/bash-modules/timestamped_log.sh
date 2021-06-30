##!/bin/bash
# Copyright (c) 2009-2021 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
# License: LGPL2+

# Import log module and then override some functions
. import.sh log date meta


#>>> timestamped_log - print timestamped logs. Drop-in replacement for log module.
#>> Warning: call to logging function will invokes `date` command to generate timestamp.

#>
#> Variables:

#>
#> * __timestamped_log_format - format of timestamp. Default value: "%F %T" (full date and time).
__timestamped_log_format="%F %T "


#>>
#>> Functions:

#>>
#>> * timestamped_log::set_format FORMAT  Set format for date. Default value is "%F %T".
timestamped_log::set_format() {
  __timestamped_log_format="$1"
}

#>>
#>> Wrapped functions:
#>>
#>> log::info, info, debug - print timestamp to stdout and then log message.
meta::wrap \
  'date::print_current_datetime "$__timestamped_log_format"' \
  '' \
  log::info \
  info \
  debug

#>>
#>> log::error, log::warn, error, warn - print timestamp to stderr and then log message.
meta::wrap \
  'date::print_current_datetime "$__timestamped_log_format" >&2' \
  '' \
  log::error \
  log::warn \
  error \
  warn \
  panic

#>>
#>> See log module usage for details about log functions. Original functions
#>> are available with prefix "timestamped_log::orig_".
