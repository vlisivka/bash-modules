##!/bin/bash
# Copyright (c) 2009-2021 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
# License: LGPL2+

#>>> cd_to_bindir - change working directory to the directory where main script file is located.
#>>
#>> Just import this cwdir module to change current working directory to a directory,
#>> where main script file is located.

#> ch_bin_dir Change working directory to directory where script is
#> located, which is usually called "bin dir".

__CD_TO_BINDIR__BIN_FILE=$( readlink -f "${BASH_SOURCE[${#BASH_SOURCE[@]}-1]}" )
__CD_TO_BINDIR="${__CD_TO_BINDIR__BIN_FILE%/*}/"
unset __CD_TO_BINDIR__BIN_FILE

cd_to_bindir() {
  cd "$__CD_TO_BINDIR"
}

cd_to_bindir
