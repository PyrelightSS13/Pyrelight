/decl/outfit/job/karzerfeste/shrine
	name       = "Karzerfeste - Shrine Attendant"
	uniform    = list(
		/obj/item/clothing/pants/trousers,
		/obj/item/clothing/shirt/crafted/wool,
		/obj/item/clothing/suit/robe/sleeved/shrine
	)
	backpack_contents = list(
		/obj/item/stack/medical/bandage/crafted/five  = 1,
		/obj/item/stack/medical/ointment/crafted/five = 1,
		/obj/item/stack/medical/splint/crafted/five   = 1
	)

/decl/outfit/job/karzerfeste/shrine/keeper
	name       = "Karzerfeste - Shrine Keeper"
	suit       = /obj/item/clothing/suit/mantle
	mask       = /obj/item/clothing/neck/prayer_beads/basalt

/decl/outfit/job/karzerfeste/shrine/cleric
	name       = "Karzerfeste - Shrine Cleric"
	suit       = /obj/item/clothing/suit/armor/forged/cuirass
	belt       = /obj/item/bladed/longsword // TODO: mace and magic
	suit_store = /obj/item/shield/crafted/buckler

/decl/outfit/job/karzerfeste/shrine/gravekeeper
	name       = "Karzerfeste - Shrine Gravekeeper"
	belt       = /obj/item/tool/shovel/wood
	suit       = /obj/item/clothing/suit/armor/forged/brigandine
	suit_store = /obj/item/flame/fuelled/lantern
	uniform    = list(
		/obj/item/clothing/pants/trousers,
		/obj/item/clothing/shirt/jerkin
	)
