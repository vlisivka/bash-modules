##!/bin/bash
# Copyright (c) 2009-2021 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
# License: GPL2+
#>>> cwdir - change working directory to directory where main script file is located.
#>>
#>> Just import this cwdir module to change current working directory to a directory,
#>> where main script file is located.

# Change working directory to directory where script is located
__BIN_FILE="${BASH_SOURCE[${#BASH_SOURCE[@]}-1]}"
cd "${__BIN_FILE%/*}/"
