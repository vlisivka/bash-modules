#!/bin/bash
APP_DIR="$(dirname "$0")"
export __IMPORT__BASE_PATH="$APP_DIR/../src/bash-modules"
export PATH="$APP_DIR/../src:$PATH"
. import.sh strict log unit arguments


###############################################
# Test cases

test_yes_option() {
  local FOO="no"

  arguments::parse '--foo)FOO;Yes' -- --foo || {
    error "Cannot parse Yes option."
    return 1
  }

  unit::assert_equal "$FOO" "yes" "Yes option parsed incorrectly."
}

test_no_option() {
  local FOO="yes"

  arguments::parse '--foo)FOO;No' -- --foo || {
    error "Cannot parse No option."
    return 1
  }

  unit::assert_equal "$FOO" "no" "No option parsed incorrectly."
}

test_command_option() {
  local FOO=""

  arguments::parse 'foo)FOO;Command' -- foo || {
    error "Cannot parsee Command option."
    return 1
  }

  unit::assert_equal "$FOO" "foo" "Command option parsed incorrectly."
}

test_string_option() {
  local FOO="" BAR="" BAZ=""

  arguments::parse '--foo)FOO;S' '--bar)BAR;Str' '--baz)BAZ;String' -- --foo foo --bar=bar --baz baz || {
    error "Cannot parse String option."
    return 1
  }

  unit::assert_equal "$FOO" "foo" "String option foo parsed incorrectly."
  unit::assert_equal "$BAR" "bar" "String option bar parsed incorrectly."
  unit::assert_equal "$BAZ" "baz" "String option baz parsed incorrectly."
}

test_number_option() {
  local FOO="" BAR="" BAZ=""

  arguments::parse '--foo)FOO;N' '--bar)BAR;Num,(( BAR >= 2 ))' '--baz)BAZ;Number,Required' -- --foo 1 --bar 2 --baz 3 || {
    error "Cannot parse Number option."
    return 1
  }

  unit::assert_equal "$FOO" "1" "Numeric option foo parsed incorrectly."
  unit::assert_equal "$BAR" "2" "Numeric option bar parsed incorrectly."
  unit::assert_equal "$BAZ" "3" "Numeric option baz parsed incorrectly."
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
    error "Cannot parse Number option with option postcondition."
    return 1
  }

  unit::assert_equal "$FOO" "3" "Numeric option foo parsed incorrectly."
  unit::assert_equal "$BAR" "4" "Numeric option bar parsed incorrectly."
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
    error "Cannot parse Array option."
    return 1
  }

  unit::assert_equal "${#FOO[@]}" "2" "Array option parsed incorrectly: wrong count of elements."
  unit::assert_equal "${FOO[0]}" "bar" "Array option parsed incorrectly: wrong first value."
  unit::assert_equal "${FOO[1]}" "baz" "Array option parsed incorrectly: wrong second value."
}

test_incremental_argument() {
  local FOO=0
  arguments::parse '-f|-fo|--foo)FOO;I' -- -f --foo -fo || {
    error "Cannot parse array argument."
    return 1
  }
  unit::assert_equal "$FOO" "3" "Incremental option parsed incorrectly: wrong count of options."
}

unit::run_test_cases "$@"
