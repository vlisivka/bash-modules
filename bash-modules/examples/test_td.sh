#!/bin/bash
. import.sh strict log unit cd_to_bindir

# Command to test
TD="$(pwd)/td"

# Temporary directory
DIR="$(mktemp -d)"

unit::set_up() {
  set -ue

  mkdir -p "$DIR"
  cd "$DIR"

  "$TD" -n >/dev/null || panic "Cannot create new TODO.md file."
}

unit::tear_down() {
  set -ue

  rm -rf "$DIR"
}

###############################################
# Test cases

test_error_without_file() {
  rm -f "TODO.md" || panic "Cannot remove TODO.md in $(pwd)."

  OUT="$(! "$TD" 2>&1 >/dev/null)" || panic "td returned zero exit code when TODO.md file is not found."

  unit::assert_equal "$OUT" "[td] ERROR: Cannot find \"TODO.md\" file in current or upper directories." "Unexpected error message returned by td."
}

test_create_new_file() {
  rm -f "TODO.md" || panic "Cannot remove TODO.md in $(pwd)."

  OUT="$("$TD" -n 2>&1)" || panic "td returned non-zero exit code when creating new TODO.md file."

  unit::assert_equal "$OUT" $'\n'"[td] INFO: \"TODO.md\" is created." "Unexpected message returned by td."
}

test_create_new_item() {
  OUT="$("$TD" foo bar baz 2>&1)" || panic "Cannot create new TODO item."

  unit::assert_equal "$OUT" $'\n'"* [ ] foo bar baz" "Unexpected message returned by td."
}

test_mark_item_as_wip() {
  OUT="$("$TD" a task 1 2>&1)" || panic "Cannot create new TODO item."
  OUT="$("$TD" -w 2>&1)" || panic "Cannot mark item as WIP."

  unit::assert_equal "$OUT" $'\n'"* [.] a task 1" "Unexpected message returned by td."

  # With message
  OUT="$("$TD" -d 2>&1)" || panic "Cannot mark TODO item as done."
  OUT="$("$TD" a task 2 2>&1)" || panic "Cannot create new TODO item."
  OUT="$("$TD" -w 16:15 2>&1)" || panic "Cannot mark item as WIP."

  unit::assert_equal "$OUT" $'\n'"* [.] a task 2 - 16:15" "Unexpected message returned by td."

  # Try to mark WIP message as WIP again
  OUT="$("$TD" -w 2>&1)" || panic "Cannot mark TODO item as WIP."

  unit::assert_equal "$OUT" $'\n'"[td] INFO: Top TODO item is already in progress."$'\n'"* [.] a task 2 - 16:15" "Unexpected message returned by td."
}

test_mark_item_as_done() {
  OUT="$("$TD" a message 1 2>&1)" || panic "Cannot create new TODO item."
  OUT="$("$TD" -d 2>&1)" || panic "Cannot mark item as done."

  unit::assert_equal "$OUT" $'\n'"* [x] a message 1" "Unexpected message returned by td."

  # With message
  OUT="$("$TD" a message 2 2>&1)" || panic "Cannot create new TODO item."
  OUT="$("$TD" -d 16:20 2>&1)" || panic "Cannot mark item as done."

  unit::assert_equal "$OUT" $'\n'"* [x] a message 2 - 16:20" "Unexpected message returned by td."
}

test_mark_item_as_canceled() {
  OUT="$("$TD" a task 1 2>&1)" || panic "Cannot create new TODO item."
  OUT="$("$TD" -c 2>&1)" || panic "Cannot mark item as canceled."

  unit::assert_equal "$OUT" $'\n'"* [-] a task 1" "Unexpected message returned by td."

  # With explanation
  OUT="$("$TD" a task 2 2>&1)" || panic "Cannot create new TODO item."
  OUT="$("$TD" -c an explanation 2>&1)" || panic "Cannot mark item as canceled."

  unit::assert_equal "$OUT" $'\n'"* [-] a task 2 - an explanation" "Unexpected message returned by td."
}

unit::run_test_cases "$@"
