/mob/living/simple_animal/passive/bird
	mob_size = MOB_SIZE_SMALL
	pass_flags = PASS_FLAG_TABLE
	abstract_type = /mob/living/simple_animal/passive/bird
	natural_weapon = /obj/item/natural_weapon/bird_claws
	holder_type = /obj/item/holder/bird

/obj/item/holder/bird
	w_class = MOB_SIZE_SMALL

/obj/item/holder/bird/attack_self(mob/user)
	var/mob/living/bird = locate() in contents
	if(istype(bird?.ai) && bird.ai.process_holder_interaction(user))
		return TRUE
	return ..()

/obj/item/holder/bird/afterattack(atom/target, mob/user, proximity)
	if(proximity)
		return ..()
	var/mob/living/bird = locate() in contents
	. = ..()
	if(!user || !bird || QDELETED(src) || bird.loc != src)
		return
	bird.dropInto(loc)
	qdel(src) // This will happen shortly regardless, but might as well skip the 1ds delay.
	if(isturf(target))
		bird.visible_message(SPAN_NOTICE("\The [user] releases \a [bird]!"))
	else
		bird.visible_message(SPAN_NOTICE("\The [user] indicates \the [target] and releases \a [bird]!"))
	if(istype(bird.ai))
		bird.ai.process_handler_target(user, target, user.get_intent()?.intent_flags)
