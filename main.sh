#!/usr/bin/env bash

main(){

  local crit srch

  if [[ -z ${__o[*]} ]]; then
    crit=X srch=X
  elif [[ -n ${srch:=${__o[instance]}} ]]; then
    crit="instance"
  elif [[ -n ${srch:=${__o[class]}} ]]; then
    crit="class"
  elif [[ -n ${srch:=${__o[conid]}} ]]; then
    crit="id"
  elif [[ -n ${srch:=${__o[winid]}} ]]; then
    crit="window"
  elif [[ -n ${srch:=${__o[mark]}} ]]; then
    crit="marks"
  elif [[ -n ${srch:=${__o[title]}} ]]; then
    crit="title"
  else
    crit=X srch=X
  fi

  toprint="${1:-all}"
  printlist "$crit" "$srch" "$toprint"
  
}

___source="$(readlink -f "${BASH_SOURCE[0]}")"  #bashbud
___dir="${___source%/*}"                        #bashbud
source "$___dir/init.sh"                        #bashbud
main "$@"                                       #bashbud
