#!/bin/bash
APP_DIR="$(dirname "$0")"
export __IMPORT__BASE_PATH=( $(readlink -f "$APP_DIR/../src/bash-modules") )
export PATH=$(readlink -f "$APP_DIR/../src")":$PATH"
. import.sh strict log unit

###############################################
# Test cases

test_cwdir() {
  local original_dir=$(pwd)
  . import.sh cwdir

  unit::assertEqual "$( pwd )" "$original_dir"
}

unit::run_test_cases "$@"
