#!/bin/bash
APP_DIR="$(dirname "$0")"
export __IMPORT__BASE_PATH="$APP_DIR/../src/bash-modules"
export PATH="$APP_DIR/../src:$PATH"
. import.sh strict log unit settings

###############################################
# Test cases

test_import_from_single_file() {
  local FILE="$(mktemp)"
  echo "TEST=foo" >"$FILE"

  settings::import "$FILE"

  unit::assert_equal "${TEST:-}" "foo"

  rm -f "$FILE"
}

test_import_from_multiple_files() {
  local FILE1="$(mktemp)"
  echo "TEST1=foo" >"$FILE1"
  local FILE2="$(mktemp)"
  echo "TEST2=bar" >"$FILE2"

  settings::import "$FILE1" "$FILE2"

  unit::assert_equal "${TEST1:-}" "foo"
  unit::assert_equal "${TEST2:-}" "bar"

  rm -f "$FILE1" "$FILE2"
}

test_import_from_dir() {
  local DIR="$(mktemp -d)"
  local FILE1="$DIR/file1.sh"
  echo "TEST1=foo" >"$FILE1"
  local FILE2="$DIR/file2.sh"
  echo "TEST2=bar" >"$FILE2"

  settings::import "$DIR"

  unit::assert_equal "${TEST1:-}" "foo"
  unit::assert_equal "${TEST2:-}" "bar"

  rm -rf "$DIR"
}

unit::run_test_cases "$@"
