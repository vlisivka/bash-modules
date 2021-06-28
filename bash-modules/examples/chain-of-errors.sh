#!/bin/bash
. import.sh strict log

# Error handling strategy: print error message and return error code to
# upper layer.

foo() {
  xxx || { error "Cannot execute xxx."; return 1; }
}

bar() {
  foo || { error "Cannot perform foo."; return 1; }
}

main() {
  bar || { error "Cannot perform bar."; return 1; }
}

main "$@"
exit
