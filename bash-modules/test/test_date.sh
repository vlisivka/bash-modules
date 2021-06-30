#!/bin/bash
APP_DIR="$(dirname "$0")"
export __IMPORT__BASE_PATH="$APP_DIR/../src/bash-modules"
export PATH="$APP_DIR/../src:$PATH"
. import.sh strict log unit date

###############################################
# Test cases

#test_trim() {
#  string::trim BAR "   aaaa   "
#  unit::assert_equal "$BAR" "aaaa"
#}

test_timestamp() {
  local output expected_output

  date::timestamp output || panic "Cannot get timestamp."
  printf -v "expected_output" "%(%s)T" "-1" || panic "Cannot get timestamp using printf."

  unit::assert_equal "$output" "$expected_output" "This test may fail sometimes on the boundary of a second."
}

test_current_datetime() {
  local output expected_output

  date::current_datetime output "%F %T %z" || panic "Cannot get date time."
  printf -v "expected_output" "%(%F %T %z)T" "-1" || panic "Cannot get date time using printf."

  unit::assert_equal "$output" "$expected_output" "This test may fail sometimes on the boundary of a second."
}

test_datetime() {
  local output expected_output

  date::datetime output "%F %T %z" "42" || panic "Cannot get date time."
  printf -v "expected_output" "%(%F %T %z)T" "42" || panic "Cannot get date time using printf."

  unit::assert_equal "$output" "$expected_output" "Unexpected output from date::datetime."
}

DISABLED_test_elapsed_time() {
  sleep 1

  local output="$(date::print_elapsed_time)"
  local expected_output="Elapsed time: 0 days 00:00:01."

  unit::assert_equal "$output" "$expected_output" "Unexpected output from date::print_elapsed_time."
}

unit::run_test_cases "$@"
