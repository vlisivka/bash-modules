## NAME

string - various functions to manipulate strings.

## FUNCTIONS

* `string::trim_spaces VARIABLE VALUE`
   Trim white space characters around value and assign result to variable.

* `string::trim_start VARIABLE VALUE`
   Trim white space characters at begining of the value and assign result to the variable.

* `string::trim_end VARIABLE VALUE`
   Trim white space characters at the end of the value and assign result to the variable.

* `string::insert VARIABLE POSITION VALUE`
   Insert `VALUE` into `VARIABLE` at given `POSITION`.
   Example:

   ```bash
   v="abba"
   string::insert v 2 "cc"
   # now v=="abccba"
  ```

* `string::split_by_delimiter ARRAY DELIMITERS VALUE`
   Split value by delimiter(s) and assign result to array. Use
   backslash to escape delimiter in string.
   NOTE: Temporary file will be used.

* `string::basename VARIABLE FILE [EXT]`
   Strip path and optional extension from  full file name and store
   file name in variable.

* `string::dirname VARIABLE FILE`
   Strip file name from path and store directory name in variable.

* `string::random_string VARIABLE LENGTH`
   Generate random string of given length using [a-zA-Z0-9]
   characters and store it into variable.

* `string::chr VARIABLE CHAR_CODE`
   Convert decimal character code to its ASCII representation.

* `string::ord VARIABLE CHAR`
   Converts ASCII character to its decimal value.

* `string::quote_to_bash_format VARIABLE STRING`
   Quote the argument in a way that can be reused as shell input.

* `string::unescape_backslash_sequences VARIABLE STRING`
   Expand backslash escape sequences.

* `string::to_identifier VARIABLE STRING`
   Replace all non-alphanumeric characters in string by underscore character.

* `string::find_string_with_prefix VAR PREFIX [STRINGS...]`
   Find first string with given prefix and assign it to VAR.

* `string::contains STRING SUBSTRING`
   Returns zero exit code (true), when string contains substring

* `string::starts_with STRING SUBSTRING`
   Returns zero exit code (true), when string starts with substring

* `string::ends_with STRING SUBSTRING`
   Returns zero exit code (true), when string ends with substring
