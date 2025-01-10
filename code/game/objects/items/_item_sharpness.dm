/obj/item
	var/_sharp = FALSE
	var/_edge = FALSE

/obj/item/is_sharp()
	return _sharp

/obj/item/has_edge()
	return _edge

/obj/item/proc/set_edge(new_edge)
	if(_edge != new_edge)
		_edge = new_edge
		return TRUE
	return FALSE

/obj/item/proc/set_sharp(new_sharp)
	if(_sharp != new_sharp)
		_sharp = new_sharp
		return TRUE
	return FALSE
