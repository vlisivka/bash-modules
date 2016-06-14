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

#>>> cwdir - change working directory to directory where main script file is located.
#>>
#>> Just import this cwdir module to change working directory to directory where main script file is located.


# Redefine variable, to make path to main file absolute, so it will not be affected by change of working dir.
IMPORT__BIN_FILE="$(readlink -f "$BIN_FILE")"

# Change working directory to directory where script is located
cd "${IMPORT__BIN_FILE%/*}/"
