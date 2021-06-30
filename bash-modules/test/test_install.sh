#!/bin/bash
APP_DIR="$(dirname "$0")"
export __IMPORT__BASE_PATH=( $(readlink -f "$APP_DIR/../src/bash-modules") )
export PATH="$(readlink -f "$APP_DIR/.."):$(readlink -f "$APP_DIR/../src"):$PATH"
. import.sh strict log unit

###############################################
# Test cases

DIR=$(mktemp -d)

[ -d "$DIR" ] || panic "Temporary directory is not created."

unit::set_up() {
  mkdir -p "$DIR" || panic "Cannot create temporary directory."
}

unit::tear_down() {
  rm -rf "$DIR" || panic "Cannot remove \"$DIR\" directory."
}

test_install_to_custom_directory() {
  local output="$(install.sh --prefix "$DIR")"
  local expected_output="Modules directory: \"$DIR/share/bash-modules\".
Bin directory: \"$DIR/bin\"."

  unit::assert_equal "$output" "$expected_output" "Unexpected output from install.sh command."

  [ -s "$DIR/bin/import.sh" ] || unit::fail "Script import.sh does not exists or empty after installation."
  [ -x "$DIR/bin/import.sh" ] || unit::fail "Script import.sh must have executable permission set after installation."
  [ -s "$DIR/share/bash-modules/log.sh" ] || unit::fail "Module log is not exists or empty after installation."
}

test_install_to_custom_directories() {
  local output="$(install.sh --bin-dir "$DIR/main" --modules-dir "$DIR/modules")"
  local expected_output="Modules directory: \"$DIR/modules\".
Bin directory: \"$DIR/main\"."

  unit::assert_equal "$output" "$expected_output" "Unexpected output from install.sh command."

  [ -s "$DIR/main/import.sh" ] || unit::fail "Script import.sh does not exists or empty after installation."
  [ -x "$DIR/main/import.sh" ] || unit::fail "Script import.sh must have executable permission set after installation."
  [ -s "$DIR/modules/log.sh" ] || unit::fail "Module log is not exists or empty after installation."
}

unit::run_test_cases "$@"
