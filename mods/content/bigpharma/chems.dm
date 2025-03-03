/obj/item/chems
	var/obfuscated_meds_type

/obj/item/chems/Initialize()
	. = ..()
	// Check area so stuff spawned for reference (atom info repository) isn't obfuscated
	if(. != INITIALIZE_HINT_QDEL && obfuscated_meds_type && get_area(src))
		set_extension(src, obfuscated_meds_type)
		. = INITIALIZE_HINT_LATELOAD

/obj/item/chems/LateInitialize()
	. = ..()
	handle_med_obfuscation(src)

/obj/item/chems/examined_by(mob/user, distance, infix, suffix)
	. = ..()
	var/datum/extension/obfuscated_medication/meds = get_extension(src, /datum/extension/obfuscated_medication)
	if(meds && user && (user.skill_check(SKILL_CHEMISTRY, meds.skill_threshold) || user.skill_check(SKILL_MEDICAL, meds.skill_threshold)))
		to_chat(user, SPAN_NOTICE("As far as you know, the active ingredient is <b>[meds.original_reagent]</b>."))

/obj/item/chems/get_codex_value(var/mob/user)
	var/datum/extension/obfuscated_medication/meds = get_extension(src, /datum/extension/obfuscated_medication)
	if(meds && user && (user.skill_check(SKILL_CHEMISTRY, meds.skill_threshold) || user.skill_check(SKILL_MEDICAL, meds.skill_threshold)))
		return "[meds.original_reagent] (substance)"
	return ..()

/obj/item/chems/on_update_icon()
	var/datum/extension/obfuscated_medication/meds = get_extension(src, /datum/extension/obfuscated_medication)
	if(meds)
		meds.update_appearance()
	. = ..()
