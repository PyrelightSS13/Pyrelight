/datum/map/karzerfeste
	hud_icons        = 'maps/karzerfeste/jobs/icons.dmi'
	default_job_type = /datum/job/karzerfeste/local/traveller
	allowed_jobs     = list(
		/datum/job/karzerfeste/guild/master,
		/datum/job/karzerfeste/guild/clerk,
		/datum/job/karzerfeste/guild/adventurer,
		/datum/job/karzerfeste/guild/greenhorn,
		/datum/job/karzerfeste/guild/armorer,
		/datum/job/karzerfeste/guild/merchant,
		/datum/job/karzerfeste/keep/cook,
		/datum/job/karzerfeste/keep/builder,
		/datum/job/karzerfeste/keep/servant,
		/datum/job/karzerfeste/keep/inn,
		/datum/job/karzerfeste/local/traveller,
		/datum/job/karzerfeste/local/forester,
		/datum/job/karzerfeste/local/miner,
		/datum/job/karzerfeste/local/farmer,
		/datum/job/karzerfeste/shrine/keeper,
		/datum/job/karzerfeste/shrine/attendant,
		/datum/job/karzerfeste/shrine/cleric,
		/datum/job/karzerfeste/shrine/gravekeeper,
		/datum/job/karzerfeste/kingdom/representative,
		/datum/job/karzerfeste/kingdom/honor_guard,
		/datum/job/karzerfeste/steppe/representative,
		/datum/job/karzerfeste/steppe/honor_guard
	)
	default_department_type = /decl/department/karzerfeste/locals
	species_to_job_whitelist = list(
		/decl/species/grafadreka = list(
			/datum/job/karzerfeste/local/traveller
		)
	)

/decl/department/karzerfeste
	abstract_type       = /decl/department/karzerfeste
	noun                = "faction"
	noun_adj            = "faction"
	announce_channel    = null

/datum/job/karzerfeste
	abstract_type       = /datum/job/karzerfeste
	min_skill           = list()
	// if you consider adding something like literacy to this list to make it rarer/more exclusive
	// consider making the higher levels cost more points instead
	max_skill           = list(
		SKILL_CHEMISTRY = SKILL_BASIC, // this is the domain of the herbalist
	)
	skill_points        = 20
	spawn_positions     = 1
	total_positions     = 1
