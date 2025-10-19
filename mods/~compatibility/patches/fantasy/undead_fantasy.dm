// Overrides to populate the dungeon with undead.
/obj/random/hostile/dungeon/spawn_choices()
	var/static/list/spawnable_choices = list(
		/mob/living/human/zombie         = 1,
		/mob/living/human/skeleton       = 2,
		/mob/living/human/zombie/hnoll   = 1,
		/mob/living/human/skeleton/hnoll = 2
	)
	return spawnable_choices
