#!/bin/bash

set -ue

__IMPORT__BASE_PATH=../src/bash-modules
export PATH="../src:$PATH"
. import.sh log unit mktemp ini_parser

EXIT_CODE=0

###############################################
# Test cases

test_sections() {
  ini_func FOO
  assertEqual "$FOO" $'foo\nbar\nbaz\nunescaping in quotes\nembeded comments\n'
}

test_keys() {
  ini_func FOO foo
  assertEqual "$FOO" $'foo1k\nfoo2k\nfoo3k\nfoo4k\n'
}

test_plain_value() {
  ini_func FOO foo foo1k
  assertEqual "$FOO" 'foo1v'
}

test_embeded_comments_with_semicolon() {
  ini_func FOO 'embeded comments' foo1k
  assertEqual "$FOO" 'foo1v' 'Embeded comment is not stripped from value.'
}

test_embeded_comments_with_sharp() {
  ini_func FOO 'embeded comments' foo2k
  assertEqual "$FOO" 'foo2v' 'Embeded comment is not stripped from value.'
}

test_embeded_comments_with_double_quotes() {
  ini_func FOO 'embeded comments' foo3k
  assertEqual "$FOO" 'foo3v' 'Embeded comment is not stripped from value.'
}

test_embeded_comments_with_single_quotes() {
  ini_func FOO 'embeded comments' foo4k
  assertEqual "$FOO" 'foo4v' 'Embeded comment is not stripped from value.'
}

test_comment_char_in_unquoted_string() {
  ini_func FOO 'embeded comments' foo5k
  assertEqual "$FOO" 'foo5v; foo' 'Embeded comment must not be stripped from value when it is not preceded with space(s).'
}

test_comment_char_in_unquoted_string2() {
  ini_func FOO 'embeded comments' foo6k
  assertEqual "$FOO" 'foo6v# foo' 'Embeded comment must not be stripped from value when it is not preceded with space(s).'
}

test_comment_char_in_single_quotes() {
  ini_func FOO 'embeded comments' foo7k
  assertEqual "$FOO" 'foo7v ; foo' 'Embeded comment must not be stripped from value when quoted.'
}

test_comment_char_in_double_quotes() {
  ini_func FOO 'embeded comments' foo8k
  assertEqual "$FOO" 'foo8v # foo' 'Embeded comment must not be stripped from value when quoted.'
}

test_unescaping_in_double_quotes() {
  ini_func FOO 'unescaping in quotes' q1k
  assertEqual "$FOO" $'q1l\nbaz1m\tbaz1r' 'Double-quoted strings must be unescaped.'
}

test_preserving_in_single_quotes() {
  ini_func FOO 'unescaping in quotes' q2k
  assertEqual "$FOO" "q2l'baz2m\\tbaz2r" 'Single-quoted strings must be preserved except for two single quotes.'
}

test_preserving_in_unquoted_strings() {
  ini_func FOO 'unescaping in quotes' q3k
  assertEqual "$FOO" 'q3l\nbaz3m\tbaz3r' 'Unquoted strings must be preserved.'
}

test_empty_value() {
  ini_func FOO bar bar3k
  assertEqual "$FOO" '' 'Empty value must be preserved.'
}

###############################################
# Test suite setUp
INI_FILE="$(mktemp -t test_ini_parser-XXXXXXXXXXXXXX.ini)"
echo "
# [Foo] section
[foo]  
foo1k=foo1v  

; rest of [foo] section
; key=value
foo2k=foo2v
  foo3k=foo3v  
foo4k=foo4v

 [bar]

bar1k = bar1v

# rest of [bar] section
# key=value
bar2k = bar2v
bar3k = 

  [baz]  

# These two does not work as expected
\"baz1k\" = \"baz1v\"
'baz2kl = baz2kr' = 'baz2vl = baz2vr'

baz3k = \$(rm  /nonexistent_dir) \`rm /nonexistent_dir\`

[unescaping in quotes]
  q1k = \"q1l\nbaz1m\tbaz1r\"
q2k = 'q2l''baz2m\tbaz2r'
q3k = q3l\nbaz3m\tbaz3r

 [embeded comments] # foo
# Should tread # or ; as comment char
foo1k=foo1v ; foo
foo2k= foo2v # foo
foo3k= \"foo3v\" ; foo
foo4k= 'foo4v' # foo

# Should not treat ; or # as comment char
foo5k=foo5v; foo
foo6k=foo6v# foo

foo7k= 'foo7v ; foo'
foo8k=\"foo8v # foo\"

# These two will not work as expected
foo9k= \"foo9v\" ; foo \"
foo10k= 'foo10v' # foo '

" > "$INI_FILE"

generate_function_from_ini_file ini_func "$INI_FILE"

#
###############################################

run_test_cases "$@" || EXIT_CODE=$?

###############################################
# Test suite tearDown

rm -f "$INI_FILE"

#
###############################################

exit $EXIT_CODE
