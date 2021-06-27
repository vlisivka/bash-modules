#!/bin/bash
APP_DIR="$(dirname "$0")"
export __IMPORT__BASE_PATH="$APP_DIR/../src/bash-modules"
export PATH="$APP_DIR/../src:$PATH"
. import.sh strict timestamped_log unit

###############################################
# Test cases

test_info() {
  unit::assert_equal "$( info Test 2>/dev/null )" "placeholder[test_timestamped_log.sh] INFO: Test"
}

test_warn() {
  unit::assert_equal "$( warn Test 2>&1 1>/dev/null )" "placeholder[test_timestamped_log.sh] WARN: Test"
}

test_error() {
  unit::assert_equal "$( error Test 2>&1 1>/dev/null )" "placeholder[test_timestamped_log.sh] ERROR: Test"
}

test_timestamped_log_info() {
  unit::assert_equal "$( log::info foo Test 2>/dev/null )" "placeholder[test_timestamped_log.sh] foo: Test"
}

test_timestamped_log_warn() {
  unit::assert_equal "$( log::warn foo Test 2>&1 1>/dev/null )" "placeholder[test_timestamped_log.sh] foo: Test"
}

test_timestamped_log_error() {
  unit::assert_equal "$( log::error foo Test 2>&1 1>/dev/null )" "placeholder[test_timestamped_log.sh] foo: Test"
}

timestamped_log::set_format "placeholder"

unit::run_test_cases "$@"
