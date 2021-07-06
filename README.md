* [bash-modules](#bash-modules)
   * [Simple module system for bash.](#simple-module-system-for-bash)
   * [Syntax](#syntax)
   * [Example](#example)
   * [License](#license)
   * [Vision](#vision)
   * [Features](#features)
   * [TODO](#todo)
   * [Showcase - log module](#showcase---log-module)
   * [Showcase - arguments module](#showcase---arguments-module)
   * [Showcase - strict mode](#showcase---strict-mode)
   * [Error handling](#error-handling)
      * [Chain of errors](#chain-of-errors)
      * [Panic](#panic)

bash-modules
============

## Simple module system for bash.

Module loader and collection of modules for bash scripts, to quickly write safe bash scripts in unofficial bash strict mode.

Currentyl, bash-modules project is targetting users of Linux OS, such as system administrators.

bash-modules is developed at Fedora Linux and requires bash 4 or higher.

## Syntax

To include module(s) into your script (note the "." at the beginning of the line):

```
. import.sh MODULE[...]
```

To list available modules and show their documentation call import.sh as a command:

```
import.sh [OPTIONS]
```

NOTE: Don't be confused by `import` (without `.sh`) command from `ImageMagick` package. `bash-modules` uses `import.sh`, not `import`.

## Example

```bash
#!/bin/bash
. import.sh log
info "Hello, world!"
```

See more examples in [bash-modules/examples](bash-modules/examples) directory.

## License

`bash-modules` is licensed under terms of LGPL2+ license, like glibc. You are not allowed to copy-paste the code of this project into an your non-GPL-ed project, but you are free to use, modify, or distribute `bash-modules` as a separate library.

## Vision

My vision for the project is to create a loadable set of bash subroutines, which are:

  * useful;
  * work in strict mode (set -ue);
  * correctly handle strings with spaces and special characters;
  * use as little external commands as possible;
  * easy to use;
  * well documented;
  * well covered by test cases.

## Features

* module for logging;
* module for parsing of arguments;
* module for unit testing;
* full support for unofficial strict mode.

## Installation

Use `install.sh` script in bash-modules directory to install bash-modules
to `~/.local` (default for a user) or `/usr/local/bin` (default for a
root user). See `./install.sh --help` for options.


## TODO

* [x] Implement module loader.
* [x] Implement few modules with frequently used functions and routines.
* [ ] Cooperate with other bash-related projects.
* [ ] Implement a repository for extra modules.
* [ ] Implement a package manager for modules or integrate with an existing PM.

## Showcase - log module

```bash
#!/bin/bash
. import.sh strict log arguments

main() {
  debug "A debug message (use --debug option to show debug messages)."

  info "An information message. Arguments: $*"

  warn "A warning message."

  error "An error message."

  todo "A todo message."

  unimplemented "Not implemented."
}

arguments::parse -- "$@" || panic "Cannot parse arguments."

dbg ARGUMENTS

main "${ARGUMENTS[@]}"
```

![Output](https://raw.githubusercontent.com/vlisivka/bash-modules/master/images/showcase-log-1.png)

![Output](https://raw.githubusercontent.com/vlisivka/bash-modules/master/images/showcase-log-2.png)

## Showcase - arguments module


```bash
#!/bin/bash
. import.sh strict log arguments

NAME="John"
AGE=42
MARRIED="no"


main() {
  info "Name: $NAME"
  info "Age: $AGE"
  info "Married: $MARRIED"
  info "Other arguments: $*"
}

arguments::parse \
  "-n|--name)NAME;String,Required" \
  "-a|--age)AGE;Number,(( AGE >= 18 ))" \
  "-m|--married)MARRIED;Boolean" \
  -- "$@" || panic "Cannot parse arguments. Use \"--help\" to show options."

main "${ARGUMENTS[@]}" || exit $?

# Comments marked by "#>>" are shown by --help.
# Comments marked by "#>" and "#>>" are shown by --man.

#> Example of a script with parsing of arguments.
#>>
#>> Usage: showcase-arguments.sh [OPTIONS] [--] [ARGUMENTS]
#>>
#>> OPTIONS:
#>>
#>>   -h|--help       show this help screen.
#>>   --man           show complete manual.
#>>   -n|--name NAME  set name. Name must not be empty. Default name is "John".
#>>   -a|--age  AGE   set age. Age must be >= 18. Default age is 42.
#>>   -m|--married    set married flag to "yes". Default value is "no".
#>>
```

![Output](https://raw.githubusercontent.com/vlisivka/bash-modules/master/images/showcase-arguments-1.png)


![Output](https://raw.githubusercontent.com/vlisivka/bash-modules/master/images/showcase-arguments-2.png)


![Output](https://raw.githubusercontent.com/vlisivka/bash-modules/master/images/showcase-arguments-3.png)

## Showcase - strict mode

```bash
#!/bin/bash
. import.sh strict log
a() {
  b
}
b() {
  c
}
c() {
  d
}
d() {
  false
}

a

```

![Output](https://raw.githubusercontent.com/vlisivka/bash-modules/master/images/showcase-strict-mode.png)

## Error handling

`bash-modules` `log` module supports two strategies to handle errors:

### Chain of errors

The first, strategy is to report the error to user, and then return error code from the function, to produce chain of errors. This technique allows for system administrator to understand faster - why script failed and what it tried to achieve.

```bash
#!/bin/bash
. import.sh strict log
foo() {
  xxx || { error "Cannot execute xxx."; return 1; }
}

bar() {
  foo || { error "Cannot perform foo."; return 1; }
}

main() {
  bar || { error "Cannot perform bar."; return 1; }
}

main "$@" || exit $?
```

```text
$ ./chain-of-errors.sh
./chain-of-errors.sh: line 4: xxx: command not found
[chain-of-errors.sh] ERROR: Cannot execute xxx.
[chain-of-errors.sh] ERROR: Cannot perform foo.
[chain-of-errors.sh] ERROR: Cannot perform bar.
```

### Panic

The second strategy is just to panic, when error happened, and abort script. Backtrace is printed automatically in this case.

```bash
#!/bin/bash
. import.sh strict log
xxx || panic "Cannot execute xxx."
```

```text
$ ./simple-panic.sh
./simple-panic.sh: line 3: xxx: command not found
[simple-panic.sh] PANIC: Cannot execute xxx.
		at main(./simple-panic.sh:3)
```

NOTE: If error happened in a subshell, then script author need to add another panic handler after end of subshell, e.g. `( false || panic "foo" ) || panic "bar"`.
