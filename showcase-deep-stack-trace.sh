#!/bin/bash
. import.sh strict log
a() {
  b
}
b() {
  c
}
c() {
  d
}
d() {
  false
}

a
