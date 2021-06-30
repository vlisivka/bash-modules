#!/bin/bash
set -euEo pipefail
APP_DIR="$(dirname "$0")"

PREFIX="/usr"
MODULES_DIR="@PREFIX@/share/bash-modules"
BIN_DIR="@PREFIX@/bin"

cd "$APP_DIR"

main() {
  echo "Modules directory: \"$MODULES_DIR\"."
  echo "Bin directory: \"$BIN_DIR\"."

  mkdir -p "$MODULES_DIR" || { echo "ERROR: Cannot create directory \"$MODULES_DIR\"." >&2 ; return 1 ;}
  install -t "$MODULES_DIR" src/bash-modules/*.sh || { echo "ERROR: Cannot install modules to directory \"$MODULES_DIR\"." >&2 ; return 1 ;}

  mkdir -p "$BIN_DIR" || { echo "ERROR: Cannot create directory \"$BIN_DIR\"." >&2 ; return 1 ;}
  install -D src/import.sh "$BIN_DIR/import.sh" || { echo "ERROR: Cannot install import.sh script to \"$MODULES_DIR\"." >&2 ; return 1 ;}
  # TODO: replace /usr/share/bash with $MODULES_DIR in $BIN_DIR/import.sh
}

while (( $# > 0 ))
do
  case "$1" in
    -p|--prefix)
      PREFIX="${2:?Value is required for option: prefix for directories, e.g. \"$HOME/.local\" or \"/usr/local\".}"
      shift 1
    ;;

    -m|--modules-dir)
      MODULES_DIR="${2:?Value is required for option: path to directory with modules, e.g. \"/usr/local/share/bash-modules\".}"
      shift 1
    ;;

    -b|--bin-dir)
      BIN_DIR="${2:?Value is required for option: path to bin directory, e.g. \"$HOME/bin\" or \"/usr/local/bin\".}"
      shift 1
    ;;

    *)
      echo "ERROR: Unknown option: \"$1\"." >&2
      return 1
    ;;
  esac

  shift 1
done

MODULES_DIR="${MODULES_DIR/@PREFIX@/$PREFIX}"
BIN_DIR="${BIN_DIR/@PREFIX@/$PREFIX}"

main
exit
