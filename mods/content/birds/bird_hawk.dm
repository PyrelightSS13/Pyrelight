/mob/living/simple_animal/passive/bird/hawk
	name = "hawk"
	icon = 'mods/content/birds/icons/hawk.dmi'
	ai   = /datum/mob_controller/passive/hunter/hawk
	ability_handlers = list(/datum/ability_handler/predator)

/datum/mob_controller/passive/hunter/hawk
	emote_speech   = list("Skree!","SKREE!","Skree!?")
	emote_hear     = list("screeches", "screams")
	emote_see      = list("preens its feathers", "flicks its wings", "looks sharply around")
	var/handler_set_target = FALSE
	var/handling_skill = SKILL_BOTANY
	var/handling_difficulty = SKILL_ADEPT

/datum/mob_controller/passive/hunter/hawk/consume_prey(mob/living/prey)
	if(prey.stat == DEAD && last_handler && handler_set_target)
		set_target(last_handler?.resolve())
		prey.try_make_grab(body, defer_hand = TRUE)
		return
	return ..()

/datum/mob_controller/passive/hunter/hawk/set_target(atom/new_target)
	. = ..()
	handler_set_target = FALSE

/datum/mob_controller/passive/hunter/hawk/process_handler_target(mob/handler, atom/target)
	if((. = ..()))
		set_target(target)
		handler_set_target = TRUE
		process_hunting(target)

/datum/mob_controller/passive/hunter/hawk/can_hunt(mob/living/victim)
	return handler_set_target || ..()

/datum/mob_controller/passive/hunter/hawk/check_handler_can_order(mob/handler, atom/target, intent_flags)
	if(!(. = ..()) && handler.skill_check(handling_skill, handling_difficulty))
		add_friend(handler)
		return ..()

/datum/mob_controller/passive/hunter/hawk/process_handler_failure(mob/handler, atom/target)
	body?.visible_message(SPAN_DANGER("\The [body] ignores \the [target] in favour of attacking \the [handler]!"))
	set_target(handler)
	handler_set_target = TRUE
	next_hunt = 0
	return ..()

/datum/mob_controller/passive/hunter/hawk/handle_friend_hunting(mob/user)
	..()
	set_target(null)
	resume_wandering()
	if(!body)
		return
	if(body.scoop_check(user) && body.get_scooped(user, body, silent = TRUE))
		body.visible_message(SPAN_NOTICE("\The [body] alights on \the [user]."))
	else
		body.visible_message(SPAN_NOTICE("\The [body] lands beside \the [user]."))

	for(var/obj/item/thing in body.get_equipped_items(include_carried = TRUE))
		body.drop_from_inventory(thing)
		if(!QDELETED(thing))
			user.put_in_hands(thing)
			var/equipped_to = user.get_equipped_slot_for_item(thing)
			var/datum/inventory_slot/slot = equipped_to && user.get_inventory_slot_datum(equipped_to)
			if(istype(slot))
				to_chat(user, SPAN_NOTICE("\The [body] drops \a [thing] into your [lowertext(slot.slot_name)]."))
			else
				to_chat(user, SPAN_NOTICE("\The [body] drops \a [thing]."))

	return TRUE

/datum/mob_controller/passive/hunter/hawk/process_hunting(atom/target)
	// Handles pathing to the target, and attacking the target if it's a mob.
	if(!(. = ..()))
		return
	// Maybe consider handling structures at some point?
	if(isitem(target) && body.Adjacent(target))
		body.put_in_hands(target)
		if(target.loc != body)
			body.visible_message(SPAN_WARNING("\The [body] fails to collect \the [target]!"))
	// Return to handler.
	set_target(last_handler?.resolve())
	return FALSE
