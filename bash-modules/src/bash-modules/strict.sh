##!/bin/bash
# Copyright (c) 2009-2021 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
# License: LGPL2+

#>> ## NAME
#>>
#>>> `strict` - unofficial strict mode for bash
#>>
#>> Just import this module, to enabe strict mode: `set -euEo pipefail`
#>> and `shopt -s inherit_errexit` .
#>> Also, it installs handler for ERR trap, to print stack trace on exit
#>> (requires log module).

set -o errexit -o nounset -o errtrace -o pipefail
shopt -s inherit_errexit

trap 'panic "Uncaught error."' ERR
