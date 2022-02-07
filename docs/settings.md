## NAME

`settigngs` - import settings from configuration files and configuration directories.
Also known as "configuration directory" pattern.

## FUNCTIONS
* `settings::import [-e|--ext EXTENSION] FILE|DIRECTORY...` -  Import settings
(source them into current program as shell script) when
file or directory exists. For directories, all files with given extension
(`".sh"` by default) are imported, without recursion.

**WARNING:** this method is powerful, but unsafe, because user can put any shell
command into the configuration file, which will be executed by script.

**TODO:** implement file parsing instead of sourcing.
