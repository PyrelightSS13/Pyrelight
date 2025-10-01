/datum/mob_controller/passive/crow
	emote_speech   = list("Caw.","Caw!","Caw...")
	emote_hear     = list("croaks", "caws")
	emote_see      = list("preens its feathers", "hops around")

/mob/living/simple_animal/passive/bird/crow
	name = "crow"
	icon = 'mods/content/birds/icons/crow.dmi'
	ai = /datum/mob_controller/passive/crow
	ability_handlers = list(/datum/ability_handler/predator) // should really be /scavenger
