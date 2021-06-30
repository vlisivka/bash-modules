#!/bin/bash
APP_DIR="$(dirname "$0")"
export __IMPORT__BASE_PATH="$APP_DIR/../src/bash-modules"
export PATH="$APP_DIR/../src:$PATH"
. import.sh strict log unit meta

###############################################
# Test cases

test_copy_function() {
  a_fn() {
    return 42
  }
  meta::copy_function a_fn prefix_

  local exit_code=0
  prefix_a_fn || exit_code=$?

  unit::assert_equal "$exit_code" "42" "Unexpected return code is returned by copy of the function."
}

test_wrap() {
  a_fn() {
    return 42
  }
  meta::wrap "true" "true" a_fn

  local exit_code=0
  a_fn || exit_code=$?

  unit::assert_equal "$exit_code" "42" "Unexpected return code is returned by wrapped function."

  meta::orig_a_fn || exit_code=$?

  unit::assert_equal "$exit_code" "42" "Unexpected return code is returned by the original function."
}

test_wrap_code() {
  a_fn() {
    echo -n " body "
  }
  meta::wrap "echo -n before" "echo -n after" a_fn

  local output="$(a_fn)"
  local expected_output="before body after"

  unit::assert_equal "$output" "$expected_output" "Unexpected output from wrapped function."
}


test_functions_with_prefix() {
  pr_1() { :; }
  pr_2() { :; }
  pr_3() { :; }

  local output="$( meta::functions_with_prefix pr_ )"
  local expected_output="pr_1
pr_2
pr_3"

  unit::assert_equal "$output" "$expected_output" "Unexpected output from meta::functions_with_prefix."
}

unit::run_test_cases "$@"
