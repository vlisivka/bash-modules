#!/bin/sh

set -eux

homedir=/usr/share/bash-modules
_bindir=/usr/bin

mkdir -p "$homedir"
install -t "$homedir" src/bash-modules/*.sh
