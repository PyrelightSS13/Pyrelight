//This is the combination of logic pertaining music
//An atom should use the logic and call it as it wants
/datum/real_instrument
	var/list/instruments
	var/datum/sound_player/player
	var/datum/nano_module/song_editor/song_editor
	var/datum/nano_module/usage_info/usage_info
	var/maximum_lines
	var/maximum_line_length
	var/obj/owner
	var/datum/nano_module/env_editor/env_editor
	var/datum/nano_module/echo_editor/echo_editor

/datum/real_instrument/New(obj/who, datum/sound_player/how, datum/instrument/what)
	player = how
	owner = who
	maximum_lines = global.musical_config.max_lines
	maximum_line_length = global.musical_config.max_line_length
	instruments = istype(what) ? list(what) : what

/datum/real_instrument/proc/OnTopic(mob/user, href_list)
	var/target = href_list["target"]
	var/value = text2num(href_list["value"])
	if (href_list["value"] && !isnum(value))
		to_chat(user, "Non-numeric value was given.")
		return 0


	switch (target)
		if ("tempo") src.player.song.tempo = src.player.song.sanitize_tempo(src.player.song.tempo + value*world.tick_lag)
		if ("play")
			src.player.song.playing = value
			if (src.player.song.playing)
				src.player.song.play_song(user)
		if ("newsong")
			src.player.song.lines.Cut()
			src.player.song.tempo = src.player.song.sanitize_tempo(5) // default 120 BPM
		if ("import")
			var/t = ""
			do
				t = html_encode(input(user, "Please paste the entire song, formatted:", text("[]", owner.name), t)  as message)
				if(!CanInteractWith(user, owner, global.physical_topic_state))
					return

				if(length(t) >= 2*src.maximum_lines*src.maximum_line_length)
					var/cont = input(user, "Your message is too long! Would you like to continue editing it?", "", "yes") in list("yes", "no")
					if(!CanInteractWith(user, owner, global.physical_topic_state))
						return
					if(cont == "no")
						break
			while(length(t) > 2*src.maximum_lines*src.maximum_line_length)
			if (length(t))
				src.player.song.lines = splittext(t, "\n")
				if(copytext(src.player.song.lines[1],1,6) == "BPM: ")
					if(text2num(copytext(src.player.song.lines[1],6)) != 0)
						src.player.song.tempo = src.player.song.sanitize_tempo(600 / text2num(copytext(src.player.song.lines[1],6)))
						src.player.song.lines.Cut(1,2)
					else
						src.player.song.tempo = src.player.song.sanitize_tempo(5)
				else
					src.player.song.tempo = src.player.song.sanitize_tempo(5) // default 120 BPM
				if(src.player.song.lines.len > maximum_lines)
					to_chat(user,"Too many lines!")
					src.player.song.lines.Cut(maximum_lines+1)
				var/linenum = 1
				for(var/l in src.player.song.lines)
					if(length(l) > maximum_line_length)
						to_chat(user, "Line [linenum] too long!")
						src.player.song.lines.Remove(l)
					else
						linenum++
		if ("show_song_editor")
			if (!src.song_editor)
				src.song_editor = new (host = src.owner, song = src.player.song)
			src.song_editor.ui_interact(user)

		if ("show_usage")
			if (!src.usage_info)
				src.usage_info = new (owner, src.player)
			src.usage_info.ui_interact(user)
		if ("volume")
			src.player.volume = min(max(min(player.volume+text2num(value), 100), 0), player.max_volume)
		if ("transposition")
			src.player.song.transposition = max(min(player.song.transposition+value, global.musical_config.highest_transposition), global.musical_config.lowest_transposition)
		if ("min_octave")
			src.player.song.octave_range_min = max(min(player.song.octave_range_min+value, global.musical_config.highest_octave), global.musical_config.lowest_octave)
			src.player.song.octave_range_max = max(player.song.octave_range_max, player.song.octave_range_min)
		if ("max_octave")
			src.player.song.octave_range_max = max(min(player.song.octave_range_max+value, global.musical_config.highest_octave), global.musical_config.lowest_octave)
			src.player.song.octave_range_min = min(player.song.octave_range_max, player.song.octave_range_min)
		if ("sustain_timer")
			src.player.song.sustain_timer = max(min(player.song.sustain_timer+value, global.musical_config.longest_sustain_timer), 1)
		if ("soft_coeff")
			var/new_coeff = input(user, "from [global.musical_config.gentlest_drop] to [global.musical_config.steepest_drop]") as num
			if(!CanInteractWith(user, owner, global.physical_topic_state))
				return
			new_coeff = round(min(max(new_coeff, global.musical_config.gentlest_drop), global.musical_config.steepest_drop), 0.001)
			src.player.song.soft_coeff = new_coeff
		if ("instrument")
			var/list/categories = list()
			for (var/key in instruments)
				var/datum/instrument/instrument = instruments[key]
				categories |= instrument.category

			var/category = input(user, "Choose a category") as null|anything in categories
			if(!CanInteractWith(user, owner, global.physical_topic_state))
				return
			var/list/instruments_available = list()
			for (var/key in instruments)
				var/datum/instrument/instrument = instruments[key]
				if (instrument.category == category)
					instruments_available += key

			var/new_instrument = input(user, "Choose an instrument") as null|anything in instruments_available
			if(!CanInteractWith(user, owner, global.physical_topic_state))
				return
			if (new_instrument)
				src.player.song.instrument_data = instruments[new_instrument]
		if ("autorepeat") src.player.song.autorepeat = value
		if ("decay") src.player.song.linear_decay = value
		if ("echo") src.player.apply_echo = value
		if ("show_env_editor")
			if (global.musical_config.env_settings_available)
				if (!src.env_editor)
					src.env_editor = new (src.player)
				src.env_editor.ui_interact(user)
			else
				to_chat(user, "Virtual environment is disabled.")

		if ("show_echo_editor")
			if (!src.echo_editor)
				src.echo_editor = new (src.player)
			src.echo_editor.ui_interact(user)

		if ("select_env")
			if (value in -1 to 26)
				src.player.virtual_environment_selected = round(value)
		else
			return 0

	return 1



/datum/real_instrument/proc/ui_call(mob/user, ui_key, var/datum/nanoui/ui = null, var/force_open = 0)
	var/list/data
	data = list(
		"playback" = list(
			"playing" = src.player.song.playing,
			"autorepeat" = src.player.song.autorepeat,
		),
		"basic_options" = list(
			"cur_instrument" = src.player.song.instrument_data.name,
			"volume" = src.player.volume,
			"BPM" = round(600 / src.player.song.tempo),
			"transposition" = src.player.song.transposition,
			"octave_range" = list(
				"min" = src.player.song.octave_range_min,
				"max" = src.player.song.octave_range_max
			)
		),
		"advanced_options" = list(
			"all_environments" = global.musical_config.all_environments,
			"selected_environment" = global.musical_config.id_to_environment(src.player.virtual_environment_selected),
			"apply_echo" = src.player.apply_echo
		),
		"sustain" = list(
			"linear_decay_active" = src.player.song.linear_decay,
			"sustain_timer" = src.player.song.sustain_timer,
			"soft_coeff" = src.player.song.soft_coeff
		),
		"show" = list(
			"playback" = src.player.song.lines.len > 0,
			"custom_env_options" = global.musical_config.is_custom_env(src.player.virtual_environment_selected),
			"env_settings" = global.musical_config.env_settings_available
		),
		"status" = list(
			"channels" = src.player.song.available_channels,
			"events" = src.player.event_manager.events.len,
			"max_channels" = global.musical_config.channels_per_instrument,
			"max_events" = global.musical_config.max_events,
		)
	)


	ui =  SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new (user, src.owner, ui_key, "synthesizer.tmpl", owner.name, 600, 800)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)



/datum/real_instrument/Destroy()
	QDEL_NULL(player)
	owner = null
	return ..()

/obj/structure/synthesized_instrument
	var/datum/real_instrument/real_instrument
	icon = 'icons/obj/musician.dmi'
	//Initialization data
	var/list/instruments = list()
	var/path = /datum/instrument
	var/sound_player = /datum/sound_player

/obj/structure/synthesized_instrument/Initialize()
	. = ..()
	for (var/type in typesof(path))
		var/datum/instrument/new_instrument = new type
		if (!new_instrument.id) continue
		new_instrument.create_full_sample_deviation_map()
		src.instruments[new_instrument.name] = new_instrument
	src.real_instrument = new /datum/real_instrument(src, new sound_player(src, instruments[pick(instruments)]), instruments)

/obj/structure/synthesized_instrument/Destroy()
	QDEL_NULL(src.real_instrument)
	for(var/key in instruments)
		qdel(instruments[key])
	instruments = null
	. = ..()


/obj/structure/synthesized_instrument/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	interact(user)
	return TRUE

/obj/structure/synthesized_instrument/interact(mob/user) // CONDITIONS ..(user) that shit in subclasses
	src.ui_interact(user)


/obj/structure/synthesized_instrument/ui_interact(mob/user, ui_key = "instrument", var/datum/nanoui/ui = null, var/force_open = 0)
	real_instrument.ui_call(user,ui_key,ui,force_open)


/obj/structure/synthesized_instrument/proc/shouldStopPlaying(mob/user)
	return 0


/obj/structure/synthesized_instrument/OnTopic(mob/user, href_list)
	return ..() || real_instrument.OnTopic(user, href_list)


////////////////////////
//DEVICE VERSION
////////////////////////


/obj/item/synthesized_instrument
	var/datum/real_instrument/real_instrument
	icon = 'icons/obj/musician.dmi'
	material = /decl/material/solid/organic/plastic
	var/list/instruments = list()
	var/path = /datum/instrument
	var/sound_player = /datum/sound_player

/obj/item/synthesized_instrument/Initialize()
	. = ..()
	for (var/type in typesof(path))
		var/datum/instrument/new_instrument = type
		if (!initial(new_instrument.id))
			continue
		new_instrument = new type
		new_instrument.create_full_sample_deviation_map()
		instruments[new_instrument.name] = new_instrument
	src.real_instrument = new /datum/real_instrument(src, new sound_player(src, instruments[pick(instruments)]), instruments)

/obj/item/synthesized_instrument/Destroy()
	QDEL_NULL(src.real_instrument)
	for(var/key in instruments)
		qdel(instruments[key])
	instruments = null
	. = ..()


/obj/item/synthesized_instrument/attack_self(mob/user)
	src.interact(user)


/obj/item/synthesized_instrument/interact(mob/user) // CONDITIONS ..(user) that shit in subclasses
	src.ui_interact(user)


/obj/item/synthesized_instrument/ui_interact(mob/user, ui_key = "instrument", var/datum/nanoui/ui = null, var/force_open = 0)
	real_instrument.ui_call(user,ui_key,ui,force_open)


/obj/item/synthesized_instrument/proc/shouldStopPlaying(mob/user)
	return src && CanPhysicallyInteract(user)

/obj/item/synthesized_instrument/OnTopic(mob/user, href_list)
	return ..() || real_instrument.OnTopic(user, href_list)