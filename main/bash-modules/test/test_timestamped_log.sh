#!/bin/bash

set -ue

__IMPORT__BASE_PATH=../src/bash-modules
export PATH="../src:$PATH"
. ../src/import.sh timestamped_log unit

###############################################
# Test cases

test_info() {
  assertEqual "$(info Test)" "placeholder INFO [test_timestamped_log.sh] Test"
}

test_warn() {
  assertEqual "$(warn Test 2>&1 1>/dev/null)" "placeholder WARN [test_timestamped_log.sh] Test"
}

test_error() {
  assertEqual "$(error Test 2>&1 1>/dev/null)" "placeholder ERROR [test_timestamped_log.sh] Test"
}

test_todo() {
  assertEqual "$(todo Test 2>&1 1>/dev/null)" "placeholder TODO [test_timestamped_log.sh] Test"
}

test_timestamped_log_info() {
  assertEqual "$(log_info foo Test)" "placeholder foo [test_timestamped_log.sh] Test"
}

test_timestamped_log_warn() {
  assertEqual "$(log_warn foo Test 2>&1 1>/dev/null)" "placeholder foo [test_timestamped_log.sh] Test"
}

test_timestamped_log_error() {
  assertEqual "$(log_error foo Test 2>&1 1>/dev/null)" "placeholder foo [test_timestamped_log.sh] Test"
}

timestamped_log_set_format "placeholder"

run_test_cases "$@"
