/area/karzerfeste
	name = "Burg Karzerfeste"
	abstract_type = /area/karzerfeste
	allow_xenoarchaeology_finds = FALSE
	icon = 'maps/karzerfeste/areas/icons.dmi'
	icon_state = "area"
	base_turf = /turf/floor/rock/basalt
	fishing_failure_prob = 5
	fishing_results = list(
		/mob/living/simple_animal/aquatic/fish               = 10,
		/mob/living/simple_animal/aquatic/fish/grump         = 10,
		/obj/item/mollusc                                    = 5,
		/obj/item/mollusc/barnacle/fished                    = 5,
		/obj/item/mollusc/clam/fished/pearl                  = 3,
		/obj/item/trash/mollusc_shell/clam                   = 1,
		/obj/item/trash/mollusc_shell/barnacle               = 1,
		/obj/item/remains/mouse                              = 1,
		/obj/item/remains/lizard                             = 1,
		/obj/item/stick                                      = 1,
		/obj/item/trash/mollusc_shell                        = 1,
	)
	sound_env = GENERIC
	ambience = list()

/area/karzerfeste/outside
	name = "\improper Wilderness"
	color = COLOR_GREEN
	is_outside = OUTSIDE_YES
	sound_env = PLAIN
	ambience = list(
		'sound/effects/wind/wind_2_1.ogg',
		'sound/effects/wind/wind_2_2.ogg',
		'sound/effects/wind/wind_3_1.ogg',
		'sound/effects/wind/wind_4_1.ogg',
		'sound/effects/wind/wind_4_2.ogg',
		'sound/effects/wind/wind_5_1.ogg'
	)
	area_blurb_category = /area/karzerfeste/outside
	interior_ambient_light_modifier = -0.3
	area_flags = AREA_FLAG_EXTERNAL | AREA_FLAG_IS_BACKGROUND
	additional_fishing_results = list(
		/mob/living/simple_animal/aquatic/fish/large        = 5,
		/mob/living/simple_animal/aquatic/fish/large/salmon = 5,
		/mob/living/simple_animal/aquatic/fish/large/trout  = 5,
		/mob/living/simple_animal/aquatic/fish/large/pike   = 3
	)

/area/karzerfeste/outside/above
	name = "\improper Heights"
	color = COLOR_GRAY80

// Forest level
/area/karzerfeste/outside/forest
	name = "\improper Western Forest"
	sound_env = FOREST

/area/karzerfeste/outside/forest/woods
	name = "\improper Western Woods"

/area/karzerfeste/outside/forest/lake
	name = "\improper Western Lake"
	additional_fishing_results = list(
		/mob/living/simple_animal/aquatic/fish/large/bass    = 5,
		/mob/living/simple_animal/aquatic/fish/large/trout   = 5,
		/mob/living/simple_animal/aquatic/fish/large/javelin = 5,
		/mob/living/simple_animal/hostile/aquatic/carp       = 3,
		/mob/living/simple_animal/aquatic/fish/large/koi     = 1
	)
	color = COLOR_BLUE_GRAY

/area/karzerfeste/outside/forest/deep
	name = "\improper Western Deepwoods"
	color = COLOR_DARK_GREEN_GRAY
