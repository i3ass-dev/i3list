function print_window(t, container_id, key) {
  key=t "WC"; printf(strfrm,key, container_id, desc[key])
  key=t "WF"; printf(strfrm,key, ac[container_id]["floating"], desc[key])
  key=t "WI"; printf(strfrm,key, ac[container_id]["window"], desc[key])
  key=t "WW"; printf(strfrm,key, ac[container_id]["h"], desc[key])
  key=t "WH"; printf(strfrm,key, ac[container_id]["w"], desc[key])
  key=t "WX"; printf(strfrm,key, ac[container_id]["x"], desc[key])
  key=t "WY"; printf(strfrm,key, ac[container_id]["y"], desc[key])
  key=t "WB"; printf(strfrm,key, ac[container_id]["deco_h"], desc[key])
  key=t "TX"; printf(strfrm,key, ac[container_id]["deco_x"], desc[key])
  key=t "TW"; printf(strfrm,key, ac[container_id]["deco_w"], desc[key])
}

