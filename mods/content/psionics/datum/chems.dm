/decl/material/liquid/crystal_agent/do_material_check(var/mob/living/M)
	. = !!M.get_ability_handler(/datum/ability_handler/psionics) ? /decl/material/nullglass : ..()

/decl/material/liquid/glowsap/gleam/affect_overdose(mob/living/M, total_dose)
	..()
	var/datum/ability_handler/psionics/psi = M.get_ability_handler(/datum/ability_handler/psionics)
	psi?.check_latency_trigger(30, "a [name] overdose")
