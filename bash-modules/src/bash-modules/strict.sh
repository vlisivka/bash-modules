##!/bin/bash
# Copyright (c) 2009-2021 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
# License: LGPL2+

#>>> strict - unofficial strict mode for bash
#>>
#>> Just import this module, to enabe strict mode.
#>
#> NOTE: -e set option is not working when command is part of a compound command,
# or in subshell. See bash manual for details.

set -euEo pipefail
trap 'panic "Uncaught error."' ERR
