#!/bin/sh

set -eux

homedir=/usr/share/bash-modules
_bindir=/usr/bin

install -D src/import.sh "$_bindir/import.sh"

mkdir -p "$homedir"
install -t "$homedir" src/bash-modules/*.sh
