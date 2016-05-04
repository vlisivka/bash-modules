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

[ "${__cwdir__DEFINED:-}" == "yes" ] || {
  __cwdir__DEFINED="yes"

  if [ "${1:-}" == '--usage' -o "${1:-}" == '--summary' ]
  then
    cwdir_summary() {
      echo "Change working directory to directory where main script file is located."
    }

    cwdir_usage() {
      echo 'Just import this cwdir module to change working directory to directory where main script file is located.'
    }
  else

    # Get main file name
    __cwdir_IND="${#BASH_SOURCE[*]}"
    __cwdir__APP="${BASH_SOURCE[__cwdir_IND-1]}"

    case "$__cwdir__APP" in
      */*)
        cd "${__cwdir__APP%/*}/" || return $?
      ;;
    esac

    unset __cwdir_IND __cwdir__APP

  fi
}
