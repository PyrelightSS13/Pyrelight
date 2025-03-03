//Check if an /atom/movable that has been Destroyed has been correctly placed into nullspace and if not, throws a runtime and moves it to nullspace
#define GC_CHECK_AM_NULLSPACE(D, hint) \
	if(istype(D,/atom/movable)) {\
		var/atom/movable/AM = D; \
		if(AM.loc != null) {\
			PRINT_STACK_TRACE("QDEL([hint]): [AM.name] was supposed to be in nullspace but isn't \
						(LOCATION= [AM.loc.name] ([AM.loc.x],[AM.loc.y],[AM.loc.z]) )! Destroy didn't do its job!"); \
			AM.forceMove(null); \
		} \
	}

SUBSYSTEM_DEF(garbage)
	name = "Garbage"
	priority = SS_PRIORITY_GARBAGE
	wait = 2 SECONDS
	flags = SS_POST_FIRE_TIMING | SS_BACKGROUND | SS_NO_INIT | SS_NEEDS_SHUTDOWN
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	init_order = SS_INIT_GARBAGE

	var/list/collection_timeout = list(GC_FILTER_QUEUE, GC_CHECK_QUEUE, GC_DEL_QUEUE)	// deciseconds to wait before moving something up in the queue to the next level

	//Stat tracking
	var/delslasttick = 0            // number of del()'s we've done this tick
	var/gcedlasttick = 0            // number of things that gc'ed last tick
	var/totaldels = 0
	var/totalgcs = 0

	var/highest_del_time = 0
	var/highest_del_tickusage = 0

	var/list/pass_counts
	var/list/fail_counts

	var/list/items = list()         // Holds our qdel_item statistics datums
	var/harddel_halt = FALSE        // If true, will avoid harddeleting from the final queue; will still respect HARDDEL_NOW.

	//Queue
	var/list/queues

	#ifdef REFTRACKING_ENABLED
	var/list/reference_find_on_fail = list()
	#endif


/datum/controller/subsystem/garbage/PreInit()
	queues = new(GC_QUEUE_COUNT)
	pass_counts = new(GC_QUEUE_COUNT)
	fail_counts = new(GC_QUEUE_COUNT)
	for(var/i in 1 to GC_QUEUE_COUNT)
		queues[i] = list()
		pass_counts[i] = 0
		fail_counts[i] = 0

/datum/controller/subsystem/garbage/stat_entry(msg)
	var/list/counts = list()
	for (var/list/L in queues)
		counts += length(L)
	msg += "Q:[counts.Join(",")]|D:[delslasttick]|G:[gcedlasttick]|"
	msg += "GR:"
	if (!(delslasttick+gcedlasttick))
		msg += "n/a|"
	else
		msg += "[round((gcedlasttick/(delslasttick+gcedlasttick))*100, 0.01)]%|"

	msg += "TD:[totaldels]|TG:[totalgcs]|"
	if (!(totaldels+totalgcs))
		msg += "n/a|"
	else
		msg += "TGR:[round((totalgcs/(totaldels+totalgcs))*100, 0.01)]%"
	msg += " P:[pass_counts.Join(",")]"
	msg += "|F:[fail_counts.Join(",")]"
	..(msg)

/datum/controller/subsystem/garbage/Shutdown()
	//Adds the del() log to the qdel log file
	var/list/dellog = list()

	//sort by how long it's wasted hard deleting
	sortTim(items, cmp=/proc/cmp_qdel_item_time, associative = TRUE)
	for(var/path in items)
		var/datum/qdel_item/I = items[path]
		dellog += "Path: [path]"
		if (I.failures)
			dellog += "\tFailures: [I.failures]"
		dellog += "\tqdel() Count: [I.qdels]"
		dellog += "\tDestroy() Cost: [I.destroy_time]ms"
		if (I.hard_deletes)
			dellog += "\tTotal Hard Deletes [I.hard_deletes]"
			dellog += "\tTime Spent Hard Deleting: [I.hard_delete_time]ms"
		if (I.slept_destroy)
			dellog += "\tSleeps: [I.slept_destroy]"
		if (I.no_respect_force)
			dellog += "\tIgnored force: [I.no_respect_force] times"
		if (I.no_hint)
			dellog += "\tNo hint: [I.no_hint] times"
	log_qdel(dellog.Join("\n"))

/datum/controller/subsystem/garbage/fire()
	//the fact that this resets its processing each fire (rather then resume where it left off) is intentional.
	var/queue = GC_QUEUE_FILTER

	while (state == SS_RUNNING)
		switch (queue)
			if (GC_QUEUE_FILTER)
				HandleQueue(GC_QUEUE_FILTER)
				queue = GC_QUEUE_FILTER+1
			if (GC_QUEUE_CHECK)
				HandleQueue(GC_QUEUE_CHECK)
				queue = GC_QUEUE_CHECK+1
			if (GC_QUEUE_HARDDELETE)
				HandleQueue(GC_QUEUE_HARDDELETE)
				break

	if (state == SS_PAUSED) //make us wait again before the next run.
		state = SS_RUNNING

/datum/controller/subsystem/garbage/proc/HandleQueue(level = GC_QUEUE_FILTER)
	if (level == GC_QUEUE_FILTER)
		delslasttick = 0
		gcedlasttick = 0
	var/cut_off_time = world.time - collection_timeout[level] //ignore entries newer then this
	var/list/queue = queues[level]
	var/static/lastlevel
	var/static/count = 0
	if (count) //runtime last run before we could do this.
		var/c = count
		count = 0 //so if we runtime on the Cut, we don't try again.
		var/list/lastqueue = queues[lastlevel]
		lastqueue.Cut(1, c+1)

	lastlevel = level

// 1 from the hard reference in the queue, and 1 from `D` in the code below
#define REFS_WE_EXPECT 2

	//We do this rather then for(var/refID in queue) because that sort of for loop copies the whole list.
	//Normally this isn't expensive, but the gc queue can grow to 40k items, and that gets costly/causes overrun.
	for (var/i in 1 to length(queue))
		var/list/L = queue[i]
		if (length(L) < GC_QUEUE_ITEM_INDEX_COUNT)
			count++
			if (MC_TICK_CHECK)
				return
			continue

		var/queued_at_time = L[GC_QUEUE_ITEM_QUEUE_TIME]
		if(queued_at_time > cut_off_time)
			break // Everything else is newer, skip them
		count++

		var/datum/D = L[GC_QUEUE_ITEM_REF]

		// If that's all we've got, send er off
		if (refcount(D) == REFS_WE_EXPECT)
			++gcedlasttick
			++totalgcs
			pass_counts[level]++
			#ifdef REFTRACKING_ENABLED
			reference_find_on_fail -= ref(D) //It's deleted we don't care anymore.
			#endif
			if (MC_TICK_CHECK)
				return
			continue

		// Something's still referring to the qdel'd object.
		fail_counts[level]++

		switch (level)
			if (GC_QUEUE_CHECK)
				#ifdef REFTRACKING_ENABLED
				// Decides how many refs to look for (potentially)
				// Based off the remaining and the ones we can account for
				var/remaining_refs = refcount(D) - REFS_WE_EXPECT
				var/refID = ref(D)
				if(reference_find_on_fail[refID])
					INVOKE_ASYNC(D, TYPE_PROC_REF(/datum, find_references), remaining_refs)
				#ifdef GC_FAILURE_HARD_LOOKUP
				else
					INVOKE_ASYNC(D, TYPE_PROC_REF(/datum, find_references), remaining_refs)
				#endif
				reference_find_on_fail -= refID
				#endif
				var/type = D.type
				var/datum/qdel_item/I = items[type]
				if(!I.failures)
					to_world_log("GC: -- \ref[D] | [type] was unable to be GC'd --")
				I.failures++
			if (GC_QUEUE_HARDDELETE)
				if(harddel_halt)
					continue
				HardDelete(D)
				if (MC_TICK_CHECK)
					return
				continue

		Queue(D, level+1)

		if (MC_TICK_CHECK)
			return
	if (count)
		queue.Cut(1,count+1)
		count = 0

/datum/controller/subsystem/garbage/proc/Queue(datum/D, level = GC_QUEUE_FILTER)
	if (isnull(D))
		return
	if (level > GC_QUEUE_COUNT)
		HardDelete(D)
		return
	var/queue_time = world.time

	if(D.gc_destroyed <= 0) // hasn't been queued yet, or is queued for harddel/actively being qdeleted
		D.gc_destroyed = queue_time
	var/list/queue = queues[level]
	// not += for byond reasons
	// we include D.gc_destroyed to skip things under the cutoff
	queue[++queue.len] = list(queue_time, D, D.gc_destroyed)

//this is mainly to separate things profile wise.
/datum/controller/subsystem/garbage/proc/HardDelete(datum/D)
	var/time = world.timeofday
	var/tick = TICK_USAGE
	var/ticktime = world.time
	++delslasttick
	++totaldels
	var/type = D.type
	var/refID = "\ref[D]"

	del(D)

	tick = (TICK_USAGE-tick+((world.time-ticktime)/world.tick_lag*100))

	var/datum/qdel_item/I = items[type]

	I.hard_deletes++
	I.hard_delete_time += TICK_DELTA_TO_MS(tick)


	if (tick > highest_del_tickusage)
		highest_del_tickusage = tick
	time = world.timeofday - time
	if (!time && TICK_DELTA_TO_MS(tick) > 1)
		time = TICK_DELTA_TO_MS(tick)/100
	if (time > highest_del_time)
		highest_del_time = time
	if (time > 10)
		log_game("Error: [type]([refID]) took longer than 1 second to delete (took [time/10] seconds to delete)")
		message_admins("Error: [type]([refID]) took longer than 1 second to delete (took [time/10] seconds to delete).")
		postpone(time)

/datum/controller/subsystem/garbage/Recover()
	if (istype(SSgarbage.queues))
		for (var/i in 1 to SSgarbage.queues.len)
			queues[i] |= SSgarbage.queues[i]

/datum/controller/subsystem/garbage/proc/toggle_harddel_halt(new_state = FALSE)
	if(new_state == harddel_halt)
		return
	harddel_halt = new_state

/datum/qdel_item
	var/name = ""
	var/qdels = 0			//! Total number of times its passed thru qdel.
	var/destroy_time = 0	//! Total amount of milliseconds spent processing this type's Destroy().
	var/failures = 0		//! Times it was queued for soft deletion but failed to soft delete.
	var/hard_deletes = 0 	//! Different from failures because it also includes QDEL_HINT_HARDDEL deletions.
	var/hard_delete_time = 0//! Total amount of milliseconds spent hard deleting this type.
	var/no_respect_force = 0//! Number of times its not respected force=TRUE.
	var/no_hint = 0			//! Number of times it hasn't bothered to give a qdel hint.
	var/slept_destroy = 0	//! Number of times slept in its destroy.
	var/early_destroy = 0	//! Number of times it was destroyed before Initialize().

/datum/qdel_item/New(mytype)
	name = "[mytype]"

#ifdef REFTRACKING_ENABLED
/proc/qdel_and_find_ref_if_fail(datum/D, force = FALSE)
	SSgarbage.reference_find_on_fail["\ref[D]"] = TRUE
	qdel(D, force)
#endif

/// Should be treated as a replacement for the 'del' keyword.
/// Datums passed to this will be given a chance to clean up references to allow the GC to collect them.
/// Non-datums passed to this will be hard-deleted.
/proc/qdel(datum/D, force=FALSE)
	if(isnull(D))
		return
	if(!istype(D))
		del(D)
		return
	var/datum/qdel_item/I = SSgarbage.items[D.type]
	if (isnull(I))
		I = SSgarbage.items[D.type] = new /datum/qdel_item(D.type)

	I.qdels++

	if(isnull(D.gc_destroyed))
		D.gc_destroyed = GC_CURRENTLY_BEING_QDELETED
		var/start_time = world.time
		var/start_tick = world.tick_usage
		var/hint

		// Let our friend know they're about to get fucked up.
		if (isloc(D) && !(D:atom_flags & ATOM_FLAG_INITIALIZED))
			hint = D:EarlyDestroy(force)
			I.early_destroy += 1
		else
			hint = D.Destroy(force)

		if(world.time != start_time)
			I.slept_destroy++
		else
			I.destroy_time += TICK_USAGE_TO_MS(start_tick)

		if(isnull(D))
			return

		if(D.is_processing)
			get_stack_trace("[D] ([D.type]) was qdeleted while still processing on [D.is_processing]!")

		switch(hint)
			if (QDEL_HINT_QUEUE)		//qdel should queue the object for deletion.
				GC_CHECK_AM_NULLSPACE(D, "QDEL_HINT_QUEUE")
				SSgarbage.Queue(D)
			if (QDEL_HINT_IWILLGC)
				D.gc_destroyed = world.time
				return
			if (QDEL_HINT_LETMELIVE)	//qdel should let the object live after calling destory.
				if(!force)
					D.gc_destroyed = null //clear the gc variable (important!)
					return
				// Returning LETMELIVE after being told to force destroy
				// indicates the objects Destroy() does not respect force
				#ifdef REFTRACKING_ENABLED
				if(!I.no_respect_force)
					PRINT_STACK_TRACE("WARNING: [D.type] has been force deleted, but is \
						returning an immortal QDEL_HINT, indicating it does \
						not respect the force flag for qdel(). It has been \
						placed in the queue, further instances of this type \
						will also be queued.")
				#endif
				I.no_respect_force++

				SSgarbage.Queue(D)
			if (QDEL_HINT_HARDDEL)		//qdel should assume this object won't gc, and queue a hard delete using a hard reference to save time from the locate()
				GC_CHECK_AM_NULLSPACE(D, "QDEL_HINT_HARDDEL")
				SSgarbage.Queue(D, GC_QUEUE_HARDDELETE)
			if (QDEL_HINT_HARDDEL_NOW)	//qdel should assume this object won't gc, and hard del it post haste.
				SSgarbage.HardDelete(D)
			if (QDEL_HINT_FINDREFERENCE)//qdel will, if REFTRACKING_ENABLED is enabled, display all references to this object, then queue the object for deletion.
				SSgarbage.Queue(D)
				#ifdef REFTRACKING_ENABLED
				var/remaining_refs = refcount(D) - REFS_WE_EXPECT
				D.find_references(remaining_refs)
				#endif
			if (QDEL_HINT_IFFAIL_FINDREFERENCE)
				SSgarbage.Queue(D)
				#ifdef REFTRACKING_ENABLED
				SSgarbage.reference_find_on_fail["\ref[D]"] = TRUE
				#endif
			else
				#ifdef REFTRACKING_ENABLED
				if(!I.no_hint)
					PRINT_STACK_TRACE("WARNING: [D.type] is not returning a qdel hint. It is being placed in the queue. Further instances of this type will also be queued.")
				#endif
				I.no_hint++
				SSgarbage.Queue(D)
	else if(D.gc_destroyed == GC_CURRENTLY_BEING_QDELETED)
		CRASH("[D.type] destroy proc was called multiple times, likely due to a qdel loop in the Destroy logic")

#ifdef REFTRACKING_ENABLED

/datum/verb/find_refs()
	set category = "Debug"
	set name = "Find References"
	set src in world

	user_find_references()

/datum/proc/user_find_references()
	if(alert("Running this will lock everything up for about 5 minutes. Would you like to begin the search?", "Find References", "No", "Yes") == "No")
		return
	find_references()

/datum/proc/find_references(references_to_clear = INFINITY)
	running_find_references = type
	src.references_to_clear = references_to_clear
	if(usr && usr.client)
		if(usr.client.running_find_references)
			testing("CANCELLED search for references to a [usr.client.running_find_references].")
			usr.client.running_find_references = null
			running_find_references = null
			//restart the garbage collector
			SSgarbage.can_fire = 1
			SSgarbage.next_fire = world.time + world.tick_lag
			return

	//this keeps the garbage collector from failing to collect objects being searched for in here
	SSgarbage.can_fire = 0

	if(usr && usr.client)
		usr.client.running_find_references = type

	testing("Beginning search for references to a [type].")
	last_find_references = world.time

	//Yes we do actually need to do this. The searcher refuses to read weird lists
	//And global.vars is a really weird list
	var/list/normal_globals = list()
	for(var/global_var in global.vars)
		normal_globals[global_var] = global.vars[global_var]
	DoSearchVar(normal_globals, "(global) -> ") //globals
	testing("Finished searching globals")
	if(src.references_to_clear == 0) // Found all expected references!
		return

	for(var/atom/atom_thing) //atoms
		DoSearchVar(atom_thing, "World -> [atom_thing]")
		if(src.references_to_clear == 0) // Found all expected references!
			return
	testing("Finished searching atoms")

	for (var/datum/datum_thing) //datums
		DoSearchVar(datum_thing, "World -> [datum_thing]")
		if(src.references_to_clear == 0) // Found all expected references!
			return
	testing("Finished searching datums")

#ifndef FIND_REF_SKIP_CLIENTS
	// DO NOT RUN THIS ON A LIVE SERVER
	// IT WILL CRASH!!!
	for (var/client/client_thing) //clients
		DoSearchVar(client_thing, "World -> [client_thing]")
		if(src.references_to_clear == 0) // Found all expected references!
			return
	testing("Finished searching clients")
#endif

	testing("Completed search for references to a [type].")
	if(usr && usr.client)
		usr.client.running_find_references = null
	running_find_references = null

	//restart the garbage collector
	SSgarbage.can_fire = 1
	SSgarbage.next_fire = world.time + world.tick_lag

/datum/verb/qdel_then_find_references()
	set category = "Debug"
	set name = "qdel() then Find References"
	set src in world

	qdel(src, TRUE)		//Force.
	if(!running_find_references)
		find_references()

/datum/verb/qdel_then_if_fail_find_references()
	set category = "Debug"
	set name = "qdel() then Find References if GC failure"
	set src in world

	qdel_and_find_ref_if_fail(src, TRUE)

//Byond type ids
#define TYPEID_NULL "0"
#define TYPEID_NORMAL_LIST "f"
//helper macros
#define GET_TYPEID(ref) ( ( (length(ref) <= 10) ? "TYPEID_NULL" : copytext(ref, 4, length(ref)-6) ) )
#define IS_NORMAL_LIST(L) (GET_TYPEID("\ref[L]") == TYPEID_NORMAL_LIST)

/datum/proc/DoSearchVar(X, container_name, recursive_limit = 128)
	if(usr && usr.client && !usr.client.running_find_references)
		return
	if (!recursive_limit)
		testing("Recursion limit reached. [container_name]")
		return
	if(references_to_clear == 0)
		return

	#ifndef FIND_REF_NO_CHECK_TICK
	CHECK_TICK
	#endif

	if(istype(X, /datum))
		var/datum/datum_container = X
		if(datum_container.last_find_references == last_find_references)
			return

		datum_container.last_find_references = last_find_references
		var/list/vars_list = datum_container.vars

		var/is_atom = FALSE
		var/is_area = FALSE
		if(isatom(datum_container))
			is_atom = TRUE
			if(isarea(datum_container))
				is_area = TRUE
		for(var/varname in vars_list)
			#ifndef FIND_REF_NO_CHECK_TICK
			CHECK_TICK
			#endif
			//Fun fact, vis_locs don't count for references
			if(varname == "vars" || (is_atom && (varname == "vis_locs" || varname == "overlays" || varname == "underlays" || varname == "filters" || varname == "verbs" || (is_area && varname == "contents"))))
				continue
			var/variable = vars_list[varname]

			if(variable == src)
				testing("Found [src.type] \ref[src] in [datum_container.type]'s [varname] var. [container_name]")
				references_to_clear -= 1

			else if(islist(variable))
				DoSearchVar(variable, "[container_name] -> [varname] (list)", recursive_limit-1)

	else if(islist(X))
		var/normal = IS_NORMAL_LIST(X)
		for(var/I in X)
			#ifndef FIND_REF_NO_CHECK_TICK
			CHECK_TICK
			#endif
			if (I == src)
				testing("Found [src.type] \ref[src] in list [container_name].")

				// This is dumb as hell I'm sorry
				// I don't want the garbage subsystem to count as a ref for the purposes of this number
				// If we find all other refs before it I want to early exit, and if we don't I want to keep searching past it
				var/ignore_ref = FALSE
				var/list/queues = SSgarbage.queues
				for(var/list/queue in queues)
					if(X in queue)
						ignore_ref = TRUE
						break
				if(ignore_ref)
					testing("[container_name] does not count as a ref for our count")
				else
					references_to_clear -= 1
				if(references_to_clear == 0)
					testing("All references to [type] \ref[src] found, exiting.")
					return

			else if (I && !isnum(I) && normal)
				if(X[I] == src)
					testing("Found [src.type] \ref[src] in list [container_name]\[[I]\]")
					references_to_clear -= 1
					if(references_to_clear == 0)
						testing("All references to [type] \ref[src] found, exiting.")
						return
				else if(islist(X[I]))
					DoSearchVar(X[I], "[container_name]\[[I]\]", recursive_limit-1)

			else if (islist(I))
				var/list/Xlist = X
				DoSearchVar(I, "[container_name]\[[Xlist.Find(I)]\] -> list", recursive_limit-1)

#endif
