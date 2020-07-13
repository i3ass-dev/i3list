#!/bin/env bash

set -E
trap '[ "$?" -ne 98 ] || exit 98' ERR

ERX() { echo  "[ERROR] $*" >&2 ; exit 98 ;}
ERR() { echo  "[WARNING] $*" >&2 ;}
ERM() { echo  "$*" >&2 ;}
