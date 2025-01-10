/mob/living/human/get_movement_delay(var/travel_dir)
	. = ..()
	if(has_trait(/decl/trait/undead))
		set_moving_slowly()
		if(istype(default_walk_intent))
			. = max(., default_walk_intent.move_delay) // no runner zombies yet

/mob/living/human/proc/grant_basic_undead_equipment()

	var/species_name = get_species_name()
	if(species_name == SPECIES_HUMAN || species_name == SPECIES_HNOLL)
		var/pants_type = pick(/obj/item/clothing/pants/trousers, /obj/item/clothing/pants/trousers/braies)
		equip_to_slot_or_del(new pants_type(src), slot_w_uniform_str)

		var/jerkin_type = pick(/obj/item/clothing/shirt/tunic, /obj/item/clothing/shirt/tunic/short, /obj/item/clothing/shirt/jerkin)
		equip_to_slot_or_del(new jerkin_type(src), slot_w_uniform_str)

		if(prob(30))
			equip_to_slot_or_del(new /obj/item/clothing/suit/armor/forged/banded(src), slot_wear_suit_str)
		else
			equip_to_slot_or_del(new /obj/item/clothing/suit/armor/crafted/leather(src), slot_wear_suit_str)
		if(prob(20))
			put_in_active_hand(new /obj/item/bladed/broadsword(src))
		else
			put_in_active_hand(new /obj/item/bladed/shortsword(src))
			put_in_inactive_hand(new /obj/item/shield/crafted/buckler(src))
		return

	if(species_name == SPECIES_KOBALOI)

		var/pants_type = pick(/obj/item/clothing/pants/trousers/braies, /obj/item/clothing/pants/loincloth)
		equip_to_slot_or_del(new pants_type(src), slot_w_uniform_str)
		if(prob(75))
			var/jerkin_type = pick(/obj/item/clothing/shirt/tunic/short, /obj/item/clothing/shirt/jerkin)
			equip_to_slot_or_del(new jerkin_type(src), slot_w_uniform_str)

		if(prob(30))
			equip_to_slot_or_del(new /obj/item/clothing/suit/armor/crafted/leather(src), slot_wear_suit_str)
			put_in_active_hand(new /obj/item/bladed/knife(src))
		return
