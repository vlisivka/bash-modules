## NAME

`import.sh` - import bash modules into scripts or into interactive shell

## SYNOPSIS

### In a scipt:

* `. import.sh MODULE[...]`      - import module(s) into script or shell
* `source import.sh MODULE[...]` - same as above, but with `source` instead of `.`


### At command line:

* `import.sh --help|-h`                - print this help text
* `import.sh --man`                    - show manual
* `import.sh --list`                   - list modules with their path
* `import.sh --summary|-s [MODULE...]` - list module(s) with summary
* `import.sh --usage|-u MODULE[...]`   - print module help text
* `import.sh --doc|-d MODULE[...]`     - print module documentation

## DESCRIPTION

Imports given module(s) into current shell.

Use:

* `import.sh --list` - to print list of available modules.
* `import.sh --summary` - to print list of available modules with short description.
* `import.sh --usage MODULE[...]` - to print longer description of given module(s).

## CONFIGURATION

* `BASH_MODULES_PATH` - ':' separated list of your own directories with modules,
which will be prepended to module search path. You can set `__IMPORT__BASE_PATH` array in
script at begining, in `/etc/bash-modules/config.sh`, or in `~/.config/bash-modules/config.sh` file.

* `__IMPORT__BASE_PATH` - array with list of directories for module search. It's reserved for internal use by bash-modules.

* `/etc/bash-modules/config.sh` - system wide configuration file.
WARNING: Code in this script will affect all scripts.

### Example configration file

Put following snippet into `~/.config/bash-modules/config.sh` file:

```bash

    # Enable stack trace printing for warnings and errors,
    # like with --debug option:
    __log__STACKTRACE=="yes"

    # Add additional directory to module search path:
    BASH_MODULES_PATH="/home/user/my-bash-modules"

```

* `~/.config/bash-modules/config.sh` - user configuration file.
**WARNING:** Code in this script will affect all user scripts.

## VARIABLES

* `IMPORT__BIN_FILE` -  script main file name, e.g. `/usr/bin/my-script`, as in `$0` variable in main file.

## FUNCTIONS

* `import::import_module MODULE` - import single module only.

* `import::import_modules MODULE[...]` - import module(s).

* `import::list_modules FUNC [MODULE]...` - print various information about module(s).
`FUNC` is a function to call on each module. Function will be called with two arguments:
path to module and module name.
Rest of arguments are module names. No arguments means all modules.

* `import::show_documentation LEVEL PARSER FILE` - print module built-in documentation.
This function scans given file for lines with "#>" prefix (or given prefix) and prints them to stdout with prefix stripped.
  * `LEVEL` - documentation level (one line summary, usage, full manual):
     - 1 - for manual (`#>` and `#>>` and `#>>>`),
     - 2 - for usage (`#>>` and `#>>>`),
     - 3 - for one line summary (`#>>>`),
     - or arbitrary prefix, e.g. `##`.
  * `FILE` - path to file with built-in documentation.
