$(NF-1) ~ /"(type|id|window|name|num|x|floating|marks|layout|focused|instance|class|focus)"$/ {
  
  key=gensub(/.*"([^"]+)"$/,"\\1","g",$(NF-1))
    
  switch (key) {

    case "layout":
    case "type":
      ac[cid][key]=$NF
    break

    case "class":
    case "instance":
      ac[cid][key]=$NF
      if ( key == arg_target && match($NF, arg_search[key]) )
        suspect_targets[cid]=1
    break

    case "name":
      ac[cid][key]=$NF
      if ( key == arg_target && match($NF, arg_search[key]) )
        suspect_targets[cid]=1

      if (ac[cid]["type"] == "\"workspace\"" && $NF == "\"" i3fyra_workspace_name "\"") {
        i3fyra_workspace_id = cid
      }
    break

    case "id":
      # when "nodes": (or "floating_nodes":) and "id":
      # is on the same record.
      #   example -> "nodes":[{"id":94446734049888 
      # it is the start of a branch in the tree.
      # save the last container_id as current_parent_id
      if ($1 ~ /nodes"$/) {
        current_parent_id=cid
      } else if (NR == 1) {
        root_id=$NF
      }


      # cid, "current id" is the last seen container_id
      cid=$NF
      ac[cid][key]=$NF

      if ( key == arg_target && match($NF, arg_search[key]) )
        suspect_targets[cid]=1
    break

    case "x":

      if ($1 ~ /"(deco_)?rect"/) {
        # this will add values to:
        #   ac[cid]["x"] , ["y"] , ["w"] , ["h"]
        #   ac[cid]["deco_x"] , ["deco_y"] , ["deco_w"] , ["deco_h"]
        keyprefix=($1 ~ /"deco_rect"/ ? "deco_" : "")
        while (1) {

          match($0,/"([^"])[^"]*":([0-9]+)([}])?$/,ma)
          ac[cid][keyprefix ma[1]]=ma[2]
          if (ma[3] ~ "}")
            break
          # break before getline, otherwise we will
          # miss the "deco_rect" line..
          getline
        }
      }

    break

    case "num":
      ac[cid][key]=$NF
      cwsid=cid # current workspace id

      if (cid == i3fyra_workspace_id)
        i3fyra_workspace_num=$NF
    break

    case "focused":
      if ($NF == "true") {
        active_container_id=cid
        active_workspace_id=cwsid
      }
      ac[cid]["workspace"]=cwsid
      ac[cid]["parent"]=current_parent_id
    break

    case "window":
      if ($NF != "null") {
        ac[cid]["window"]=$NF
        if ( key == arg_target && match($NF, arg_search[key]) )
          suspect_targets[cid]=1
      }
    break

    case "floating":
      ac[cid]["floating"]=($NF ~ /_on"$/ ? 1 : 0)
    break

    case "focus":
      if ($2 != "[]") {
        # a not empty focus list is the first thing
        # we encounter after a branch. The first
        # item of the list is the focused container
        # which is of interest if the container is
        # tabbed or stacked, where only the focused container
        # is visible.
        first_id=gensub(/[^0-9]/,"","g",$2)
        parent_id=ac[first_id]["parent"]
        ac[parent_id]["focused"]=first_id

        # this restores current_parent_id  and cid 
        # to what it was before this branch.
        cid=parent_id
        current_parent_id=ac[parent_id]["parent"]
      }
    break

    case "marks":

      if ($NF == "[]")
        break

      if ( key == arg_target && match($NF, arg_search[key]) )
        suspect_targets[cid]=1

      else if ( match($NF,/"i34([ABCD])"/,ma) ) {
        fyra_containers[ma[1]]["id"]=cid
        fyra_containers[ma[1]]["workspace"]=cwsid
        ac[cid]["i3fyra_mark"]=ma[1]

        if (ac[cwsid]["num"] != -1) {
          fyra_containers[ma[1]]["visible"]=1
          fyra_containers[ma[1]]["family"]=current_fyra_family
        }
      }

      else if ( match($NF,/"i34X([ABCD]{2})"/,ma) ) {
        fyra_splits[ma[1]]=cid
        current_fyra_family=ma[1]
        fyra_vars["X" ma[1]]=ac[cwsid]["num"]
      }

      # marks set by i3var all are at the root_id.
      # all that are related to i3fyra has i34 prefix
      
      # "marks":["i34MAC=157"
      # "i34MAB=1570"
      # "i34MBD=252"
      # "i34FAC=X"
      # "i34FBD=X"
      # "hidden93845635698816="]
      else if (cid == root_id) {
        while (1) {
          match($0,/"(i34)?([^"=]+)=([^"]*)"([]])?$/,ma)

          if (ma[2] == "i3fyra_ws") {
            i3fyra_workspace_name=ma[3]
          }
          else if (ma[1] == "i34")
            fyra_vars[ma[2]]=ma[3]
          if (ma[4] ~ "]")
            break

          getline
        }
      }

    break
  }
}
