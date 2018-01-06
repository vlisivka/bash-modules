#!/bin/bash
APP_DIR="$(dirname "$0")"
export __IMPORT__BASE_PATH="$APP_DIR/../src/bash-modules"
export PATH="$APP_DIR/../src:$PATH"
. import.sh strict log

EXIT_CODE=0

for I in "$APP_DIR"/test_*.sh
do
  bash -ue "$I" "$@" || {
    EXIT_CODE=$?
  }
done

exit $EXIT_CODE
