#!/usr/bin/env bash
set -ue

# Wrapper script for compatibility with basher, to use bash-modules
# without installation.

__BASH_MODULES_IMPORT_SH="$(readlink -f "${BASH_SOURCE[0]}")"
__BASH_MODULES_PROJECT_DIR="${__BASH_MODULES_IMPORT_SH%/*}"
export BASH_MODULES_PATH="${BASH_MODULES_PATH:+$BASH_MODULES_PATH:}$__BASH_MODULES_PROJECT_DIR/bash-modules/src/bash-modules/"

# If this is top level code and program name is .../import.sh
if [ "${FUNCNAME:+x}" == "" -a "${0##*/}" == "import.sh" ]
then
  exec "$__BASH_MODULES_PROJECT_DIR/bash-modules/src/import.sh" "$@"
else
  . "$__BASH_MODULES_PROJECT_DIR/bash-modules/src/import.sh" "$@"
fi
