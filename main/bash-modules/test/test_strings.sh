#!/bin/bash

set -ue

__IMPORT__BASE_PATH=../src/bash-modules
export PATH="../src:$PATH"
. ../src/import.sh log unit strings

###############################################
# Test cases

test_trim_spaces_with_multiple_spaces_at_both_sides() {
  trim_spaces BAR "   aaaa   "
  assertEqual "$BAR" "aaaa"
}

test_trim_spaces_with_multiple_spaces_at_left_side() {
  trim_spaces BAR "   aaaa   *"
  assertEqual "$BAR" "aaaa   *"
}

test_trim_spaces_with_multiple_spaces_at_right_side() {
  trim_spaces BAR "&   aaaa   "
  assertEqual "$BAR" "&   aaaa"
}

test_split_by_delimiter() {
  split_by_delimiter FOO ":;+-" "a:b;c+d-e"
  assertArraysAreEqual "Wrong array returned by split_by_delimiter." "${FOO[@]}" -- a b c d e
}

test_split_by_delimiter_with_escape() {
  split_by_delimiter FOO ":;+-" "a\:b;c\+d-e"
  assertArraysAreEqual "Wrong array returned by split_by_delimiter." "${FOO[@]}" -- 'a:b' 'c+d' e
}

test_strings_basename_with_full_path() {
  strings_basename FOO "/a/b.c" ".c"
  assertEqual "$FOO" "b"
}

test_strings_basename_without_path() {
  strings_basename FOO "b.c" ".c"
  assertEqual "$FOO" "b"
}

test_strings_basename_without_ext() {
  strings_basename FOO "b.c"
  assertEqual "$FOO" "b.c"
}

test_strings_basename_with_different_ext() {
  strings_basename FOO "b.c" ".e"
  assertEqual "$FOO" "b.c"
}

test_strings_dirname_with_full_path() {
  strings_dirname FOO "/a/b.c"
  assertEqual "$FOO" "/a"
}

test_strings_dirname_with_relative_path() {
  strings_dirname FOO "../a/b.c"
  assertEqual "$FOO" "../a"
}

test_strings_dirname_with_file_name_only() {
  strings_dirname FOO "b.c"
  assertEqual "$FOO" "."
}

test_random_string() {
 random_string FOO 8
 assertEqual "${#FOO}" 8
}

test_chr() {
  chr FOO 65
  assertEqual "$FOO" "A"
}

test_ord() {
  ord FOO "A"
  assertEqual "$FOO" "65"
}

test_quote_to_bash_format() {
  STRING="a' b [] & \$ % \" \\
        ;
G^&^%&^%&^
"
  quote_to_bash_format FOO "$STRING"
  eval "BAR=$FOO"
  assertEqual "$BAR" "$STRING"
}

test_unescape_backslash_sequences() {
  STRING1="a\nb\tc\071"
  STRING2=$'a\nb\tc\071'

  unescape_backslash_sequences FOO "$STRING1"
  assertEqual "$FOO" "$STRING2"
}

test_to_identifier() {
  to_identifier FOO "Hello, world!"
  assertEqual "$FOO" "Hello__world_"
}

run_test_cases "$@"
