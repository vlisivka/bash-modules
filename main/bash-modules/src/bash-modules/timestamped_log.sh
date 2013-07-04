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



[ "${__log__DEFINED:-}" == "yes" ] || {
  __log__DEFINED="yes"

  #export PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:+${FUNCNAME[0]}}: '.

  # Get main file name
  __log_IND="${#BASH_SOURCE[*]}"
  __log__APP="${BASH_SOURCE[__log_IND-1]}"
  __log__APP="${__log__APP##*/}" # Strip everything before last "/"
  unset __log_IND

#  __log__DEBUG="${__log__DEBUG:-no}"

  log_summary() {
    echo "Print timestamped logs. Drop-in replacement for log module."
  }

  log_usage() {
    echo '
timestamped_log_set_format FORMAT  Set format for date. Default value is "%F %T".

backtrace [INDEX]	Display functions and source line numbers
			starting from given index (skip 1 frame by
			default), when debugging is enabled.

error [MESAGE]...	print error message and backtrace.

warn [MESAGE]...	print warning message and backtrace.

info [MESAGE]...	print info message.

todo [MESAGE]...	print todo message and backtrace.

debug [MESAGE]...	print debug message, when debugging is enabled.

log_error LEVEL MESSAGE...	print error-like message to STDERR.

log_warn LEVEL MESSAGE...	print warning-like message to STDERR.

log_info LEVEL MESSAGE...	print info-like message to STDOUT.

log_enable_debug_mode   enable stack traces

log_disable_debug_mode  disable stack traces

If STDOUT is connected to tty, then info and info-like messages will be
printed with message level higlighted in green.

If STDERR is connected to tty, then info and info-like messages will be
printed with message level higlighted in green.
'
  }


  backtrace() {
    local BEGIN="${1:-1}" # Display line numbers starting from given index
    [ "${__log__DEBUG:-}" != "yes" ] || {
      local I
      for(( I=BEGIN; I<${#FUNCNAME[@]}; I++ ))
      do
        echo $'\t\t'"at ${FUNCNAME[$I]}(${BASH_SOURCE[$I]}:${BASH_LINENO[$I-1]})"
      done
      echo
    }
  }

  __timestamped_log_format="%F %T"

  timestamped_log_set_format() {
    __timestamped_log_format="$1"
  }

  error() {
    local TIMESTAMP="`date "+$__timestamped_log_format"`"
    if [ -t 2 ]
    then
      # STDERR is tty
      local __log_ERROR_BEGIN=$'\033[31m'
      local __log_ERROR_END=$'\033[39m'
      echo "$TIMESTAMP ${__log_ERROR_BEGIN}ERROR${__log_ERROR_END} [$__log__APP] ${*:-}" >&2
    else
      echo "$TIMESTAMP ERROR [$__log__APP] ${*:-}" >&2
    fi
    backtrace 2
  }

  warn() {
    local TIMESTAMP="`date "+$__timestamped_log_format"`"
    if [ -t 2 ]
    then
      # STDERR is tty
      local __log_WARN_BEGIN=$'\033[33m'
      local __log_WARN_END=$'\033[39m'
      echo "$TIMESTAMP ${__log_WARN_BEGIN}WARN${__log_WARN_END} [$__log__APP] ${*:-}" >&2
    else
      echo "$TIMESTAMP WARN [$__log__APP] ${*:-}" >&2
    fi
    backtrace 2
  }

  info() {
    local TIMESTAMP="`date "+$__timestamped_log_format"`"
    if [ -t 1 ]
    then
      # STDOUT is tty
      local __log_INFO_BEGIN=$'\033[32m'
      local __log_INFO_END=$'\033[39m'
      echo "$TIMESTAMP ${__log_INFO_BEGIN}INFO${__log_INFO_END} [$__log__APP] ${*:-}"
    else
      echo "$TIMESTAMP INFO [$__log__APP] ${*:-}"
    fi
  }

  todo() {
    local TIMESTAMP="`date "+$__timestamped_log_format"`"
    if [ -t 2 ]
    then
      # STDERR is tty
      local __log_WARN_BEGIN=$'\033[33m'
      local __log_WARN_END=$'\033[39m'
      echo "$TIMESTAMP ${__log_WARN_BEGIN}TODO${__log_WARN_END} [$__log__APP] ${*:-}" >&2
    else
      echo "$TIMESTAMP TODO [$__log__APP] ${*:-}" >&2
    fi
    backtrace 2
  }

  debug() {
    local ="`date "+$__timestamped_log_format"`"
   [ "${__log__DEBUG:-}" != yes ] || echo "$TIMESTAMP DEBUG [$__log__APP] ${*:-}"
  }

  log_error() {
    local TIMESTAMP="`date "+$__timestamped_log_format"`"
    local LEVEL="$1" ; shift
    if [ -t 2 ]
    then
      # STDERR is tty
      local __log_ERROR_BEGIN=$'\033[31m'
      local __log_ERROR_END=$'\033[39m'
      echo "$TIMESTAMP ${__log_ERROR_BEGIN}$LEVEL${__log_ERROR_END} [$__log__APP] ${*:-}" >&2
    else
      echo "$TIMESTAMP $LEVEL [$__log__APP] ${*:-}" >&2
    fi
    backtrace 2
  }

  log_warn() {
    local TIMESTAMP="`date "+$__timestamped_log_format"`"
    local LEVEL="${1:-WARN}" ; shift
    if [ -t 2 ]
    then
    # STDERR is tty
      local __log_WARN_BEGIN=$'\033[33m'
      local __log_WARN_END=$'\033[39m'
      echo "$TIMESTAMP ${__log_WARN_BEGIN}$LEVEL${__log_WARN_END} [$__log__APP] ${*:-}" >&2
    else
      echo "$TIMESTAMP $LEVEL [$__log__APP] ${*:-}" >&2
    fi
    backtrace 2
  }

  log_info() {
    local TIMESTAMP="`date "+$__timestamped_log_format"`"
    local LEVEL="${1:-INFO}" ; shift
    if [ -t 1 ]
    then
      # STDOUT is tty
      local __log_INFO_BEGIN=$'\033[32m'
      local __log_INFO_END=$'\033[39m'
      echo "$TIMESTAMP ${__log_INFO_BEGIN}${LEVEL}${__log_INFO_END} [$__log__APP] ${*:-}"
    else
      echo "$TIMESTAMP ${LEVEL} [$__log__APP] ${*:-}"
    fi
  }

  log_enable_debug_mode() {
    __log__DEBUG="yes"
  }

  log_disable_debug_mode() {
    __log__DEBUG="no"
  }

}
