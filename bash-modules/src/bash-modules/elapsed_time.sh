##!/bin/bash
# Copyright (c) 2009-2021 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
# License: LGPL2+

#>>> elapsed_time - print elapsed time since shell script start in human readable form.

#>>
#>> Functions:

#>>
#>> * elapsed_time::print - print value of SECONDS variable in human readable form: "Elapsed time: 0 days 00:00:00."
#>> Assign 0 to SECONDS variable to reset counter.
elapsed_time::print() {
  printf "Elapsed time: %d days %02d:%02d:%02d.\n" $((SECONDS/(24*60*60))) $(((SECONDS/(60*60))%24)) $(((SECONDS/60)%60)) $((SECONDS%60))
}
