#!/bin/bash

set -ue

__IMPORT__BASE_PATH=../src/bash-modules
export PATH="../src:$PATH"
. ../src/import.sh log unit

###############################################
# Test cases

test_info() {
  assertEqual "$(info Test)" "[test_log.sh] INFO: Test"
}

test_warn() {
  assertEqual "$(warn Test 2>&1 1>/dev/null)" "[test_log.sh] WARN: Test"
}

test_error() {
  assertEqual "$(error Test 2>&1 1>/dev/null)" "[test_log.sh] ERROR: Test"
}

test_todo() {
  assertEqual "$(todo Test 2>&1 1>/dev/null)" "[test_log.sh] TODO: Test"
}

test_log_info() {
  assertEqual "$(log_info foo Test)" "[test_log.sh] foo: Test"
}

test_log_warn() {
  assertEqual "$(log_warn foo Test 2>&1 1>/dev/null)" "[test_log.sh] foo: Test"
}

test_log_error() {
  assertEqual "$(log_error foo Test 2>&1 1>/dev/null)" "[test_log.sh] foo: Test"
}

run_test_cases "$@"
