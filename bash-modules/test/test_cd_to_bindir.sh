#!/bin/bash
APP_DIR="$(dirname "$0")"
export __IMPORT__BASE_PATH=( $(readlink -f "$APP_DIR/../src/bash-modules") )
export PATH=$(readlink -f "$APP_DIR/../src")":$PATH"
. import.sh strict log unit

###############################################
# Test cases

test_cwdir() {
  local original_dir=$(pwd)
  . import.sh cd_to_bindir

  unit::assert_equal "$( pwd )" "$original_dir"

  cd /
  cd_to_bindir || fail "Cannot cd to this script directory"

  unit::assert_equal "$( pwd )" "$original_dir"
}

unit::run_test_cases "$@"
