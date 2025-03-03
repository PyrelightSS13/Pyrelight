/datum/fabricator_recipe/pipe/device
	category = "Devices"
	colorable = FALSE
	pipe_color = PIPE_COLOR_WHITE

	name = "connector"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "connector"
	constructed_path = /obj/machinery/atmospherics/portables_connector
	pipe_class = PIPE_CLASS_UNARY
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/device/adapter
	name = "universal pipe adapter"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_HE
	build_icon_state = "universal"
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/universal
	pipe_class = PIPE_CLASS_BINARY
	rotate_class = PIPE_ROTATE_TWODIR

/datum/fabricator_recipe/pipe/device/unaryvent
	name = "unary vent"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_FUEL
	build_icon_state = "uvent"
	constructed_path = /obj/machinery/atmospherics/unary/vent_pump
	pipe_class = PIPE_CLASS_UNARY

/datum/fabricator_recipe/pipe/device/unaryvent/large
	name = "high volume unary vent"
	constructed_path = /obj/machinery/atmospherics/unary/vent_pump/high_volume

/datum/fabricator_recipe/pipe/device/gaspump
	name = "gas pump"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "pump"
	constructed_path = /obj/machinery/atmospherics/binary/pump
	pipe_class = PIPE_CLASS_BINARY

/datum/fabricator_recipe/pipe/device/pressureregulator
	name = "pressure regulator"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "passivegate"
	constructed_path = /obj/machinery/atmospherics/binary/passive_gate
	pipe_class = PIPE_CLASS_BINARY

/datum/fabricator_recipe/pipe/device/hpgaspump
	name = "high powered gas pump"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "volumepump"
	constructed_path = /obj/machinery/atmospherics/binary/pump/high_power
	pipe_class = PIPE_CLASS_BINARY

/datum/fabricator_recipe/pipe/device/scrubber
	name = "scrubber"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER
	build_icon_state = "scrubber"
	constructed_path = /obj/machinery/atmospherics/unary/vent_scrubber
	pipe_class = PIPE_CLASS_UNARY

/datum/fabricator_recipe/pipe/device/meter
	name = "meter"
	path = /obj/item/machine_chassis/pipe_meter
	pipe_color = null
	connect_types = null
	colorable = FALSE
	build_icon_state = "meter"
	constructed_path = /obj/machinery/meter
	pipe_class = PIPE_CLASS_OTHER

/datum/fabricator_recipe/pipe/device/omnimixer
	name = "omni gas mixer"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "omni_mixer"
	constructed_path = /obj/machinery/atmospherics/omni/mixer
	pipe_class = PIPE_CLASS_OMNI

/datum/fabricator_recipe/pipe/device/omnifilter
	name = "omni gas filter"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "omni_filter"
	constructed_path = /obj/machinery/atmospherics/omni/filter
	pipe_class = PIPE_CLASS_OMNI

/datum/fabricator_recipe/pipe/device/manualvalve
	name = "manual valve"
	build_icon_state = "mvalve"
	constructed_path = /obj/machinery/atmospherics/valve
	pipe_class = PIPE_CLASS_BINARY
	rotate_class = PIPE_ROTATE_TWODIR
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL

/datum/fabricator_recipe/pipe/device/digitalvalve
	name = "digital valve"
	build_icon_state = "dvalve"
	constructed_path = /obj/machinery/atmospherics/valve/digital
	pipe_class = PIPE_CLASS_BINARY
	rotate_class = PIPE_ROTATE_TWODIR
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL

/datum/fabricator_recipe/pipe/device/autoshutoff
	name = "automatic shutoff valve"
	build_icon_state = "svalve"
	constructed_path = /obj/machinery/atmospherics/valve/shutoff
	pipe_class = PIPE_CLASS_BINARY
	rotate_class = PIPE_ROTATE_TWODIR
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL

/datum/fabricator_recipe/pipe/device/mtvalve
	name = "manual t-valve"
	build_icon_state = "mtvalve"
	constructed_path = /obj/machinery/atmospherics/tvalve
	pipe_class = PIPE_CLASS_TRINARY
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL

/datum/fabricator_recipe/pipe/device/mtvalvem
	name = "manual t-valve (mirrored)"
	build_icon_state = "mtvalvem"
	constructed_path = /obj/machinery/atmospherics/tvalve/mirrored
	pipe_class = PIPE_CLASS_TRINARY
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL

/datum/fabricator_recipe/pipe/device/dtvalve
	name = "digital t-valve"
	build_icon = 'icons/atmos/digital_tvalve.dmi'
	build_icon_state = "map_tvalve0"
	constructed_path = /obj/machinery/atmospherics/tvalve/digital
	pipe_class = PIPE_CLASS_TRINARY
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL

/datum/fabricator_recipe/pipe/device/dtvalvem
	name = "digital t-valve (mirrored)"
	build_icon = 'icons/atmos/digital_tvalve.dmi'
	build_icon_state = "map_tvalvem0"
	constructed_path = /obj/machinery/atmospherics/tvalve/mirrored/digital
	pipe_class = PIPE_CLASS_TRINARY
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL

/datum/fabricator_recipe/pipe/device/air_sensor
	name = "gas sensor"
	path = /obj/item/machine_chassis/air_sensor
	build_icon_state = "gsensor1"
	build_icon = 'icons/obj/machines/gas_sensor.dmi'
	pipe_color = null
	connect_types = null
	colorable = FALSE
	constructed_path = /obj/machinery/air_sensor
	pipe_class = PIPE_CLASS_OTHER

/datum/fabricator_recipe/pipe/device/outlet_injector
	name = "injector outlet"
	build_icon = 'icons/atmos/injector.dmi'
	build_icon_state = "map_injector"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	colorable = FALSE
	pipe_color = null
	constructed_path = /obj/machinery/atmospherics/unary/outlet_injector
	pipe_class = PIPE_CLASS_UNARY

/datum/fabricator_recipe/pipe/device/drain
	name = "gutter"
	build_icon = 'icons/obj/drain.dmi'
	build_icon_state = "drain"
	path = /obj/item/drain
	connect_types = null
	colorable = FALSE
	pipe_color = null
	constructed_path = /obj/structure/hygiene/drain
	pipe_class = PIPE_CLASS_OTHER

/datum/fabricator_recipe/pipe/device/drain/bath
	name = "sealable gutter"
	build_icon = 'icons/obj/drain.dmi'
	build_icon_state = "drain_bath"
	path = /obj/item/drain/bath
	connect_types = null
	colorable = FALSE
	pipe_color = null
	constructed_path = /obj/structure/hygiene/drain/bath
	pipe_class = PIPE_CLASS_OTHER

/datum/fabricator_recipe/pipe/device/tank
	name = "pressure tank"
	build_icon = 'icons/atmos/tank.dmi'
	build_icon_state = "air"
	path = /obj/item/pipe/tank
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	constructed_path = /obj/machinery/atmospherics/unary/tank
	pipe_class = PIPE_CLASS_UNARY
	colorable = TRUE

/datum/fabricator_recipe/pipe/device/plate
	name = "thermal plate"
	build_icon = 'icons/obj/atmospherics/cold_sink.dmi'
	build_icon_state = "exposed"
	path = /obj/item/pipe
	connect_types = CONNECT_TYPE_REGULAR
	constructed_path = /obj/machinery/atmospherics/unary/thermal_plate
	pipe_class = PIPE_CLASS_UNARY

/datum/fabricator_recipe/pipe/device/igniter
	name = "igniter"
	build_icon = 'icons/obj/machines/igniter.dmi'
	build_icon_state = "igniter1"
	path = /obj/item/machine_chassis/igniter
	pipe_color = null
	connect_types = null
	colorable = FALSE
	constructed_path = /obj/machinery/igniter
	pipe_class = PIPE_CLASS_OTHER
