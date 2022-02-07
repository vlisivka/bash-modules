## NAME

`meta` - functions for working with bash functions.

## FUNCTIONS

* `meta::copy_function FUNCTION_NAME NEW_FUNCTION_PREFIX` - copy function to new function with prefix in name.
   Create copy of function with new prefix.
   Old function can be redefined or `unset -f`.

* `meta::wrap BEFORE AFTER FUNCTION_NAME[...]` - wrap function.
   Create wrapper for a function(s). Execute given commands before and after
   each function. Original function is available as meta::orig_FUNCTION_NAME.

* `meta::functions_with_prefix PREFIX` - print list of functions with given prefix.

* `meta::is_function FUNC_NAME` Checks is given name corresponds to a function.

* `meta::dispatch PREFIX COMMAND [ARGUMENTS...]` - execute function `PREFIX__COMMAND [ARGUMENTS]`

   For example, it can be used to execute functions (commands) by name, e.g.
`main() { meta::dispatch command__ "$@" ; }`, when called as `man hw world` will execute
`command_hw "$world"`. When command handler is not found, dispatcher will try
to call `PREFIX__DEFAULT` function instead, or return error code when defaulf handler is not found.
