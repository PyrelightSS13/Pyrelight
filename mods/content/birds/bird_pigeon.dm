/mob/living/simple_animal/passive/bird/pigeon
	name = "messenger pigeon"
	icon = 'mods/content/birds/icons/pigeon.dmi'
	ai   = /datum/mob_controller/passive/pigeon
	holder_type = /obj/item/holder/bird/pigeon
	var/weakref/home_hutch

/mob/living/simple_animal/passive/bird/pigeon/Initialize()
	. = ..()
	update_hutch()

/mob/living/simple_animal/passive/bird/pigeon/proc/go_home(mob/releaser)
	if(!is_outside())
		return
	var/obj/structure/hutch/hutch = home_hutch?.resolve()
	if(!istype(hutch) || QDELETED(hutch))
		return // todo: check if the hutch is accessible from the sky
	if(releaser)
		releaser.visible_message(SPAN_NOTICE("\The [releaser] releases \a [src], which flutters away into the sky."))
	else
		visible_message(SPAN_NOTICE("\The [src] flutters away into the sky."))
	set_dir(SOUTH)
	// this is done manually due to the actual flying state primarily being handled as a movement state.
	icon_state = "world-flying"
	new /obj/effect/dummy/fadeout(loc, NORTH, src)
	new /obj/effect/dummy/fadein(get_turf(hutch), SOUTH, src)
	update_icon()

	hutch.visible_message(SPAN_NOTICE("\A [src] alights on \the [hutch] in a flutter of wings."))
	var/obj/item/holder/bird_item = new holder_type
	forceMove(bird_item)
	bird_item.sync(src)
	hutch.storage?.handle_item_insertion(null, bird_item)
	if(bird_item.loc != hutch)
		dropInto(hutch.loc)
		qdel(bird_item)

/obj/item/holder/bird/pigeon/attack_self(mob/user)
	var/mob/living/simple_animal/passive/bird/pigeon/pigeon = locate() in contents
	if(!istype(pigeon))
		return ..()
	if(!is_outside())
		to_chat(user, SPAN_WARNING("You need to be outdoors to release \the [pigeon]."))
		return TRUE
	if(isnull(pigeon.home_hutch))
		var/decl/pronouns/pronouns = pigeon.get_pronouns()
		to_chat(user, SPAN_WARNING("\The [pigeon] tilts [pronouns.his] head at you in confusion. [pronouns.He] must not have a hutch to return to."))
	else
		user.drop_from_inventory(src)
		pigeon.go_home(user)
		qdel(src)
	return TRUE

/mob/living/simple_animal/passive/bird/pigeon/proc/update_hutch()
	var/obj/structure/hutch/hutch = home_hutch?.resolve()
	if(!istype(hutch) || QDELETED(hutch))
		hutch = get_recursive_loc_of_type(/obj/structure/hutch)
	if(istype(hutch) && !QDELETED(hutch))
		home_hutch = weakref(hutch)
		events_repository.unregister(/decl/observ/moved, src, src)
	else
		events_repository.register(/decl/observ/moved, src, src, TYPE_PROC_REF(/mob/living/simple_animal/passive/bird/pigeon, update_hutch))

/datum/mob_controller/passive/pigeon
	emote_speech   = list("Oo-ooo.","Oo-ooo?","Oo-ooo...")
	emote_hear     = list("coos")
	emote_see      = list("preens its feathers", "puffs out its neck", "ruffles its wings")
