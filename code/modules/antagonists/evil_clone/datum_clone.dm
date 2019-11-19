/datum/antagonist/evil_clone //TODO: most of this
	name = "Evil Clone"
	roundend_category = "traitors"
	antagpanel_category = "Evil Clone"
	job_rank = ROLE_TRAITOR
	antag_moodlet = /datum/mood_event/focused
	var/special_role = ROLE_TRAITOR
	var/employer = "The Syndicate"
	var/give_objectives = TRUE
	var/should_give_codewords = TRUE
	var/should_equip = TRUE
	var/traitor_kind = TRAITOR_HUMAN //Set on initial assignment
	can_hijack = HIJACK_HIJACKER
