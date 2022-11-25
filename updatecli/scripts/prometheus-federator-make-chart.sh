#!/bin/bash

set -eux

unset PACKAGE; PACKAGE=prometheus-federator make charts >&2

git diff

exit 0

