#!/bin/bash
APP_DIR="$(dirname "$0")"
export __IMPORT__BASE_PATH="$APP_DIR/../src/bash-modules"
export PATH="$APP_DIR/../src:$PATH"
. import.sh strict log unit string

###############################################
# Test cases

test_trim() {
  string::trim BAR "   aaaa   "
  unit::assert_equal "$BAR" "aaaa"

  string::trim BAR "   aaaa   *"
  unit::assert_equal "$BAR" "aaaa   *"

  string::trim BAR "&   aaaa   "
  unit::assert_equal "$BAR" "&   aaaa"
}

test_trim_start() {
  string::trim_start BAR "   aaaa   "
  unit::assert_equal "$BAR" "aaaa   "
}

test_trim_end() {
  string::trim_end BAR "   aaaa   "
  unit::assert_equal "$BAR" "   aaaa"
}

test_insert() {
  v="abba"
  string::insert v 0 "cc"
  unit::assert_equal "$v" "ccabba"

  v="abba"
  string::insert v 2 "cc"
  unit::assert_equal "$v" "abccba"

  v="abba"
  string::insert v 4 "cc"
  unit::assert_equal "$v" "abbacc"
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
  unit::assert "String contains substring" "string::contains 'aba' 'b'"
  unit::assert "String contains substring" "string::contains 'ab*a' '*'"
  unit::assert "String contains substring" "string::contains 'aba\\' '\\'"

  unit::assert "String doesn't contain substring" "! string::contains 'aba' 'c'"
  unit::assert "String doesn't contain substring" "! string::contains 'aba' '*'"
  unit::assert "String doesn't contain substring" "! string::contains 'aba' '\\'"
}

test_starts_with() {
  unit::assert "String starts with substring" "string::starts_with 'abac' 'a'"
  unit::assert "String starts with substring" "string::starts_with '*aba' '*'"
  unit::assert "String starts with substring" "string::starts_with '\\aba' '\\'"

  unit::assert "String doesn't start with substring" "! string::starts_with 'aba' 'c'"
  unit::assert "String doesn't start with substring" "! string::starts_with 'aba' '*'"
  unit::assert "String doesn't start with substring" "! string::starts_with 'aba' '\\'"
}

test_ends_with() {
  unit::assert "String ends with substring" "string::ends_with 'caba' 'a'"
  unit::assert "String ends with substring" "string::ends_with 'aba*' '*'"
  unit::assert "String ends with substring" "string::ends_with 'aba\\' '\\'"

  unit::assert "String doesn't end with substring" "! string::ends_with 'aba' 'c'"
  unit::assert "String doesn't end with substring" "! string::ends_with 'aba' '*'"
  unit::assert "String doesn't end with substring" "! string::ends_with 'aba' '\\'"
}

unit::run_test_cases "$@"
