#!/bin/bash
APP_DIR="$(dirname "$0")"
export __IMPORT__BASE_PATH=( $(readlink -f "$APP_DIR/../src/bash-modules") )
export PATH="$(readlink -f "$APP_DIR/../src"):$PATH"
. import.sh strict log unit

###############################################
# Test cases

SCRIPT_DIR=$(mktemp -d)
SCRIPT_NAME="test_cd_to_bindir-test-script.sh"

[ -d "$SCRIPT_DIR" ] || panic "Temporary directory is not created."

unit::set_up() {
  mkdir -p "$SCRIPT_DIR" || panic "Cannot create temporary directory."

  cat > "$SCRIPT_DIR/$SCRIPT_NAME" <<END_OF_SCRIPT || panic "Cannot create script file in temporary directory."
#!/bin/bash
__IMPORT__BASE_PATH=( $(readlink -f "$APP_DIR/../src/bash-modules") )
PATH="$PATH"

# Import cd_to_bindir module, to change working directory
. import.sh cd_to_bindir

# Just print current working directory
pwd

END_OF_SCRIPT

  chmod a+x "$SCRIPT_DIR/$SCRIPT_NAME" || panic "Cannot chmod \"$SCRIPT_DIR/$SCRIPT_NAME\" file."
}

unit::tear_down() {
  rm -rf "$SCRIPT_DIR" || panic "Cannot remove \"$SCRIPT_DIR\" directory."
}

test_cwdir() {
  unit::assert_equal "$( "$SCRIPT_DIR/$SCRIPT_NAME" )" "$SCRIPT_DIR" "cd_to_bindir doesn't change directory when called by absolute path."
  unit::assert_equal "$( cd "$SCRIPT_DIR" ; "./$SCRIPT_NAME" )" "$SCRIPT_DIR" "cd_to_bindir doesn't change directory when called by relative path."
  unit::assert_equal "$( cd / ; "./$SCRIPT_DIR/$SCRIPT_NAME" )" "$SCRIPT_DIR" "cd_to_bindir doesn't change directory when called by relative path."

  PATH="$SCRIPT_DIR:$PATH"
  unit::assert_equal "$( "$SCRIPT_NAME" )" "$SCRIPT_DIR"  "cd_to_bindir doesn't change directory when called by PATH."
}

unit::run_test_cases "$@"
