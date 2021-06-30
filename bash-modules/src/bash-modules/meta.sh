##!/bin/bash
# Copyright (c) 2009-2021 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
# License: LGPL2+

#>>> meta - functions for working with bash code

#>>
#>> * meta::copy_function FUNCTION_NAME NEW_FUNCTION_PREFIX - copy function to new function with prefix in name.
#>    create copy of function with new prefix.
#>    Old function can be redefined or `unset -f`.
meta::copy_function() {
  local FUNCTION_NAME="$1"
  local PREFIX="$2"

  eval "$PREFIX$(declare -fp $FUNCTION_NAME)"
}

#>>
#>> * meta::wrap BEFORE AFTER FUNCTION_NAME[...] - wrap function.
#>    Create wrapper for a function(s). Execute given commands before and after
#>    each function. Original function is available as meta::orig_FUNCTION_NAME.
meta::wrap() {
  local BEFORE="$1"
  local AFTER="$2"
  shift 2

  local FUNCTION_NAME
  for FUNCTION_NAME in "$@"
  do
    # Rename original function
    meta::copy_function "$FUNCTION_NAME" "meta::orig_" || return 1

    # Redefine function
    eval "
function $FUNCTION_NAME() {
  $BEFORE

  local __meta__EXIT_CODE=0
  meta::orig_$FUNCTION_NAME \"\$@\" || __meta__EXIT_CODE=\$?

  $AFTER

  return \$__meta__EXIT_CODE
}
"
  done
}


#>>
#>> * meta::functions_with_prefix PREFIX - print list of functions with given prefix.
meta::functions_with_prefix() {
  compgen -A function "$1"
}
