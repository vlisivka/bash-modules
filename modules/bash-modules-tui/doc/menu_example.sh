#!/bin/bash

set -ue

#. import.sh log terminal menu
__IMPORT__BASE_PATH=../src/bash-modules
. import.sh log terminal menu mktemp

# Hide cursor and switch to alternate screen
switch_to_alternate_screen
echo -n "$T_CURSOR_OFF"

# Restore screen and cursor at exit
trap "switch_from_alternate_screen; echo -n \"\$T_CURSOR_ON\" " EXIT SIGHUP
echo -n "$T_CLEAR_ALL"

# Create temporary fifo file
TEMP_FIFO="$(mktemp -t "menu_example.XXXXXXXXXXXXXX.fifo")"
rm -f "$TEMP_FIFO"
mkfifo "$TEMP_FIFO" || {
  error "Cannot create fifo file."
  exit 1
}

menu_keyboard_input_tokenizer >"$TEMP_FIFO" 2>&1 </dev/stdin & sleep 0.01

<"$TEMP_FIFO" menu center center "Виберіть фрукт чи ягоду" "яблуко" "вишня" "апельсин" "груша" "слива" "виноград" "агрус" "свіжі помідори" "яблуко" "вишня" "апельсин" "груша" "слива" "виноград" "агрус" "свіжі помідори"

rm -f "$TEMP_FIFO"

# Make cursor visible again and return back to main screen
echo -n "$T_CLEAR_ALL"
switch_from_alternate_screen
echo -n "$T_CURSOR_ON"

info "Selected item number: $MENU_MENU_SELECTED_ITEM_NUMBER."
info "Selected item: $MENU_SELECTED_ITEM."
echo

