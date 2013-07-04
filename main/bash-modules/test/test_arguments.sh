#!/bin/bash

set -ue

__IMPORT__BASE_PATH=../src/bash-modules
. ../src/import.sh log unit arguments


###############################################
# Test cases

test_boolean_argument() {
  local FOO=no
  parse_arguments '--foo)FOO;B' -- --foo || {
    error "Cannot parse boolean argument."
    return 1
  }
  assertEqual "$FOO" "yes" "Boolean argument parsed incorrectly."
}

test_string_argument() {
  local FOO=""
  parse_arguments '--foo)FOO;S' -- --foo bar || {
    error "Cannot parse string argument."
    return 1
  }
  assertEqual "$FOO" "bar" "String argument parsed incorrectly."
}

test_string_argument_alt() {
  local FOO=""
  parse_arguments '--foo)FOO;S' -- --foo=bar || {
    error "Cannot parse string argument in alternate form."
    return 1
  }
  assertEqual "$FOO" "bar" "String argument parsed incorrectly in alternate form."
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
