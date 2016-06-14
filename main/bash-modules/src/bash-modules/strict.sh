##!/bin/bash
#
# Copyright (c) 2016 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
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

#>>> strict - strict mode (more checks for errors).

. import.sh log

#>>
#>> Bash options turned on:
#>>   * u - abort when undefined or empty variable is used. Use ${VAR:-DEFAULT_VALUE} or "${VAR:+$VAR}" to be safe.
#>>   * e - abort on uncaught errors.
#>>   * E - inherit ERR trap (see below)
#>>   * pipefail - return error code when any component of pipe will fail, instead of last one only. 
set -ueE -o pipefail

#>>
#>> Traps installed:
#>>   * ERR - show error and print stack trace in case of uncaught error.
trap 'panic "Uncaught error."' ERR
