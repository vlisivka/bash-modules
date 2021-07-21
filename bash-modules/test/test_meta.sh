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

test_is_function() {
  unit::assert "is_function FUNCTION must return true" meta::is_function test_is_function
  unit::assert "is_function FUNCTION must return true" meta::is_function meta::is_function

  local a_var="foo"
  unit::assert "is_function VAR must return false" ! meta::is_function a_var

  unit::assert "is_function SHELL_BUILTIN must return false" ! meta::is_function cd
  unit::assert "is_function COMMAND must return false" ! meta::is_function /usr/bin/ls
}

test_dispatch() {

  local fresult=""

  f1() {
    fresult="f1 $*"
  }
  f2() {
    fresult="f2 $*"
  }

  meta::dispatch f 1 foo bar || unit::fail "Cannot dispatch to function."
  unit::assert_equal "$fresult" "f1 foo bar" "Unexpected result of call to f1 via dispatch."

  meta::dispatch f 2 bar baz || unit::fail "Cannot dispatch to function."
  unit::assert_equal "$fresult" "f2 bar baz" "Unexpected result of call to f2 via dispatch."

  meta::dispatch f 3 bar baz 2>/dev/null && unit::fail "Dispatch function must not call an non-existing function or a command." || :
  meta::dispatch l s bar baz 2>/dev/null && unit::fail "Dispatch function must not call an non-existing function or a command." || :
  meta::dispatch c d bar baz 2>/dev/null && unit::fail "Dispatch function must not call an non-existing function or a command." || :
}


test_dispatch_with_default_handler() {

  local fresult=""

  f1() {
    fresult="f1 $*"
  }
  f__DEFAULT() {
    fresult="fD $*"
  }

  meta::dispatch f 1 foo bar || unit::fail "Cannot dispatch to function."
  unit::assert_equal "$fresult" "f1 foo bar" "Unexpected result of call to f1 via dispatch."

  meta::dispatch f 2 bar baz || unit::fail "Cannot dispatch to function."
  unit::assert_equal "$fresult" "fD bar baz" "Unexpected result of call to f__DEFAULT via dispatch."
}

unit::run_test_cases "$@"
