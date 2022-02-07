##!/bin/bash
# Copyright (c) 2009-2021 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
# License: LGPL2+

#>> ## NAME
#>>
#>>> `strict` - unofficial strict mode for bash
#>>
#>> Just import this module, to enabe strict mode: `set -euEo pipefail`.
#>
#> ## NOTE
#>
#> * Option `-e` is not working when command is part of a compound command,
#> or in subshell. See bash manual for details. For example, `-e` may not working
#> in a `for` cycle.

set -euEo pipefail
trap 'panic "Uncaught error."' ERR
