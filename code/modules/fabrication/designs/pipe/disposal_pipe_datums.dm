/datum/fabricator_recipe/pipe/disposal_dispenser
	pipe_color = null
	connect_types = null
	colorable = FALSE
	constructed_path = /obj/structure/disposalpipe/segment
	category = "Disposal Pipes"
	var/turn = DISPOSAL_FLIP_FLIP

	name = "disposal pipe segment"
	build_icon = 'icons/obj/pipes/disposal_pipe.dmi'
	build_icon_state = "pipe-s"
	path = /obj/structure/disposalconstruct
	fabricator_types = list(
		FABRICATOR_CLASS_DISPOSAL
	)

/datum/fabricator_recipe/pipe/disposal_dispenser/bent
	name = "bent disposal pipe segment"
	build_icon_state = "pipe-c"
	turn = DISPOSAL_FLIP_RIGHT
	constructed_path = /obj/structure/disposalpipe/segment/bent

/datum/fabricator_recipe/pipe/disposal_dispenser/junction
	name = "disposal pipe junction"
	build_icon_state = "pipe-j1"
	turn = DISPOSAL_FLIP_RIGHT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/junction

/datum/fabricator_recipe/pipe/disposal_dispenser/junctionm
	name = "disposal pipe junction (mirrored)"
	build_icon_state = "pipe-j2"
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/junction/mirrored

/datum/fabricator_recipe/pipe/disposal_dispenser/yjunction
	name = "disposal pipe y-junction"
	build_icon_state = "pipe-y"
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_RIGHT
	constructed_path = /obj/structure/disposalpipe/junction

/datum/fabricator_recipe/pipe/disposal_dispenser/trunk
	name = "disposal pipe trunk"
	build_icon_state = "pipe-t"
	constructed_path = /obj/structure/disposalpipe/trunk
	turn = DISPOSAL_FLIP_NONE

/datum/fabricator_recipe/pipe/disposal_dispenser/up
	name = "disposal pipe upwards segment"
	build_icon_state = "pipe-u"
	constructed_path = /obj/structure/disposalpipe/up
	turn = DISPOSAL_FLIP_NONE

/datum/fabricator_recipe/pipe/disposal_dispenser/down
	name = "disposal pipe downwards segment"
	build_icon_state = "pipe-d"
	constructed_path = /obj/structure/disposalpipe/down
	turn = DISPOSAL_FLIP_NONE

/datum/fabricator_recipe/pipe/disposal_dispenser/device
	name = "disposal bin"
	build_icon = 'icons/obj/pipes/disposal_bin.dmi'
	build_icon_state = "disposal"
	path = /obj/structure/disposalconstruct/machine
	constructed_path = /obj/machinery/disposal
	turn = DISPOSAL_FLIP_NONE

/datum/fabricator_recipe/pipe/disposal_dispenser/device/outlet
	name = "disposal outlet"
	build_icon = 'icons/obj/pipes/disposal_outlet.dmi'
	build_icon_state = "outlet"
	path = /obj/structure/disposalconstruct/machine/outlet
	constructed_path = /obj/structure/disposaloutlet

/datum/fabricator_recipe/pipe/disposal_dispenser/device/chute
	name = "disposal chute"
	build_icon = 'icons/obj/pipes/disposal_chute.dmi'
	build_icon_state = "chute"
	constructed_path = /obj/machinery/disposal/deliveryChute
	path = /obj/structure/disposalconstruct/machine/chute

/datum/fabricator_recipe/pipe/disposal_dispenser/device/sorting
	name = "disposal sorter"
	build_icon_state = "pipe-j1s"
	turn = DISPOSAL_FLIP_RIGHT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction
	path = /obj/structure/disposalconstruct

/datum/fabricator_recipe/pipe/disposal_dispenser/device/sorting/wildcard
	name = "wildcard disposal sorter"
	build_icon_state = "pipe-j1s"
	turn = DISPOSAL_FLIP_RIGHT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/wildcard
	path = /obj/structure/disposalconstruct

/datum/fabricator_recipe/pipe/disposal_dispenser/device/sorting/untagged
	name = "untagged disposal sorter"
	build_icon_state = "pipe-j1s"
	turn = DISPOSAL_FLIP_RIGHT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/untagged
	path = /obj/structure/disposalconstruct

/datum/fabricator_recipe/pipe/disposal_dispenser/device/sortingm
	name = "disposal sorter (mirrored)"
	build_icon_state = "pipe-j2s"
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/flipped
	path = /obj/structure/disposalconstruct

/datum/fabricator_recipe/pipe/disposal_dispenser/device/sorting/wildcardm
	name = "wildcard disposal sorter (mirrored)"
	build_icon_state = "pipe-j2s"
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/wildcard/flipped
	path = /obj/structure/disposalconstruct

/datum/fabricator_recipe/pipe/disposal_dispenser/device/sorting/untaggedm
	name = "untagged disposal sorter (mirrored)"
	build_icon_state = "pipe-j2s"
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/untagged/flipped
	path = /obj/structure/disposalconstruct

/datum/fabricator_recipe/pipe/disposal_dispenser/device/tagger
	name = "disposal tagger"
	build_icon_state = "pipe-tagger"
	turn = DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/tagger
	path = /obj/structure/disposalconstruct

/datum/fabricator_recipe/pipe/disposal_dispenser/device/tagger/partial
	name = "disposal partial tagger"
	build_icon_state = "pipe-tagger-partial"
	turn = DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/tagger/partial
	path = /obj/structure/disposalconstruct

/datum/fabricator_recipe/pipe/disposal_dispenser/device/diversion
	name = "disposal diverter"
	build_icon_state = "pipe-j1s"
	turn = DISPOSAL_FLIP_FLIP | DISPOSAL_FLIP_RIGHT
	constructed_path = /obj/structure/disposalpipe/diversion_junction
	path = /obj/structure/disposalconstruct