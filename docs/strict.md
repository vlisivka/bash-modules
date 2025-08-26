## NAME

`strict` - unofficial strict mode for bash

Just import this module, to enabe strict mode: `set -euEo pipefail`
and `shopt -s inherit_errexit` .
Also, it installs handler for ERR trap, to print stack trace on exit
(requires log module).
