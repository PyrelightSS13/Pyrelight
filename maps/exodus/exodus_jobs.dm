/decl/spawnpoint/gateway
	name = "Gateway"
	spawn_announcement = "has completed translation from offsite gateway"
	uid = "spawn_exodus_gateway"

/obj/abstract/landmark/latejoin/gateway
	spawn_decl = /decl/spawnpoint/gateway

/datum/map/exodus
	default_job_type = /datum/job/standard/assistant
	default_department_type = /decl/department/civilian
	id_hud_icons = 'maps/exodus/hud.dmi'
	allowed_jobs = list(
		/datum/job/standard/captain,
		/datum/job/hop,
		/datum/job/chaplain,
		/datum/job/bartender,
		/datum/job/chef,
		/datum/job/hydro,
		/datum/job/qm,
		/datum/job/cargo_tech,
		/datum/job/mining,
		/datum/job/janitor,
		/datum/job/librarian,
		/datum/job/lawyer,
		/datum/job/standard/chief_engineer,
		/datum/job/standard/engineer,
		/datum/job/standard/cmo,
		/datum/job/standard/doctor,
		/datum/job/standard/chemist,
		/datum/job/counselor,
		/datum/job/standard/rd,
		/datum/job/standard/scientist,
		/datum/job/standard/roboticist,
		/datum/job/standard/hos,
		/datum/job/standard/detective,
		/datum/job/standard/warden,
		/datum/job/standard/officer,
		/datum/job/standard/robot,
		/datum/job/standard/computer
	)

	species_to_job_whitelist = list(
		/decl/species/adherent = list(
			/datum/job/standard/computer,
			/datum/job/standard/robot,
			/datum/job/standard/assistant,
			/datum/job/janitor,
			/datum/job/chef,
			/datum/job/bartender,
			/datum/job/cargo_tech,
			/datum/job/standard/engineer,
			/datum/job/standard/roboticist,
			/datum/job/standard/chemist,
			/datum/job/standard/scientist,
			/datum/job/mining
		),
		/decl/species/utility_frame = list(
			/datum/job/standard/computer,
			/datum/job/standard/robot,
			/datum/job/standard/assistant,
			/datum/job/janitor,
			/datum/job/chef,
			/datum/job/bartender,
			/datum/job/cargo_tech,
			/datum/job/standard/engineer,
			/datum/job/standard/roboticist,
			/datum/job/standard/chemist,
			/datum/job/standard/scientist,
			/datum/job/mining
		),
		/decl/species/serpentid = list(
			/datum/job/standard/computer,
			/datum/job/standard/robot,
			/datum/job/standard/assistant,
			/datum/job/janitor,
			/datum/job/chef,
			/datum/job/bartender,
			/datum/job/cargo_tech,
			/datum/job/standard/roboticist,
			/datum/job/standard/chemist
		)
	)

#define HUMAN_ONLY_JOBS /datum/job/standard/captain, /datum/job/hop, /datum/job/standard/hos
	species_to_job_blacklist = list(
		/decl/species/unathi = list(
			HUMAN_ONLY_JOBS
		),
		/decl/species/tajaran = list(
			HUMAN_ONLY_JOBS
		)
	)

#undef HUMAN_ONLY_JOBS
