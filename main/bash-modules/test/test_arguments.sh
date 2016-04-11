#!/bin/bash

set -ue

__IMPORT__BASE_PATH=../src/bash-modules
export PATH="../src:$PATH"
. ../src/import.sh log unit arguments


###############################################
# Test cases

test_boolean_argument() {
  local FOO="no"
  parse_arguments '--foo)FOO;B' -- --foo || {
    error "Cannot parse boolean argument."
    return 1
  }
  assertEqual "$FOO" "yes" "Boolean argument parsed incorrectly."
}

test_string_argument() {
  local FOO="" BAR="" BAZ=""
  parse_arguments '--foo)FOO;S' '--bar)BAR;Str' '--baz)BAZ;String' -- --foo foo --bar=bar --baz baz || {
    error "Cannot parse string argument."
    return 1
  }
  assertEqual "$FOO" "foo" "String option foo parsed incorrectly."
  assertEqual "$BAR" "bar" "String option bar parsed incorrectly."
  assertEqual "$BAZ" "baz" "String option baz parsed incorrectly."
}

test_numeric_argument() {
  local FOO="" BAR="" BAZ=""
  parse_arguments '--foo)FOO;N' '--bar)BAR;Num,(( BAR >= 2 ))' '--baz)BAZ;Number,Required' -- --foo 1 --bar 2 --baz 3 || {
    error "Cannot parse numeric argument."
    return 1
  }
  assertEqual "$FOO" "1" "Numeric option foo parsed incorrectly."
  assertEqual "$BAR" "2" "Numeric option bar parsed incorrectly."
  assertEqual "$BAZ" "3" "Numeric option baz parsed incorrectly."
}

test_required_option() {
  local FOO="" BAR="" BAZ=""
  parse_arguments '--foo)FOO;Str,Req' -- 2>/dev/null && {
    error "Function must return error code when required option is missed."
    return 1
  } || :
}

test_option_postcondition() {
  local FOO="" BAR="" BAZ=""
  parse_arguments '--foo)FOO;Num,Req,(( FOO > 2 ))' '--bar)BAR;Num,Req, (( BAR > 1 )), (( BAR > FOO ))' -- --foo 3 --bar 4 || {
    error "Cannot parse numeric argument with option postcondition."
    return 1
  }
  assertEqual "$FOO" "3" "Numeric option foo parsed incorrectly."
  assertEqual "$BAR" "4" "Numeric option bar parsed incorrectly."
}

test_option_postcondition_failed() {
  local FOO="" BAR="" BAZ=""
  parse_arguments '--foo)FOO;Num,Req,(( FOO > 2 ))' -- --foo 2 2>/dev/null && {
    error "Function must return error code when option postcondition is failed."
    return 1
  } || :
}

test_array_argument() {
  local FOO=( )
  parse_arguments '-f|--foo)FOO;A' -- -f bar --foo=baz || {
    error "Cannot parse array argument."
    return 1
  }
  assertEqual "${#FOO[@]}" "2" "Array argument parsed incorrectly: wrong count of elements."
  assertEqual "${FOO[0]}" "bar" "Array  argument parsed incorrectly: wrong first value."
  assertEqual "${FOO[1]}" "baz" "Array  argument parsed incorrectly: wrong second value."
}

test_incremental_argument() {
  local FOO=0
  parse_arguments '-f|-fo|--foo)FOO;I' -- -f --foo -fo || {
    error "Cannot parse array argument."
    return 1
  }
  assertEqual "$FOO" "3" "Incremental argument parsed incorrectly: wrong count of options."
}

run_test_cases "$@"
