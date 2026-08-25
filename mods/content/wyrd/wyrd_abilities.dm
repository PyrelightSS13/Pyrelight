// Handler for a basic set of wyrd abilities - primarily your sensitivity to local anima and ability to check your own anima.
/datum/ability_handler/wyrd_general
	category_toggle_type = /obj/screen/ability/category/wyrd_general

/datum/ability_handler/wyrd/general

/obj/screen/ability/category/wyrd_general
	name = "Wyrd Practice"
	icon = 'mods/content/wyrd/icons/abilities.dmi'

/obj/screen/ability/button/wyrd
	icon = 'mods/content/wyrd/icons/abilities.dmi'

/decl/ability/wyrd
	abstract_type           = /decl/ability/wyrd
	ability_icon            = 'mods/content/wyrd/icons/abilities.dmi'
	target_selector         = /decl/ability_targeting/target_self
	associated_handler_type = /datum/ability_handler/wyrd_general
	ui_element_type         = /obj/screen/ability/button/wyrd

/decl/ability/wyrd/check_ambient
	name = "Dowse Aura"
	ability_icon_state = "outward"

/decl/ability/wyrd/check_ambient/apply_ability_effect_to(mob/living/user, atom/target, list/metadata)
	. = ..()
	for(var/atype,avalue in user.get_ambient_anima())
		var/decl/anima/anima = GET_DECL(atype)
		to_chat(user, anima.get_ambient_anima_description(avalue, user.get_background_datum(/decl/background_category/faction)))

/decl/ability/wyrd/check_personal
	name = "Self-Reflection"
	ability_icon_state = "inward"

/decl/ability/wyrd/check_personal/apply_ability_effect_to(mob/living/user, atom/target, list/metadata)
	. = ..()
	for(var/atype,avalue in user.get_personal_anima_pool())
		var/decl/anima/anima = GET_DECL(atype)
		to_chat(user, anima.get_personal_anima_description(avalue, user.get_background_datum(/decl/background_category/faction)))

/*
/mob/living/verb/debug_anima_verb()
	set name = "Debug Anima"
	set category = "Debug"
	set src = usr

	set_extension(src, /datum/extension/anima_aura)

	add_ability(/decl/ability/wyrd/check_ambient)
	add_ability(/decl/ability/wyrd/check_personal)

	add_ability(/decl/ability/wyrd/spell/flash)
	add_ability(/decl/ability/wyrd/spell/gloom)
	add_ability(/decl/ability/wyrd/spell/flare)
*/
