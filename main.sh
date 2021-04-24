#!/usr/bin/env bash

main(){

  [[ -n ${_json:=${__o[json]}} ]] \
    || _json=$(i3-msg -t get_tree)

  awk -f <(
    echo "
    BEGIN {
      ${__o[instance]:+
        arg_target=\"instance\"
        arg_search[arg_target]=\"${__o[instance]}\"
      }
      ${__o[class]:+
        arg_target=\"class\"
        arg_search[arg_target]=\"${__o[class]}\"
      }
      ${__o[conid]:+
        arg_target=\"id\"
        arg_search[arg_target]=\"${__o[conid]}\"
      }
      ${__o[winid]:+
        arg_target=\"window\"
        arg_search[arg_target]=\"${__o[winid]}\"
      }
      ${__o[mark]:+
        arg_target=\"marks\"
        arg_search[arg_target]=\"${__o[mark]}\"
      }
      ${__o[title]:+
        arg_target=\"name\"
        arg_search[arg_target]=\"${__o[title]}\"
      }
    }"
    awklib
  ) FS=: RS=, <<< "$_json"

  
}





___source="$(readlink -f "${BASH_SOURCE[0]}")"  #bashbud
___dir="${___source%/*}"                        #bashbud
source "$___dir/init.sh"                        #bashbud
main "$@"                                       #bashbud
