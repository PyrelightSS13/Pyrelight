// GENERIC MINING AREAS
/area/mine
	icon_state = "mining"
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	sound_env = ASTEROID
	base_turf = /turf/floor/barren
	area_flags = AREA_FLAG_IS_BACKGROUND | AREA_FLAG_HIDE_FROM_HOLOMAP

/area/mine/explored
	name = "Mine"
	icon_state = "explored"

/area/mine/unexplored
	name = "Mine"
	icon_state = "unexplored"

// OUTPOSTS
/area/outpost/abandoned
	name = "Abandoned Outpost"
	icon_state = "dark"

/area/djstation
	name = "\improper Listening Post"
	icon_state = "LP"