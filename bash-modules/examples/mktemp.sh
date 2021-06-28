##!/bin/bash
. import.sh strict arguments string

CREATE_DIR="no"
DRY_RUN="no"
QUIET="no"
USE_TMP_DIR="no"
TEMPORARY_DIR=""

main() {
  local TEMPLATE="${1:-tmp.XXXXXXXXXX}"
  [ -n "${1:-}" ] || USE_TMP_DIR="yes"

  if [ -n "$TEMPORARY_DIR" ]
  then
    # --tmpdir option is used
    USE_TMP_DIR="yes"
  else
    # Initialize with default value for -t option
    TEMPORARY_DIR="${TMPDIR:-/tmp}"
  fi

  # When use temporary dir, use only last path element of template
  [ "$USE_TMP_DIR" == "no" ] || string::basename TEMPLATE "$TEMPLATE"

  # Create private owned files and directories (0700)
  umask 077
  set -o noclobber

  local i
  for((i=0; i<100; i++))
  do
    local file_name="" random_string
    case "$TEMPLATE" in
      *XXXXXXXXXXXXXXXXXXXXXXXXX*) string::random_string random_string 25 ; file_name=${TEMPLATE//XXXXXXXXXXXXXXXXXXXXXXXXX/$random_string} ;;
      *XXXXXXXXXXXXXXXXXXXXXXXX*)  string::random_string random_string 24 ; file_name=${TEMPLATE//XXXXXXXXXXXXXXXXXXXXXXXX/$random_string} ;;
      *XXXXXXXXXXXXXXXXXXXXXXX*)   string::random_string random_string 23 ; file_name=${TEMPLATE//XXXXXXXXXXXXXXXXXXXXXXX/$random_string} ;;
      *XXXXXXXXXXXXXXXXXXXXXX*)    string::random_string random_string 22 ; file_name=${TEMPLATE//XXXXXXXXXXXXXXXXXXXXXX/$random_string} ;;
      *XXXXXXXXXXXXXXXXXXXXX*)     string::random_string random_string 21 ; file_name=${TEMPLATE//XXXXXXXXXXXXXXXXXXXXX/$random_string} ;;
      *XXXXXXXXXXXXXXXXXXXX*)      string::random_string random_string 20 ; file_name=${TEMPLATE//XXXXXXXXXXXXXXXXXXXX/$random_string} ;;
      *XXXXXXXXXXXXXXXXXXX*)       string::random_string random_string 19 ; file_name=${TEMPLATE//XXXXXXXXXXXXXXXXXXX/$random_string} ;;
      *XXXXXXXXXXXXXXXXXX*)        string::random_string random_string 18 ; file_name=${TEMPLATE//XXXXXXXXXXXXXXXXXX/$random_string} ;;
      *XXXXXXXXXXXXXXXXX*)         string::random_string random_string 17 ; file_name=${TEMPLATE//XXXXXXXXXXXXXXXXX/$random_string} ;;
      *XXXXXXXXXXXXXXXX*)          string::random_string random_string 16 ; file_name=${TEMPLATE//XXXXXXXXXXXXXXXX/$random_string} ;;
      *XXXXXXXXXXXXXXX*)           string::random_string random_string 15 ; file_name=${TEMPLATE//XXXXXXXXXXXXXXX/$random_string} ;;
      *XXXXXXXXXXXXXX*)            string::random_string random_string 14 ; file_name=${TEMPLATE//XXXXXXXXXXXXXX/$random_string} ;;
      *XXXXXXXXXXXXX*)             string::random_string random_string 13 ; file_name=${TEMPLATE//XXXXXXXXXXXXX/$random_string} ;;
      *XXXXXXXXXXXX*)              string::random_string random_string 12 ; file_name=${TEMPLATE//XXXXXXXXXXXX/$random_string} ;;
      *XXXXXXXXXXX*)               string::random_string random_string 11 ; file_name=${TEMPLATE//XXXXXXXXXXX/$random_string} ;;
      *XXXXXXXXXX*)                string::random_string random_string 10 ; file_name=${TEMPLATE//XXXXXXXXXX/$random_string} ;;
      *XXXXXXXXX*)                 string::random_string random_string  9 ; file_name=${TEMPLATE//XXXXXXXXX/$random_string} ;;
      *XXXXXXXX*)                  string::random_string random_string  8 ; file_name=${TEMPLATE//XXXXXXXX/$random_string} ;;
      *XXXXXXX*)                   string::random_string random_string  7 ; file_name=${TEMPLATE//XXXXXXX/$random_string} ;;
      *XXXXXX*)                    string::random_string random_string  6 ; file_name=${TEMPLATE//XXXXXX/$random_string} ;;
      *XXXXX*)                     string::random_string random_string  5 ; file_name=${TEMPLATE//XXXXX/$random_string} ;;
      *XXXX*)                      string::random_string random_string  4 ; file_name=${TEMPLATE//XXXX/$random_string} ;;
      *XXX*)                       string::random_string random_string  3 ; file_name=${TEMPLATE//XXX/$random_string} ;;
      *)
        error "Bad template string. TEMPLATE must contain at least 3 consecutive \"X\"s."
        exit 1
      ;;
    esac

    [ "$USE_TMP_DIR" == "no" ] || {
      file_name="$TEMPORARY_DIR/$file_name"
    }

    [ ! -e "$file_name" ] || continue

    [ "$DRY_RUN" == "no" ] || {
      echo "$file_name"
      return 0
    }

    if [ "$CREATE_DIR" == "no" ]
    then
      # Try to create file (noclobber option will not allow to
      # overwrite file).
      : >"$file_name" || continue
    else

      # Try to create director (mkdir will fail if directory
      # is already exists).
      mkdir "$file_name" 2>/dev/null || continue
    fi

    echo "$file_name"
    return 0

  done

  [ "$QUIET" == "no" ] || error "Cannot create temporary file after 100 attempts."
  return 1
}

arguments::parse \
    "-d|--directory)CREATE_DIR;B" \
    "-u|--dry-run)DRY_RUN;B" \
    "-q|--quiet)QUIET;B" \
    "-t|--tmpdir)USE_TMP_DIR;B" \
    "--tmpdir)TEMPORARY_DIR;S" \
    -- "${@:+$@}" || {
  error "Cannot parse mktemp command line arguments."
  mktemp::usage
  exit 1
}

[ "${#ARGUMENTS[@]}" -le 1 ] || {
  error "Incorrect number of mktemp command line arguments. Put options before template."
  mktemp::usage
  exit 1
}

main "${ARGUMENTS[@]:+${ARGUMENTS[@]}}"
exit


#>>> mktemp - implementation of mktemp in pure bash for portability.
#>>
#>> USAGE
#>>       mktemp [OPTION]... [TEMPLATE]
#>
#>  DESCRIPTION
#>       Create a temporary file or directory, safely, and print its name.
#>       TEMPLATE must contain at least 3 consecutive "X"s in last
#>       component.  If TEMPLATEis not specified, use tmp.XXXXXXXXXX, and
#>       --tmpdir is implied.
#>>
#>> OPTIONS
#>>       -h | --help
#>>              Print this help page.
#>>
#>>       --man
#>>              Show manual.
#>>
#>>       -d | --directory
#>>              create a directory, not a file
#>>
#>>       -u | --dry-run
#>>              do not create anything; merely print a name (unsafe)
#>>
#>>       -q | --quiet
#>>              suppress diagnostics about file/dir-creation failure
#>>
#>>       --suffix=SUFF
#>>              append SUFF to TEMPLATE.  SUFF must not contain slash.
#>>              This option is implied if TEMPLATE does not end in X.
#>>
#>>       -t | --tmpdir[=DIR]
#>>              interpret TEMPLATE relative to DIR.  If DIR is not
#>>              specified, use $TMPDIR if set, else /tmp.  With this
#>>              option, TEMPLATE must not be an absolute name.  TEMPLATE
#>>              may contain slashes, but mktemp creates only the final
#>>              component.
#>>
