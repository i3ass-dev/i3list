#!/usr/bin/env bash

printlist(){

  awk -f <(awklib) \
    FS=: RS=, crit="$1" srch="$2" toprint="$3" \
    <(
      if [[ -f ${__o[json]} ]]; then
        cat "${__o[json]}"
      else
        i3-msg -t get_tree
      fi
    )
}
