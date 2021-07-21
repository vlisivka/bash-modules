#!/usr/bin/env bash
set -euEo pipefail # Unofficial strict mode
APP_DIR="$(dirname "$0")"

if (( $EUID == 0 ))
then
  PREFIX="/usr/local"
else
  PREFIX="${XDG_DATA_HOME:-$HOME/.local}"
fi

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

  # Update hardcoded path to directory with modules
  sed -i "s@/usr/share/bash-modules@$MODULES_DIR@g" "$BIN_DIR/import.sh" \
    || { echo "ERROR: Canno replace path to modules directory in \"$BIN_DIR/import.sh\" from \"/usr/share/bash-modules\" to \"$MODULES_DIR\"." >&2 ; return 1; }
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

    -h|--help)
      echo "Usage: install.sh [-p|--prefix PREFIX] [-m|--modules-dir DIR] [-b|--bin-dir DIR]

OPTIONS

  -h|--help

      This help screen.

  -p|--prefix PREFIX

      Install bash-modules import.sh to PREFIX/bin, and modules to
      PREFIX/share/bash-modules. Default value is \"$HOME/.local\" for
      non-root user and \"/usr/local\" for a root user.

  -m|--modules-dir DIR

      Directory to store modules. Default value is \"@PREFIX@/share/bash-modules\".

  -b|--bin-dir DIR

      Directory to store imort.sh script. Default value is \"@PREFIX/bin\".

"
    exit 0
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

main || exit $?
