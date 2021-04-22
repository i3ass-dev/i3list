END {

  # determine target container ID
  if ( !arg_target ) {
    target_container_id=active_container_id
  } else {

    for (suspect_id in suspect_targets) {

      search_match=0

      for (search in arg_search) {
        if (ac[suspect_id][search] ~ arg_search[search])
          search_match+=1
      }

      if (search_match == length(arg_search)) {
        target_container_id=suspect_id
        break
      }
    }
  }

  # initiate i3fyra values

  if (main_split ~ /AB|AC/) {

    if (main_split == "AB") {
      fyra_vars["LAL"]="ACBD"
      orientation="horizontal"

      # SAB - main split size
      if (fyra_containers["A"]["visible"]) {
        fyra_vars["SAB"]=ac[fyra_containers["A"]["id"]]["w"]
      }
      else if (fyra_containers["C"]["visible"])
        fyra_vars["SAB"]=ac[fyra_containers["C"]["id"]]["w"]
      else
        fyra_vars["SAB"]=0

      if (fyra_vars["SAB"] == ac[i3fyra_workspace_id]["w"])
        fyra_vars["SAB"]=0
    }

    else if (main_split == "AC") {
      orientation="horizontal"
      fyra_vars["LAL"]="ABCD"

      # SAC - main split size
      if (fyra_containers["A"]["visible"])
        fyra_vars["SAC"]=ac[fyra_containers["A"]["id"]]["h"]
      else if (fyra_containers["B"]["visible"])
        fyra_vars["SAC"]=ac[fyra_containers["B"]["id"]]["h"]
      else
        fyra_vars["SAC"]=0

      if (fyra_vars["SAC"] == ac[i3fyra_workspace_id]["h"])
        fyra_vars["SAC"]=0
    }
  }

  descriptions()
  strfrm="i3list[%s]=%-17s# %s\n"

  ### -- ACTIVE CONTAINER STUFF

  print_window("A",active_container_id)
  print ""

  if (main_split ~ /AB|AC/) {
    parent_id=ac[active_container_id]["parent"]
    awp=ac[parent_id]["i3fyra_mark"]

    if (awp) {
      print_fyra_window("A",active_container_id,awp)
      print ""
    }

  }

  print_workspace("A",active_workspace_id)
  print ""

  if (target_container_id) {
    target_workspace_id=ac[target_container_id]["workspace"]
    print_window("T",target_container_id)
    print ""

    if (main_split ~ /AB|AC/) {
      parent_id=ac[target_container_id]["parent"]
      twp=ac[parent_id]["i3fyra_mark"]

      if (twp) {
        print_fyra_window("T",target_container_id,twp)
        print ""
      }

    }

    print_workspace("T",target_workspace_id)
    print ""
  }
  
  ### -- I3FYRA STUFF
  if (main_split ~ /AB|AC/) {
    print_workspace("F",i3fyra_workspace_id)
    print ""

    for (container_name in fyra_containers) {
      container_id=fyra_containers[container_name]["id"]
      output_id=outputs[ac[container_id]["output"]]
      workspace_id=fyra_containers[container_name]["workspace"]

      key="C" container_name "L"; printf(strfrm,key, ac[container_id]["layout"], desc[key])
      key="C" container_name "W"; printf(strfrm,key, ac[workspace_id]["num"], desc[key])

      focused=ac[container_id]["focused"]
      # make sure the focused container is a window
      while (!("window" in ac[focused]))
        focused=ac[focused]["focused"]

      key="C" container_name "F"; printf(strfrm,key, focused, desc[key])

      if (fyra_containers[container_name]["visible"])
        LVI=LVI container_name
      else 
        LHI=LHI container_name
    }
    
    key="LVI"; printf(strfrm,key, LVI, desc[key])
    key="LHI"; printf(strfrm,key, LHI, desc[key])
    key="LEX"; printf(strfrm,key, LVI LHI, desc[key])

    for (family in fyra_splits) {

      first=substr(family,1,1)

      split(family,split_childs,"")
      first_id=fyra_containers[first]["id"]

      if ( orientation == "horizontal"       && 
           fyra_containers[first]["visible"] &&
           ac[first_id]["h"] != ac[i3fyra_workspace_id]["h"] )
        family_split_size=ac[first_id]["h"]

      else if ( orientation == "vertical"         && 
                fyra_containers[first]["visible"] &&
                ac[first_id]["w"] != ac[i3fyra_workspace_id]["w"] )
        family_split_size=ac[first_id]["w"]

      else
        family_split_size=0

      key="S" family; printf(strfrm, key, family_split_size, desc[key])
    }

    print ""
    for (key in fyra_vars) {
      printf(strfrm, key, fyra_vars[key], desc[key])
    }
  }
}
