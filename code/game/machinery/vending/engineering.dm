/obj/machinery/vending/tool
	name = "YouTool"
	desc = "Tools for tools."
	markup = 0
	icon = 'icons/obj/machines/vending/tool.dmi'
	vend_delay = 11
	base_type = /obj/machinery/vending/tool
	products = list(
		/obj/item/stack/cable_coil/random = 10,
		/obj/item/crowbar = 5,
		/obj/item/weldingtool = 3,
		/obj/item/wirecutters = 5,
		/obj/item/wrench = 5,
		/obj/item/scanner/gas = 5,
		/obj/item/t_scanner = 5,
		/obj/item/screwdriver = 5,
		/obj/item/flashlight/flare/glowstick = 3,
		/obj/item/flashlight/flare/glowstick/red = 3,
		/obj/item/stack/tape_roll/duct_tape = 8,
		/obj/item/clothing/gloves/insulated/cheap = 2
	)
	contraband = list(
		/obj/item/weldingtool/hugetank = 2,
		/obj/item/clothing/gloves/insulated = 1
	)

/obj/machinery/vending/engivend
	name = "Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon = 'icons/obj/machines/vending/engivend.dmi'
	markup = 0
	vend_delay = 21
	base_type = /obj/machinery/vending/engivend
	initial_access = list(access_atmospherics, access_engine_equip)
	products = list(
		/obj/item/clothing/glasses/meson = 2,
		/obj/item/multitool = 4,
		/obj/item/geiger = 4,
		/obj/item/stock_parts/circuitboard/airlock_electronics = 10,
		/obj/item/frame/apc/kit = 10,
		/obj/item/frame/air_alarm/kit = 10,
		/obj/item/cell = 10,
		/obj/item/belt/utility
	)
	contraband = list(/obj/item/cell/high = 3)

//This one's from bay12
/obj/machinery/vending/engineering
	name = "Robco Tool Maker"
	desc = "Everything you need for do-it-yourself repair."
	icon = 'icons/obj/machines/vending/engivend.dmi'
	base_type = /obj/machinery/vending/engineering
	markup = 0
	initial_access = list(access_atmospherics, access_engine_equip)
	products = list(
		/obj/item/belt/utility = 4,
		/obj/item/clothing/glasses/meson = 4,
		/obj/item/clothing/gloves/insulated = 4,
		/obj/item/screwdriver = 12,
		/obj/item/crowbar = 12,
		/obj/item/wirecutters = 12,
		/obj/item/multitool = 12,
		/obj/item/wrench = 12,
		/obj/item/t_scanner = 12,
		/obj/item/cell = 8,
		/obj/item/weldingtool = 8,
		/obj/item/clothing/head/welding = 8,
		/obj/item/light/tube = 10,
		/obj/item/stock_parts/scanning_module = 5,
		/obj/item/stock_parts/micro_laser = 5,
		/obj/item/stock_parts/matter_bin = 5,
		/obj/item/stock_parts/manipulator = 5,
		/obj/item/stock_parts/console_screen = 5,
		/obj/item/stock_parts/capacitor = 5,
		/obj/item/stock_parts/keyboard = 5,
		/obj/item/stock_parts/power/apc/buildable = 5
	)
	contraband = list(/obj/item/rcd = 1, /obj/item/rcd_ammo = 5)

//This one's from bay12
/obj/machinery/vending/robotics
	name = "Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon = 'icons/obj/machines/vending/robotics.dmi'
	initial_access = list(access_robotics)
	base_type = /obj/machinery/vending/robotics
	products = list(
		/obj/item/stack/cable_coil = 4,
		/obj/item/flash/synthetic = 4,
		/obj/item/cell = 4,
		/obj/item/scanner/health = 2,
		/obj/item/scalpel = 1,
		/obj/item/circular_saw = 1,
		/obj/item/clothing/mask/breath/medical = 5,
		/obj/item/screwdriver = 2,
		/obj/item/crowbar = 2
	)
	contraband = list(/obj/item/flash = 2)

/obj/machinery/vending/materials
	name = "MatterVend"
	desc = "Provides access to baryonic matter in easy to handle sheet form."
	icon = 'icons/obj/machines/vending/engivend.dmi'
	markup = 0
	vend_delay = 21
	base_type = /obj/machinery/vending/materials
	products = list(
		/obj/item/stack/material/sheet/mapped/steel/fifty                 = 3,
		/obj/item/stack/material/panel/mapped/plastic/fifty               = 4,
		/obj/item/stack/material/sheet/shiny/mapped/aluminium/fifty       = 3,
		/obj/item/stack/material/sheet/reinforced/mapped/plasteel/ten     = 4,
		/obj/item/stack/material/ingot/mapped/copper/fifty                = 4,
		/obj/item/stack/material/pane/mapped/glass/fifty                  = 4,
		/obj/item/stack/material/sheet/reinforced/mapped/fiberglass/fifty = 4
	)
	contraband = list(
		/obj/item/stack/material/sheet/reinforced/mapped/ocp/ten          = 3
	)
