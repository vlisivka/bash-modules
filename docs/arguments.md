## NAME

`arguments`  - contains function to parse arguments and assign option values to variables.

## FUNCTIONS

* `arguments::parse [-S|--FULL)VARIABLE;FLAGS[,COND]...]... -- [ARGUMENTS]...`

Where:

* `-S`       - short option name.

* `--FULL`   - long option name.

* `VARIABLE` - name of shell variable to assign value to.

* `FLAGS`    - one of (case sensitive):
  * `Y | Yes`               - set variable value to "yes";
  * `No`                    - set variable value to "no";
  * `I | Inc | Incremental` - incremental (no value) - increment variable value by one;
  * `S | Str | String`      - string value;
  * `N | Num | Number`      - numeric value;
  * `A | Arr | Array`       - array of string values (multiple options);
  * `C | Com | Command`     - option name will be assigned to the variable.

* `COND` -  post conditions:
  * `R | Req | Required` - option value must be not empty after end of parsing.
                         Set initial value to empty value to require this option;
  * any code           - executed after option parsing to check post conditions, e.g. "(( FOO > 3 )), (( FOO > BAR ))".

* --       - the separator between option descriptions and script commandline arguments.

* `ARGUMENTS` - command line arguments to parse.

**LIMITATION:** grouping of one-letter options is NOT supported. Argument `-abc` will be parsed as
option `-abc`, not as `-a -b -c`.

**NOTE:** bash4 requires to use `"${@:+$@}"` to expand empty list of arguments in strict mode (`-u`).

By default, function supports `-h|--help`, `--man` and `--debug` options.
Options `--help` and `--man` are calling `arguments::help()` function with `2` or `1` as
argument. Override that function if you want to provide your own help.

Unlike many other parsers, this function stops option parsing at first
non-option argument.

Use `--` in commandline arguments to strictly separate options and arguments.

After option parsing, unparsed command line arguments are stored in
`ARGUMENTS` array.

**Example:**

```bash
# Boolean variable ("yes" or "no")
FOO="no"
# String variable
BAR=""
# Indexed array
declare -a BAZ=( )
# Integer variable
declare -i TIMES=0

arguments::parse \
   "-f|--foo)FOO;Yes" \
   "-b|--bar)BAR;String,Required" \
   "-B|--baz)BAZ;Array" \
   "-i|--inc)TIMES;Incremental,((TIMES<3))" \
   -- \
   "${@:+$@}"

# Print name and value of variables
dbg FOO BAR BAZ TIMES ARGUMENTS
```

* `arguments::generate_parser OPTIONS_DESCRIPTIONS` - generate parser for options.
Will create function `arguments::parse_options()`, which can be used to parse arguments.
Use `declare -fp arguments::parse_options` to show generated source.

* `arguments::help LEVEL` - display embeded documentation.
LEVEL - level of documentation:
  * 3 - summary (`#>>>` comments),
  * 2 - summary and usage ( + `#>>` comments),
  * 1 - full documentation (+ `#>` comments).
