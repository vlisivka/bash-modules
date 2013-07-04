#!/bin/bash

set -ue

export __IMPORT__BASE_PATH=../src/bash-modules
. import.sh log

APP_DIR=`dirname "$0"`
EXIT_CODE=0

for I in "$APP_DIR"/test_*.sh
do
  /bin/bash -ue "$I" "$@" || {
    EXIT_CODE=$?
  }
done

exit $EXIT_CODE
