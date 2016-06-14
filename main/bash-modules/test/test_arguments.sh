#!/bin/bash
set -ueo pipefail

APP_DIR="$(dirname "$0")"
export __IMPORT__BASE_PATH="$APP_DIR/../src/bash-modules"
export PATH="$APP_DIR/../src:$PATH"
. import.sh log unit arguments


###############################################
# Test cases

test_boolean_argument() {
  local FOO="no"
  arguments::parse '--foo)FOO;B' -- --foo || {
    error "Cannot parse boolean argument."
    return 1
  }
  unit::assertEqual "$FOO" "yes" "Boolean argument parsed incorrectly."
}

test_string_argument() {
  local FOO="" BAR="" BAZ=""
  arguments::parse '--foo)FOO;S' '--bar)BAR;Str' '--baz)BAZ;String' -- --foo foo --bar=bar --baz baz || {
    error "Cannot parse string argument."
    return 1
  }
  unit::assertEqual "$FOO" "foo" "String option foo parsed incorrectly."
  unit::assertEqual "$BAR" "bar" "String option bar parsed incorrectly."
  unit::assertEqual "$BAZ" "baz" "String option baz parsed incorrectly."
}

test_numeric_argument() {
  local FOO="" BAR="" BAZ=""
  arguments::parse '--foo)FOO;N' '--bar)BAR;Num,(( BAR >= 2 ))' '--baz)BAZ;Number,Required' -- --foo 1 --bar 2 --baz 3 || {
    error "Cannot parse numeric argument."
    return 1
  }
  unit::assertEqual "$FOO" "1" "Numeric option foo parsed incorrectly."
  unit::assertEqual "$BAR" "2" "Numeric option bar parsed incorrectly."
  unit::assertEqual "$BAZ" "3" "Numeric option baz parsed incorrectly."
}

test_required_option() {
  local FOO="" BAR="" BAZ=""
  arguments::parse '--foo)FOO;Str,Req' -- 2>/dev/null && {
    error "Function must return error code when required option is missed."
    return 1
  } || :
}

test_option_postcondition() {
  local FOO="" BAR="" BAZ=""
  arguments::parse '--foo)FOO;Num,Req,(( FOO > 2 ))' '--bar)BAR;Num,Req, (( BAR > 1 )), (( BAR > FOO ))' -- --foo 3 --bar 4 || {
    error "Cannot parse numeric argument with option postcondition."
    return 1
  }
  unit::assertEqual "$FOO" "3" "Numeric option foo parsed incorrectly."
  unit::assertEqual "$BAR" "4" "Numeric option bar parsed incorrectly."
}

test_option_postcondition_failed() {
  local FOO="" BAR="" BAZ=""
  arguments::parse '--foo)FOO;Num,Req,(( FOO > 2 ))' -- --foo 2 2>/dev/null && {
    error "Function must return error code when option postcondition is failed."
    return 1
  } || :
}

test_array_argument() {
  local FOO=( )
  arguments::parse '-f|--foo)FOO;A' -- -f bar --foo=baz || {
    error "Cannot parse array argument."
    return 1
  }
  unit::assertEqual "${#FOO[@]}" "2" "Array argument parsed incorrectly: wrong count of elements."
  unit::assertEqual "${FOO[0]}" "bar" "Array  argument parsed incorrectly: wrong first value."
  unit::assertEqual "${FOO[1]}" "baz" "Array  argument parsed incorrectly: wrong second value."
}

test_incremental_argument() {
  local FOO=0
  arguments::parse '-f|-fo|--foo)FOO;I' -- -f --foo -fo || {
    error "Cannot parse array argument."
    return 1
  }
  unit::assertEqual "$FOO" "3" "Incremental argument parsed incorrectly: wrong count of options."
}

unit::run_test_cases "$@"
