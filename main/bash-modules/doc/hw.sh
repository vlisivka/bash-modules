#!/bin/bash
. import.sh log arguments

NAME="world"

parse_arguments "-n|--name)NAME;S" -- "$@" || exit $?

info "Hello, $NAME!"

if (( ${#ARGUMENTS[@]} > 0))
then
  for ARG in "${ARGUMENTS[@]}"
  do
    info "Hello, $ARG, too!"
  done
fi

exit 0

__END__

=pod

=head1 NAME

hw.sh - program for greeting

=head1 SYNOPSIS

hw.sh [OPTIONS] [--] [ARGUMENTS]

=head1 OPTIONS

=over 4

=item B<--help> | B<-h>

Print a brief help message and exit.

=item B<--man>

Show manual page.

=item B<--debug>

Enable debugging features, like backtrace and debugging messages.

=item B<--name> NAME

Greet a NAME. Default value: "world".

=back

Unlike many other programs, this program stops option parsing at first
non-option argument.

Use -- in commandline arguments to strictly separate options and arguments.

=head1 ARGUMENTS

Additional names to greet.

=head1 DESCRIPTION

Example how to greet a someone properly using bash-modules.

=head1 SEE ALSO

bash-modules

=head1 AUTHOUR

Volodymyr M. Lisivka <vlisivka@gmail.com>

=cut
