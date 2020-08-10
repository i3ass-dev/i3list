#!/usr/bin/env bash

printlist(){

  [[ -n ${_json:=${__o[json]}} ]] \
    || _json=$(i3-msg -t get_tree)

  awk -f <(awklib)                                  \
         FS=: RS=, crit="$1" srch="$2" toprint="$3" \
         <<< "$_json"
}
