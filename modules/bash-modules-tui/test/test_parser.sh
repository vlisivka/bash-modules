#!/bin/bash

set -ue

__IMPORT__BASE_PATH=../src/bash-modules
export PATH="../src:$PATH"
. import.sh log unit parser

setUp() {
  TOKENIZER_DEFAULT_ACTION='echo "Unknown key: \"$KEY\"."'
}

###############################################
# Test cases

test_cursor_keys() {

  FOO=`generate_input_tokenizer $'\E[A=echo KEY_UP' $'\E[B=echo KEY_DOWN'  $'\E[C=echo KEY_RIGHT' $'\E[D=echo KEY_LEFT'`
  RESULT=`echo -n $'\E[A' | eval "$FOO"` ; assertEqual "$RESULT" "KEY_UP"
  RESULT=`echo -n $'\E[B' | eval "$FOO"` ; assertEqual "$RESULT" "KEY_DOWN"
  RESULT=`echo -n $'\E[C' | eval "$FOO"` ; assertEqual "$RESULT" "KEY_RIGHT"
  RESULT=`echo -n $'\E[D' | eval "$FOO"` ; assertEqual "$RESULT" "KEY_LEFT"
}

test_return_key() {
  FOO=`generate_input_tokenizer $'\n=echo RETURN'`
  RESULT=`echo -n $'\n' | eval "$FOO"` ; assertEqual "$RESULT" "RETURN"
}

test_backspace_key() {
  FOO=`generate_input_tokenizer $'\n=echo RETURN' $'\x7f=echo BACKSPACE'`
  RESULT=`echo -n $'\x7f' | eval "$FOO"` ; assertEqual "$RESULT" "BACKSPACE"
  RESULT=`echo -n $'\n' | eval "$FOO"` ; assertEqual "$RESULT" "RETURN"
}

test_unicode_chars() {
  FOO=`generate_input_tokenizer 'а=echo char_а' 'я=echo char_я'`
  RESULT=`echo -n 'а' | eval "$FOO"` ; assertEqual "$RESULT" "char_а"
  RESULT=`echo -n 'я' | eval "$FOO"` ; assertEqual "$RESULT" "char_я"
}

test_equal_sign() {
  FOO=`generate_input_tokenizer '==echo equal'`
  RESULT=`echo -n '=' | eval "$FOO"` ; assertEqual "$RESULT" "equal"
}

run_test_cases "$@"
