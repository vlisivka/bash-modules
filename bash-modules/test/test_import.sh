#!/bin/bash
set -ueEo pipefail
# Cannot use import.sh there, because import.sh itself is under test.

APP_DIR="$(dirname "$0")"
export PATH="$APP_DIR/../src:$PATH"
IMPORT__BIN_FILE="test_import.sh"

. ../src/bash-modules/log.sh
trap 'panic "Uncaught error."' ERR

DIR="$(mktemp -d)"

set_up() {
  mkdir -p "$DIR" || panic "Cannot create temporary directory \"$DIR\"."

  # Add temporary directory to the module lookup path
  BASH_MODULES_PATH="$DIR"

  # Create two modules in the temporary directory, which are importing
  # each other.

  # Create a test module 1
  cat >"$DIR/a_mod_1.sh" <<END_OF_MODULE
. import.sh a_mod_2

#>>> A test 1 module one-line summary.

#>>
#>> A test function 1 desciption.
fn1() {
 echo "This is fn1."
}

#>>
#>> A test function 12 desciption.
fn12() {
 echo "This is fn12."
 [[ "\${1:-}" == "stop" ]] || fn21 stop
}

#>
#> A detailed documentation about test module 1.
#>

#a_prefix Alternative documentation 1.
END_OF_MODULE

  # Create a test module 2.
  cat >"$DIR/a_mod_2.sh" <<END_OF_MODULE
. import.sh a_mod_1

#>>> A test 2 module one-line summary.

#>>
#>> A test function 2 desciption.
fn2() {
 echo "This is fn2."
}

#>>
#>> A test function 21 desciption.
fn21() {
 echo "This is fn21."
 [[ "\${1:-}" == "stop" ]] || fn12 stop
}

#>
#> A detailed documentation about test module 2.
#>
END_OF_MODULE


}

tear_down() {
  rm -rf "$DIR" || panic "Cannot remove \"$DIR\" directory."
}

# Test the import of a module by BASH_MODULES_PATH
test_bash_modules_path() {
  . import.sh a_mod_1 || panic "Cannot import module a_mod_1."

  # Check content of module lookup path array
  local output=$(dbg __IMPORT__BASE_PATH 2>&1)
  local expected_output="[test_import.sh] DBG: __IMPORT__BASE_PATH=([0]=\"$DIR\" [1]=\"/usr/share/bash-modules\")"

  [[ "$output" == "$expected_output" ]] || panic "Unexpected value of __IMPORT__BASE_PATH: $output"
}

# TODO: Test that import path doesn't contain current directory by default.

test_import_of_modules() {
  . import.sh a_mod_1 a_mod_2 || panic "Cannot import module a_mod_1 or a_mod_2."
}

test_import_of_non_existing_module() {
  local output=$(. import.sh non_existing_mod 2>&1 >/dev/null && panic "import.sh must return an error, when module doesn't exists. Actual exit code: $?." )
  local expected_output="[import.sh:import_module] ERROR: Cannot locate module: \"non_existing_mod\". Search path: $DIR /usr/share/bash-modules"

  [[ "$output" == "$expected_output" ]] || panic "Unexpected error message returned by import.sh after trying to import non-existing module: \"$output\"."
}

test_import_of_module_from_subdir() {
  local subdir="$DIR/subdir"
  mkdir -p "$subdir" || panic "Cannot create temporary directory \"$subdir\"."

  # Create empty "module" in the subdirectory
  echo "# An empty module" > "$subdir/an_empty_mod.sh"

  # Try to import it
  . import.sh subdir/an_empty_mod || panic "Cannot import module subdir/an_empty_mod."
}

test_multiple_dirs_in_bash_module_path() {
  local subdir1="$DIR/subdir1"
  local subdir2="$DIR/subdir2"

  mkdir -p "$subdir1" || panic "Cannot create temporary directory \"$subdir1\"."
  mkdir -p "$subdir2" || panic "Cannot create temporary directory \"$subdir2\"."

  # Create empty "module" in the subdirectories
  echo "# An empty module 1" > "$subdir1/an_empty_mod_1.sh"
  echo "# An empty module 2" > "$subdir2/an_empty_mod_2.sh"

  BASH_MODULES_PATH="$DIR:$subdir1:$subdir2"

  . import.sh a_mod_1 an_empty_mod_1 an_empty_mod_2 || panic "Cannot import module a_mod_1 or an_empty_mod_1 or an_empty_mod_2 when using BASH_MODULES_PATH with multiple directories."
}

test_that_import_path_contains_no_empty_element_by_default() {
  unset BASH_MODULES_PATH
  . import.sh || panic "Cannot import nothing."

  # Check content of module lookup path array
  local output=$(dbg __IMPORT__BASE_PATH 2>&1)
  [[ "$output" == "[test_import.sh] DBG: __IMPORT__BASE_PATH=([0]=\"/usr/share/bash-modules\")" ]] \
    || panic "Unexpected value of __IMPORT__BASE_PATH: $out"
}

test_module_list() {
  export BASH_MODULES_PATH

  local output="$(import.sh -l | grep -v /usr/share/bash-modules || panic "Cannot show list of modules")"
  local expected_output="a_mod_1                 "$'\t'"$DIR/a_mod_1.sh
a_mod_2                 "$'\t'"$DIR/a_mod_2.sh"

  [[ "$output" == "$expected_output" ]] || panic "Unexpected output: \"$output\"."
}

todo_test_module_summary() {
  export BASH_MODULES_PATH

  # TODO: How to filter out summaries of standard modules?
  local output="$(import.sh -s | grep -v /usr/share/bash-modules || panic "Cannot show summary for modules")"
  local expected_output=""

  [[ "$output" == "$expected_output" ]] || panic "Unexpected output: \"$output\"."
}

test_module_usage() {
  export BASH_MODULES_PATH

  local output="$(import.sh -u a_mod_1)"
  local expected_output="A test 1 module one-line summary.

A test function 1 desciption.

A test function 12 desciption."

  [[ "$output" == "$expected_output" ]] || panic "Unexpected output: \"$output\"."
}

test_module_documentation() {
  export BASH_MODULES_PATH

  local output="$(import.sh --doc a_mod_1)"
  local expected_output="A test 1 module one-line summary.

A test function 1 desciption.

A test function 12 desciption.

A detailed documentation about test module 1."

  [[ "$output" == "$expected_output" ]] || panic "Unexpected output: \"$output\"."
}

test_alternatvive_module_documentation() {
  export BASH_MODULES_PATH
  . import.sh

  local output="$(import::show_documentation "#a_prefix" "$DIR/a_mod_1.sh")"
  local expected_output="Alternative documentation 1."

  [[ "$output" == "$expected_output" ]] || panic "Unexpected output: \"$output\"."
}


run_test_cases() {
  local exit_code=0
  local test_cases=( $(compgen -A function test) )

  set_up || panic "set_up failed."

  for test_case in "${test_cases[@]}"
  do
    (
      set_up || panic "set_up failed."

      ( "$test_case" ) || { error "Test \"$test_case\" failed." ; exit_code=1 ; }

      echo -n "."

      tear_down || panic "tear_down failed."
    )
  done
  echo

  (( $exit_code != 0 )) || info "OK."

  return $exit_code
}

run_test_cases
exit
