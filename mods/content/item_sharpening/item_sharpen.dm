/obj/item/update_name()
	. = ..()
	if(has_item_effect(/decl/item_effect/sharpened, IE_CAT_EXAMINE) && get_item_effect_parameter(/decl/item_effect/sharpened, IE_CAT_DAMAGE, IE_PAR_USES) <= 0)
		SetName("dulled [name]")

/obj/item/proc/can_sharpen_with(obj/item/sharpening_with)
	if(!has_item_effect(/decl/item_effect/sharpened, IE_CAT_DAMAGE))
		return FALSE
	var/list/params = get_item_effect_parameters(/decl/item_effect/sharpened, IE_CAT_DAMAGE)
	if(!islist(params) || params[IE_PAR_USES] >= params[IE_PAR_MAX_USES])
		return FALSE
	if(istype(sharpening_with, /obj/structure/working/grindstone))
		var/obj/structure/working/grindstone/stone = sharpening_with
		return !material || material.hardness <= stone.stone_material?.hardness
	return !material || material.hardness <= sharpening_with.material?.hardness

/obj/item/proc/sharpen_with(mob/user, obj/item/sharpen_with)
	if(!has_item_effect(/decl/item_effect/sharpened, IE_CAT_DAMAGE))
		return FALSE
	var/list/params = get_item_effect_parameters(/decl/item_effect/sharpened, IE_CAT_DAMAGE)
	if(!islist(params))
		return FALSE
	var/max_uses = params[IE_PAR_MAX_USES]
	if(max_uses <= 0)
		return FALSE
	var/uses = params[IE_PAR_USES] || 0
	if(uses >= max_uses)
		return FALSE
	set_item_effect_parameter(/decl/item_effect/sharpened, IE_CAT_DAMAGE, IE_PAR_USES, max_uses)
	if(uses == 0) // We've sharpened up from dull.
		update_attack_force()
		update_name()
	return TRUE

/obj/item/proc/try_sharpen_with(mob/user, obj/sharpening_with)
	if(!has_item_effect(/decl/item_effect/sharpened, IE_CAT_DAMAGE))
		return FALSE
	if(can_sharpen_with(sharpening_with))
		user.visible_message("\The [user] begins sharpening \the [src] with \the [sharpening_with].")
		playsound(loc, 'sound/foley/knife1.ogg', 50) // metallic scrape, TODO better sound
		if(user.do_skilled(10 SECONDS, SKILL_WEAPONS, src, check_holding = TRUE) && !QDELETED(sharpening_with) && can_sharpen_with(sharpening_with) && sharpen_with(user, sharpening_with))
			playsound(loc, 'sound/foley/knife1.ogg', 50)
			user.visible_message("\The [user] sharpens \the [src] with \the [sharpening_with].")
	else
		to_chat(user, SPAN_WARNING("\The [src] cannot be [initial(_sharp) ? "further sharpened" : "sharpened"] with \the [sharpening_with]."))
	return TRUE

// We don't override sharp because it's probably still pointy even if it isn't sharpened.
/obj/item/has_edge()
	. = ..()
	if(. && has_item_effect(/decl/item_effect/sharpened, IE_CAT_DAMAGE))
		return get_item_effect_parameter(/decl/item_effect/sharpened, IE_CAT_DAMAGE, IE_PAR_USES) > 0
