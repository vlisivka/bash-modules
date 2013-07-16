##!/bin/bash
#
# Copyright (c) 2009-2013 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
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


[ "${__elapsed_time__DEFINED:-}" == "yes" ] || {
  __elapsed_time__DEFINED="yes"

  elapsed_time_summary() {
    echo "Print elapsed time since shell start in human readable format"
  }

  elapsed_time_usage() {
    echo '
print_elapsed_time	print value of SECONDS variable in human readable form: "Elapsed time: 0 days 00:00:00."

Assign 0 to SECONDS variable to reset counter.
'
  }

  # Print elapsed time since script start in user friendly format.
  print_elapsed_time() {
    printf "Elapsed time: %d days %02d:%02d:%02d.\n" $((SECONDS/(24*60*60))) $(((SECONDS/(60*60))%24)) $(((SECONDS/60)%60)) $((SECONDS%60))
  }

}
