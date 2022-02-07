## NAME

`timestamped_log` - print timestamped logs. Drop-in replacement for `log` module.

## VARIABLES

* `__timestamped_log_format` - format of timestamp. Default value: "%F %T" (full date and time).

## FUNCTIONS

* `timestamped_log::set_format FORMAT` - Set format for date. Default value is "%F %T".

## Wrapped functions:

`log::info`, `info`, `debug` - print timestamp to stdout and then log message.

`log::error`, `log::warn`, `error`, `warn` - print timestamp to stderr and then log message.

## NOTES

See `log` module usage for details about log functions. Original functions
are available with prefix `"timestamped_log::orig_"`.
