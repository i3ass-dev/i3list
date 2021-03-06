hit && /[{]/ {hit++}
hit && /[}]/ {hit--}

$1 ~ /"rect"/ && dimget != "workspace" {dimget="window"}
$1 ~ /"deco_rect"/ {dimget="tab"}

$(NF-1) ~ /"(focus|id|window|name|num|width|height|x|y|floating|marks|layout|focused|instance|class|title)"$/ {
  
  key=gensub(/.*"([^"]+)"$/,"\\1","g",$(NF-1))
  var=gensub(/[["]*([^]}"]+)[]}"]*$/,"\\1","g",$NF)

  if (key == crit && !trg && var ~ srch) {
    if (key=="id") {curcid=var}
    window["T"]["TWC"]=curcid
    trg=1
  }

  switch (key) {
    case "focus":
      if (hit) {
        container["C"curcon"F"]=var
      } else {
        # define active workspace by id
        # (only useful when workspace is empty)
        for (w in aws) 
          if (var == w) { setworkspace(w,"A") }
      }
    break

    case "window":
      curwid=var
    break

    case "name":
      curnam=var
    break

    case "num":
      aws[curcid]["num"]=curws=var
      aws[curcid]["name"]=curwsnam=curnam
      curwsid=curcid
    break

    case /^(width|height|x|y)$/ :

      if (dimget) {
        dim[curcid][dimget][key]=var
      }

      if (key == "height") {dimget=0}

    break

    case "id":
      curcid=var
      if (hit) {conta[curcon]["id"]=curcid}
    break

    case "floating":
      if (curcid == window["A"]["AWC"] && act != 2) {
        setwindow(var,"A")
        act=2
      }

      if (curcid == window["T"]["TWC"] && trg != 2) {
        setwindow(var,"T")
        trg=2
      }
    break

    case "marks":

      if (var ~ /^i34[ABCD]$/) {
        hit=1
        curcon=substr(var,4,1)
        container["C"curcon"W"]=curws
        container["C"curcon"L"]="-"
        acon[curcon]=curcid
      }


      else if (match(var,/^i34X(.+)/,splitmark)) {
        # if mainsplit (splits[3]) container exist
        # curcid is id of fyra workspace (WFI)
        if (splitmark[1] == splits[3]) {
          WFI=curcid
        } 
        
        layout["X" splitmark[1]]=curws  
      }

      else if (match(var,/^i34([FM].{2})=(.*)/,splitmark)) {
        memory[splitmark[1]]=splitmark[2]
      }

      else if (match(var,/^i34(VP[ABCD])=(.*)/,splitmark)) {
        memory[splitmark[1]]=splitmark[2]
      }

    break

    case "layout":
      if (hit!=0 && container["C"curcon"L"]=="-") {
        container["C"curcon"L"]=var
      }
    break

    case "focused":
      if (var == "true") {
        window["A"]["AWC"]=curcid
        act=1
      }
    break

  }
}
