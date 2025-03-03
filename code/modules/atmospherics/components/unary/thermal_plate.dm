#define RADIATION_CAPACITY 30000 //Radiation isn't particularly effective (TODO BALANCE)


// LMAO? This should probably be removed.
// Check Q2 2025 if this is gone yet or not.
/obj/machinery/atmospherics/unary/thermal_plate
//Based off Heat Reservoir and Space Heater
//Transfers heat between a pipe system and environment, based on which has a greater thermal energy concentration

	icon = 'icons/obj/atmospherics/cold_sink.dmi'
	icon_state = "intact_off"

	name = "thermal transfer plate"
	desc = "A device that transfers heat to and from an area."
	uncreated_component_parts = null
	frame_type = /obj/item/pipe
	construct_state = /decl/machine_construction/pipe
	interact_offline = TRUE

/obj/machinery/atmospherics/unary/thermal_plate/on_update_icon()
	if(LAZYLEN(nodes_to_networks))
		icon_state = "intact_off"
	else
		icon_state = "exposed"

/obj/machinery/atmospherics/unary/thermal_plate/Process()
	..()

	var/datum/gas_mixture/environment = loc?.return_air()
	if(!environment)
		return

	//Get processable air sample and thermal info from environment

	var/transfer_moles = 0.25 * environment.get_total_moles()
	var/datum/gas_mixture/external_removed = environment.remove(transfer_moles)
	if (external_removed?.get_total_moles() < 10)
		return radiate()

	//Get same info from connected gas

	var/internal_transfer_moles = 0.25 * air_contents.get_total_moles()
	var/datum/gas_mixture/internal_removed = air_contents.remove(internal_transfer_moles)

	if (!internal_removed)
		environment.merge(external_removed)
		return 1

	var/combined_heat_capacity = internal_removed.heat_capacity() + external_removed.heat_capacity()
	var/combined_energy = internal_removed.temperature * internal_removed.heat_capacity() + external_removed.heat_capacity() * external_removed.temperature

	if(!combined_heat_capacity) combined_heat_capacity = 1
	var/final_temperature = combined_energy / combined_heat_capacity

	external_removed.temperature = final_temperature
	environment.merge(external_removed)

	internal_removed.temperature = final_temperature
	air_contents.merge(internal_removed)

	update_networks()

	return 1

/obj/machinery/atmospherics/unary/thermal_plate/proc/radiate()

	var/internal_transfer_moles = 0.25 * air_contents.get_total_moles()
	var/datum/gas_mixture/internal_removed = air_contents.remove(internal_transfer_moles)

	if (!internal_removed)
		return 1

	var/combined_heat_capacity = internal_removed.heat_capacity() + RADIATION_CAPACITY
	var/combined_energy = internal_removed.temperature * internal_removed.heat_capacity() + (RADIATION_CAPACITY * 6.4)

	var/final_temperature = combined_energy / combined_heat_capacity

	internal_removed.temperature = final_temperature
	air_contents.merge(internal_removed)

	update_networks()

	return 1