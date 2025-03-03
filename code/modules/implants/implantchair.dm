//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/machinery/implantchair
	name = "loyalty implanter"
	desc = "Used to implant occupants with loyalty implants."
	icon = 'icons/obj/machines/implantchair.dmi'
	icon_state = "implantchair"
	density = TRUE
	opacity = FALSE
	anchored = TRUE

	var/ready = TRUE
	var/list/obj/item/implant/loyalty/implant_list = list()
	var/max_implants = 5
	var/injection_cooldown = 600
	var/replenish_cooldown = 6000
	var/mob/living/occupant = null
	var/injecting = FALSE

/obj/machinery/implantchair/Initialize()
	. = ..()
	add_implants()

/obj/machinery/implantchair/interface_interact(user)
	interact(user)
	return TRUE

/obj/machinery/implantchair/interact(mob/user)
	user.set_machine(src)
	var/health_text = ""
	if(src.occupant)
		if(src.occupant.current_health <= -100)
			health_text = "<FONT color=red>Dead</FONT>"
		else if(src.occupant.current_health < 0)
			health_text = "<FONT color=red>[round(src.occupant.current_health,0.1)]</FONT>"
		else
			health_text = "[round(src.occupant.current_health,0.1)]"

	var/dat ="<B>Implanter Status</B><BR>"

	dat +="<B>Current occupant:</B> [src.occupant ? "<BR>Name: [src.occupant]<BR>Health: [health_text]<BR>" : "<FONT color=red>None</FONT>"]<BR>"
	dat += "<B>Implants:</B> [src.implant_list.len ? "[implant_list.len]" : "<A href='byond://?src=\ref[src];replenish=1'>Replenish</A>"]<BR>"
	if(src.occupant)
		dat += "[src.ready ? "<A href='byond://?src=\ref[src];implant=1'>Implant</A>" : "Recharging"]<BR>"
	user.set_machine(src)
	show_browser(user, dat, "window=implant")
	onclose(user, "implant")


/obj/machinery/implantchair/OnTopic(mob/user, href_list)
	if((. = ..()))
		return
	if(!ready) // avoid topic hacking
		return TOPIC_NOACTION
	if(href_list["implant"] && occupant)
		injecting = TRUE
		go_out()
		ready = FALSE
		addtimer(CALLBACK(src, PROC_REF(make_ready)), injection_cooldown)

	if(href_list["replenish"])
		ready = 0
		addtimer(CALLBACK(src, PROC_REF(add_implants)), replenish_cooldown)
		addtimer(CALLBACK(src, PROC_REF(make_ready)), replenish_cooldown)

/obj/machinery/implantchair/proc/make_ready()
	ready = TRUE

/obj/machinery/implantchair/grab_attack(obj/item/grab/grab, mob/user)
	var/mob/living/victim = grab.get_affecting_mob()
	if(istype(victim) && victim.can_enter_cryopod(user) && put_mob(victim))
		qdel(grab)
		updateUsrDialog()
		return TRUE
	return ..()

/obj/machinery/implantchair/proc/go_out(var/mob/M)
	if(!( src.occupant ))
		return
	if(M == occupant) // so that the guy inside can't eject himself -Agouri
		return
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	occupant.dropInto(loc)
	if(injecting)
		implant(src.occupant)
		injecting = FALSE
	src.occupant = null
	icon_state = "implantchair"
	return


/obj/machinery/implantchair/proc/put_mob(mob/living/M)
	if(!ishuman(M))
		to_chat(usr, "<span class='warning'>\The [src] cannot hold this!</span>")
		return
	if(src.occupant)
		to_chat(usr, "<span class='warning'>\The [src] is already occupied!</span>")
		return
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.forceMove(src)
	src.occupant = M
	src.add_fingerprint(usr)
	icon_state = "implantchair_on"
	return 1


/obj/machinery/implantchair/proc/implant(var/mob/M)
	if (!ishuman(M))
		return
	if(!implant_list.len)	return
	for(var/obj/item/implant/loyalty/imp in implant_list)
		if(!imp)	continue
		if(istype(imp, /obj/item/implant/loyalty))
			M.visible_message(SPAN_NOTICE("\The [M] has been implanted by \the [src]."))
			if(imp.implanted(M))
				imp.forceMove(M)
				imp.imp_in = M
				imp.implanted = 1
			implant_list -= imp
			break

/obj/machinery/implantchair/proc/add_implants()
	for(var/i=0, i<src.max_implants, i++)
		var/obj/item/implant/loyalty/I = new /obj/item/implant/loyalty(src)
		implant_list += I

/obj/machinery/implantchair/verb/get_out()
	set name = "Eject occupant"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != CONSCIOUS)
		return
	src.go_out(usr)
	add_fingerprint(usr)

/obj/machinery/implantchair/verb/move_inside()
	set name = "Move Inside"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != CONSCIOUS || stat & (NOPOWER|BROKEN))
		return
	put_mob(usr)