#!/bin/bash
APP_DIR="$(dirname "$0")"
export __IMPORT__BASE_PATH="$APP_DIR/../src/bash-modules"
export PATH="$APP_DIR/../src:$PATH"
. import.sh strict log unit string

###############################################
# Test cases

test_trim_spaces_with_multiple_spaces_at_both_sides() {
  string::trim_spaces BAR "   aaaa   "
  unit::assert_equal "$BAR" "aaaa"
}

test_trim_spaces_with_multiple_spaces_at_left_side() {
  string::trim_spaces BAR "   aaaa   *"
  unit::assert_equal "$BAR" "aaaa   *"
}

test_trim_spaces_with_multiple_spaces_at_right_side() {
  string::trim_spaces BAR "&   aaaa   "
  unit::assert_equal "$BAR" "&   aaaa"
}

test_split_by_delimiter() {
  string::split_by_delimiter FOO ":;+-" "a:b;c+d-e"
  unit::assert_arrays_are_equal "Wrong array returned by split_by_delimiter." "${FOO[@]}" -- a b c d e
}

test_split_by_delimiter_with_escape() {
  string::split_by_delimiter FOO ":;+-" "a\:b;c\+d-e"
  unit::assert_arrays_are_equal "Wrong array returned by split_by_delimiter." "${FOO[@]}" -- 'a:b' 'c+d' e
}

test_strings_basename_with_full_path() {
  string::basename FOO "/a/b.c" ".c"
  unit::assert_equal "$FOO" "b"
}

test_strings_basename_without_path() {
  string::basename FOO "b.c" ".c"
  unit::assert_equal "$FOO" "b"
}

test_strings_basename_without_ext() {
  string::basename FOO "b.c"
  unit::assert_equal "$FOO" "b.c"
}

test_strings_basename_with_different_ext() {
  string::basename FOO "b.c" ".e"
  unit::assert_equal "$FOO" "b.c"
}

test_strings_dirname_with_full_path() {
  string::dirname FOO "/a/b.c"
  unit::assert_equal "$FOO" "/a"
}

test_strings_dirname_with_relative_path() {
  string::dirname FOO "../a/b.c"
  unit::assert_equal "$FOO" "../a"
}

test_strings_dirname_with_file_name_only() {
  string::dirname FOO "b.c"
  unit::assert_equal "$FOO" "."
}

test_random_string() {
 string::random_string FOO 8
 unit::assert_equal "${#FOO}" 8
}

test_chr() {
  string::chr FOO 65
  unit::assert_equal "$FOO" "A"
}

test_ord() {
  string::ord FOO "A"
  unit::assert_equal "$FOO" "65"
}

test_quote_to_bash_format() {
  STRING="a' b [] & \$ % \" \\
        ;
G^&^%&^%&^
"
  string::quote_to_bash_format FOO "$STRING"
  eval "BAR=$FOO"
  unit::assert_equal "$BAR" "$STRING"
}

test_unescape_backslash_sequences() {
  STRING1="a\nb\tc\071"
  STRING2=$'a\nb\tc\071'

  string::unescape_backslash_sequences FOO "$STRING1"
  unit::assert_equal "$FOO" "$STRING2"
}

test_to_identifier() {
  string::to_identifier FOO "Hello, world!"
  unit::assert_equal "$FOO" "Hello__world_"
}

test_contains() {
  string::contains 'aba' 'b' || unit::fail "String \"aba\" contains substring \"b\"."
  string::contains 'ab*a' '*' || unit::fail "String \"ab*a\" contains substring \"*\"."
  string::contains 'aba\' '\' || unit::fail "String \"aba\\\" contains substring \"\\\"."

  string::contains 'aba' 'c' && unit::fail "String \"aba\" doesn't contain substring \"c\"." || :
  string::contains 'aba' '*' && unit::fail "String \"aba\" doesn't contain substring \"*\"." || :
  string::contains 'aba' '\' && unit::fail "String \"aba\" doesn't contain substring \"\\\"." || :
}

unit::run_test_cases "$@"
