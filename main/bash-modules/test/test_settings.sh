#!/bin/bash

set -ue

__IMPORT__BASE_PATH=../src/bash-modules
export PATH="../src:$PATH"
. ../src/import.sh log unit mktemp settings

###############################################
# Test cases

test_import_from_single_file() {
  local FILE=`mktemp`
  echo "TEST=foo" >"$FILE"

  import_settings "$FILE"

  assertEqual "${TEST:-}" "foo"

  rm -f "$FILE"
}

test_import_from_multiple_files() {
  local FILE1=`mktemp`
  echo "TEST1=foo" >"$FILE1"
  local FILE2=`mktemp`
  echo "TEST2=bar" >"$FILE2"

  import_settings "$FILE1" "$FILE2"

  assertEqual "${TEST1:-}" "foo"
  assertEqual "${TEST2:-}" "bar"

  rm -f "$FILE1" "$FILE2"
}

test_import_from_dir() {
  local DIR=`mktemp -d`
  local FILE1="$DIR/file1.sh"
  echo "TEST1=foo" >"$FILE1"
  local FILE2="$DIR/file2.sh"
  echo "TEST2=bar" >"$FILE2"

  import_settings "$DIR"

  assertEqual "${TEST1:-}" "foo"
  assertEqual "${TEST2:-}" "bar"

  rm -rf "$DIR"
}

run_test_cases "$@"
