/obj/item/gun/energy/staff
	name = "staff of change"
	desc = "An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself."
	icon = 'icons/obj/guns/staff.dmi'
	icon_state = ICON_STATE_WORLD
	fire_sound = 'sound/weapons/emitter.ogg'
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	max_shots = 5
	projectile_type = /obj/item/projectile/change
	origin_tech = null
	self_recharge = 1
	charge_meter = 0
	has_safety = FALSE
	var/required_antag_type

/obj/item/gun/energy/staff/special_check(var/mob/user)
	var/decl/special_role/antag = GET_DECL(required_antag_type)
	if(user.mind && (!antag?.is_antagonist(user.mind)))
		to_chat(user, SPAN_WARNING("You focus your mind on \the [src], but nothing happens!"))
		return FALSE
	return ..()

/obj/item/gun/energy/staff/handle_click_empty(mob/user = null)
	if (user)
		user.visible_message("*fizzle*", "<span class='danger'>*fizzle*</span>")
	else
		src.visible_message("*fizzle*")
	playsound(src.loc, 'sound/effects/sparks1.ogg', 100, 1)

/obj/item/gun/energy/staff/animate
	name = "staff of animation"
	desc = "An artefact that spits bolts of life-force which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines."
	max_shots = 5
	recharge_time = 5 SECONDS
	projectile_type = /obj/item/projectile/animate

/obj/item/gun/energy/staff/focus
	name = "mental focus"
	desc = "An artefact that channels the will of the user into destructive bolts of force. If you aren't careful with it, you might poke someone's brain out."
	icon = 'icons/obj/guns/focus_staff.dmi'
	projectile_type = /obj/item/projectile/forcebolt

/obj/item/gun/energy/staff/fire
	name = "flaming staff"
	desc = "A long, everburning torch."
	icon = 'icons/obj/guns/fire_staff.dmi'
	projectile_type = /obj/item/projectile/firebolt
