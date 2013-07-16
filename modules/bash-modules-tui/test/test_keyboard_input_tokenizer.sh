#!/bin/bash

set -ue

__IMPORT__BASE_PATH=../src/bash-modules
export PATH="../src:$PATH"
. import.sh log unit keyboard_input_tokenizer

setUp() {
  TOKENIZER_DEFAULT_ACTION='echo "Unknown key: \"$KEY\"."'
}

###############################################
# Test cases

test_gnome_terminal_sequences() {
  RESULT=`echo -n $'\EO1;6R' | parse` ; assertEqual "$RESULT" "ctrl_shift_f3"
}

test_xterm_sequences() {
  RESULT=`echo -n $'\E[1;6R' | parse` ; assertEqual "$RESULT" "ctrl_shift_f3"
}

test_common_sequences() {
  RESULT=`echo -n $'\x7f' | parse` ; assertEqual "$RESULT" "backspace"
  RESULT=`echo -n $'\n' | parse` ; assertEqual "$RESULT" "newline"
}

# This function contains sleep function so it is disabled by default to reduce test suite time
DISABLED_test_TIMEOUT() {
  RESULT=`sleep 1.2 | parse` ; assertEqual "$RESULT" "TIMEOUT"
}

test_EOF() {
  RESULT=`parse </dev/null` ; assertEqual "$RESULT" "EOF"
}


##############################################
# Test suite setUp

TMP=`generate_xterm_keyboard_input_tokenizer`
eval "parse() {
  $TMP
}"

#
##############################################

run_test_cases "$@"
