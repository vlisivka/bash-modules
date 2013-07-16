#!/bin/sh

set -eux

homedir=/usr/share/bash-modules

mkdir -p "$homedir"
install -t "$homedir" src/bash-modules/*.sh
