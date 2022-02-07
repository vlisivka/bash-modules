## NAME

`date` - date-time functions.

## FUNCTIONS

* `date::timestamp VARIABLE` - return current time in seconds since UNIX epoch

* `date::current_datetime VARIABLE FORMAT` - return current date time in given format.
See `man 3 strftime` for details.

* `date::print_current_datetime FORMAT` - print current date time in given format.
See `man 3 strftime` for details.

* `date::datetime VARIABLE FORMAT TIMESTAMP` - return current date time in given format.
See `man 3 strftime` for details.

* `date::print_elapsed_time` - print value of SECONDS variable in human readable form: "Elapsed time: 0 days 00:00:00."
It's useful to know time of execution of a long script, so here is function for that.
Assign 0 to SECONDS variable to reset counter.
