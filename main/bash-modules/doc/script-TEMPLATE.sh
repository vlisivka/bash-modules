#!/bin/bash
# TODO: SHORT DESCRIPTION
# TODO: AUTHOR YEAR
# TODO: LICENSE

# Example:
# ./TEMPLATE.sh --debug --foo --bar="bar" --baz=baz1 -B baz2 --baz baz3 --inc -i -i -- --inc blah

# Treat unset variables as an error when substituting.
# Exit immediately if a command exits with a non-zero status.
set -ue

# See import.sh --usage MODULE
. import.sh log arguments

# Various settings
FOO="no"
BAR=""
BAZ=( )
INC=0

# Global variables
EXIT_CODE=0

# Main logic of this script
main() {

  todo "Implement your logic here."

  info "Is --foo option used?: $FOO"
  info "Value of --bar option: \"$BAR\"."

  info "Baz count: ${#BAZ[@]}."
  local I IND=0
  for I in "${BAZ[@]:+${BAZ[@]}}"
  do
    let IND++
    info "Baz #$IND: \"$I\"."
  done

  if [ "$INC" -gt 0 ]
  then
    info "--inc option used $INC times."
  else
    warn "--inc option is not used at all."
  fi

  info "Arguments count: ${#ARGUMENTS[@]}."
  local I IND=0
  for I in "${ARGUMENTS[@]:+${ARGUMENTS[@]}}"
  do
    let IND++
    info "Argument #$IND: \"$I\"."
  done
}

# Parse arguments
parse_arguments "-f|--foo)FOO;B" "-b|--bar)BAR;S" "-B|--baz)BAZ;A" "-i|--inc)INC;I" -- "${@}" || exit $?
debug "Arguments: \"$@\"."

# Invoke main logic
main "${ARGUMENTS[@]:+${ARGUMENTS[@]}}" || EXIT_CODE=$?

exit $EXIT_CODE

__END__

=pod

=head1 NAME

TEMPLATE.sh - TODO: short description

=head1 SYNOPSIS

TEMPLATE.sh [OPTIONS] [--] [ARGUMENTS]

=head1 OPTIONS

=over 4

=item B<--help> | B<-h>

Print a brief help message and exit.

=item B<--man>

Show manual page.

=item B<--debug>

Enable debugging features, like backtrace and debugging messages.

=back

Unlike many other programs, this program stops option parsing at first
non-option argument.

Use -- in commandline arguments to strictly separate options and arguments.

=head1 ARGUMENTS

TODO: describe your arguments.

=head1 DESCRIPTION

TODO: Write description of the program here.

=head1 SEE ALSO

TODO

=head1 AUTHOUR

TODO: Put YOUR NAME here.

=cut
