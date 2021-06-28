#!/bin/bash
. import.sh strict log

# Error handling strategy: just panic in case of an error.

xxx || panic "Cannot execute xxx."
