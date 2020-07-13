#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
i3list - version: 0.179
updated: 2020-07-13 by budRich
EOB
}




___printhelp(){
  
cat << 'EOB' >&2
i3list - list information about the current i3 session.


SYNOPSIS
--------
i3list [--json FILE]
i3list --instance|-i TARGET [--json FILE]
i3list --class|-c    TARGET [--json FILE]
i3list --conid|-n    TARGET [--json FILE]
i3list --winid|-d    TARGET [--json FILE]
i3list --mark|-m     TARGET [--json FILE]
i3list --title|-t    TARGET [--json FILE]
i3list --help|-h
i3list --version|-v

OPTIONS
-------

--json FILE  

--instance|-i TARGET  
Search for windows with a instance matching
TARGET


--class|-c TARGET  
Search for windows with a class matching TARGET


--conid|-n TARGET  
Search for windows with a CON_ID matching TARGET


--winid|-d TARGET  
Search for windows with a WINDOW_ID matching
TARGET


--mark|-m TARGET  
Search for windows with a mark matching TARGET


--title|-t TARGET  
Search for windows with a title matching TARGET  

--help|-h  
Show help and exit.


--version|-v  
Show version and exit.

EOB
}


for ___f in "${___dir}/lib"/*; do
  source "$___f"
done

declare -A __o
options="$(
  getopt --name "[ERROR]:i3list" \
    --options "i:c:n:d:m:t:hv" \
    --longoptions "json:,instance:,class:,conid:,winid:,mark:,title:,help,version," \
    -- "$@" || exit 98
)"

eval set -- "$options"
unset options

while true; do
  case "$1" in
    --json       ) __o[json]="${2:-}" ; shift ;;
    --instance   | -i ) __o[instance]="${2:-}" ; shift ;;
    --class      | -c ) __o[class]="${2:-}" ; shift ;;
    --conid      | -n ) __o[conid]="${2:-}" ; shift ;;
    --winid      | -d ) __o[winid]="${2:-}" ; shift ;;
    --mark       | -m ) __o[mark]="${2:-}" ; shift ;;
    --title      | -t ) __o[title]="${2:-}" ; shift ;;
    --help       | -h ) ___printhelp && exit ;;
    --version    | -v ) ___printversion && exit ;;
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" 




