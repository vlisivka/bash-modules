#!/bin/bash

set -ue

__IMPORT__BASE_PATH=../src/bash-modules
. import.sh log unit xterm_keyboard_input_tokenizer

setUp() {
  TOKENIZER_DEFAULT_ACTION='echo "Unknown key: \"$KEY\"."'
}

###############################################
# Test cases

test_gnome_terminal_sequences() {
  RESULT=`echo -n $'\EO1;6R' | xterm_keyboard_input_tokenizer` ; assertEqual "$RESULT" $'ctrl_shift_f3\nEOF'
}

test_xterm_sequences() {
  RESULT=`echo -n $'\E[1;6R' | xterm_keyboard_input_tokenizer` ; assertEqual "$RESULT" $'ctrl_shift_f3\nEOF'
}

test_common_sequences() {
  RESULT=`echo -n $'\x7f' | xterm_keyboard_input_tokenizer` ; assertEqual "$RESULT" $'backspace\nEOF'
  RESULT=`echo -n $'\n' | xterm_keyboard_input_tokenizer` ; assertEqual "$RESULT" $'newline\nEOF'
}

# This function contains sleep function so it is disabled by default to reduce test suite time
DISABLED_test_TIMEOUT() {
  RESULT=`sleep 2.2 | xterm_keyboard_input_tokenizer` ; assertEqual "$RESULT" $'TIMEOUT\nTIMEOUT\nEOF'
}

test_EOF() {
  RESULT=`xterm_keyboard_input_tokenizer </dev/null` ; assertEqual "$RESULT" "EOF"
}

run_test_cases "$@"
