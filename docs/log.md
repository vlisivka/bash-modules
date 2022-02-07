## NAME

`log` - various functions related to logging.

## VARIABLES
* `__log__APP` - name of main file without path.
* `__log__DEBUG` - set to yes to enable printing of debug messages and backtraces.
* `__log__BACKTRACE` - set to yes to enable printing of backtraces.

## FUNCTIONS

* `backtrace [INDEX]` - display functions and source line numbers starting
from given index in stack trace, when debugging or back tracking is enabled.

* `error MESAGE...` - print error message and backtrace (if enabled).

* `warn MESAGE...` - print warning message and backtrace (if enabled).

* `info MESAGE...` - print info message.

* `debug MESAGE...` - print debug message, when debugging is enabled only.

* `log::fatal LEVEL MESSAGE...` - print a fatal-like LEVEL: MESSAGE to STDERR.

* `log::error LEVEL MESSAGE...` - print error-like LEVEL: MESSAGE to STDERR.

* `log::warn LEVEL MESSAGE...` - print warning-like LEVEL: MESSAGE to STDERR.

* `log::info LEVEL MESSAGE...` - print info-like LEVEL: MESSAGE to STDOUT.

* `panic MESAGE...` - print error message and backtrace, then exit with error code 1.

* `unimplemented MESAGE...` - print error message and backtrace, then exit with error code 42.

* `todo MESAGE...` - print todo message and backtrace.

* `dbg VARIABLE...` - print name of variable and it content to stderr

* `log::enable_debug_mode` - enable debug messages and stack traces.

* `log::disable_debug_mode` - disable debug messages and stack traces.

* `log::enable_backtrace` - enable stack traces.

* `log::disable_backtrace` - disable stack traces.

## NOTES

- If STDOUT is connected to tty, then
  * info and info-like messages will be printed with message level higlighted in green,
  * warn and warn-like messages will be printed with message level higlighted in yellow,
  * error and error-like messages will be printed with message level higlighted in red.
