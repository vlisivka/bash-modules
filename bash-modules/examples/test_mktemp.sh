#!/bin/bash
. import.sh strict log unit string

MKTEMP="./mktemp.sh"

setUp() {
  unset TMPDIR
}

###############################################
# Test cases

test_mktemp_without_options() {
  file_name="$($MKTEMP)"

  unit::assert "File was not created by mktemp." [ -f "$file_name" ]
  unit::assert "Temporary file must be placed in /tmp." "string::starts_with '$file_name' '/tmp/'"
  unit::assert "Template must be replaced by a random string." "! string::contains '$file_name' 'XXX'"

  rm -f "$file_name"
}

test_mktemp_with_dry_run_option() {
  file_name="$($MKTEMP --dry-run)"

  unit::assert "File must not be created by mktemp with --dry-run option." '[ !  -f "$file_name" ]'
  unit::assert "Temporary file must be placed in /tmp." "string::starts_with '$file_name' '/tmp/'"
  unit::assert "Template must be replaced by a random string." "! string::contains '$file_name' 'XXX'"
}

test_mktemp_with_template() {
  file_name="$($MKTEMP /var/tmp/foooXXXXXXXXX.bar)"

  unit::assert_not_equal "$file_name" "/var/tmp/foooXXXXXXXXX.bar" "XXXXX in template is not replaced by random string."
  unit::assert "File was not created by mktemp." '[ -f "$file_name" ]'
  unit::assert "Temporary file must be placed in /var/tmp in this case." "string::starts_with '$file_name' '/var/tmp/fooo'"
  unit::assert "Template must be replaced by a random string." "! string::contains '$file_name' 'XXX'"

  rm -f "$file_name"
}

test_mktemp_with_d_option() {
  dir_name="$($MKTEMP -d)"

  unit::assert "Directory was not created by mktemp." '[ -d "$dir_name" ]'
  unit::assert "Template must be replaced by a random string." "! string::contains '$dir_name' 'XXX'"

  rm -rf "$dir_name"
}

test_mktemp_with_t_option() {
  # Option -t is deprecated in mktemp, because it's confusing.
  file_name="$($MKTEMP -t /var/var/foooXXXXXXXXX.bar)"

  unit::assert "File was not created by mktemp." '[ -f "$file_name" ]'
  unit::assert "Temporary file must be placed in /tmp in this case." "string::starts_with '$file_name' '/tmp/'"
  unit::assert "Template must be replaced by a random string." "! string::contains '$file_name' 'XXX'"

  rm -f "$file_name"
}

test_mktemp_with_tmpdir_option() {
  file_name="$($MKTEMP --tmpdir=/var/tmp /tmp/foooXXXXXXXXX.bar)"

  unit::assert "File was not created by mktemp." [ -f "$file_name" ]
  unit::assert "Temporary file must be placed in /var/tmp in this case." "string::starts_with '$file_name' '/var/tmp/fooo'"
  unit::assert "Template must be replaced by a random string." "! string::contains '$file_name' 'XXX'"

  rm -f "$file_name"
}


# Helper function. Create bunch of temporary files, write content into
# these files, then check read content back and check is it was overwritten
# or not.
mktemp_test_file_worker() {
  local WORKER_NUMBER="$1"
  local NUMBER_OF_FILES="$2"
  shift 2

  local FILES=( )
  for((I=0; I<NUMBER_OF_FILES; I++))
  do
    local FILE="$($MKTEMP "$@")"

    echo "$WORKER_NUMBER:$I" > "$FILE"

    FILES[${#FILES[@]}]="$FILE"
  done

  for((I=0; I<NUMBER_OF_FILES; I++))
  do
    unit::assert_equal "$(cat "${FILES[I]}")" "$WORKER_NUMBER:$I" "Incorrect content of file \"${FILES[I]}\"."

    rm -f "${FILES[I]}"
  done
}

# Heavy test case. Remove DISABLED_ prefix to enable it.
#
# Create 4 parallel processes. Each process will write 1200 temporary
# files to save directory, and then check is file content was overwritten # or not.
# In case of filename conflict, bash will print error:
# /mktemp.sh: line 79: /tmp/test_mktemp_in_parallel_mode_for_files.x5m: cannot overwrite existing file
DISABLED_test_mktemp_in_parallel_mode_for_files() {
  . import.sh elapsed_time

  mktemp_test_file_worker 1 1200 /tmp/test_mktemp_in_parallel_mode_for_files.XXX &
  mktemp_test_file_worker 2 1200 /tmp/test_mktemp_in_parallel_mode_for_files.XXX &
  mktemp_test_file_worker 3 1200 /tmp/test_mktemp_in_parallel_mode_for_files.XXX &
  mktemp_test_file_worker 4 1200 /tmp/test_mktemp_in_parallel_mode_for_files.XXX

  wait

  elapsed_time::print
}

unit::run_test_cases "$@"
