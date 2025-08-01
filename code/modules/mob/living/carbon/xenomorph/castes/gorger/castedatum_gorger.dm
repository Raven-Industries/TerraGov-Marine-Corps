/datum/xeno_caste/gorger
	caste_name = "Gorger"
	display_name = "Gorger"
	upgrade_name = ""
	caste_desc = "A frightening looking, bulky alien creature that drips with a familiar red fluid."
	base_strain_type = /mob/living/carbon/xenomorph/gorger
	caste_type_path = /mob/living/carbon/xenomorph/gorger
	primordial_message = "There is nothing we can't withstand."

	tier = XENO_TIER_THREE
	upgrade = XENO_UPGRADE_BASETYPE
	wound_type = "gorger" //used to match appropriate wound overlays

	// *** Melee Attacks *** //
	melee_damage = 22

	// *** Speed *** //
	speed = -0.4
	weeds_speed_mod = -0.2

	// *** Plasma *** //
	plasma_max = 400
	plasma_gain = 0
	plasma_regen_limit = 0
	plasma_icon_state = "fury"

	// *** Health *** //
	max_health = 700

	// *** Evolution *** //
	upgrade_threshold = TIER_THREE_THRESHOLD

	deevolves_to = /datum/xeno_caste/warrior

	// *** Flags *** //
	caste_flags = CASTE_INNATE_PLASMA_REGEN|CASTE_PLASMADRAIN_IMMUNE|CASTE_EVOLUTION_ALLOWED
	caste_traits = list(TRAIT_CAN_TEAR_HOLE, TRAIT_CAN_DISABLE_MINER)

	// *** Defense *** //
	soft_armor = list(MELEE = 20, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 10, BIO = 20, FIRE = 20, ACID = 20)

	// *** Minimap Icon *** //
	minimap_icon = "gorger"

	// *** Gorger Abilities *** //
	overheal_max = 275
	drain_plasma_gain = 40
	carnage_plasma_gain = 40
	feast_plasma_drain = 20

	actions = list(
		/datum/action/ability/xeno_action/xeno_resting,
		/datum/action/ability/xeno_action/watch_xeno,
		/datum/action/ability/activable/xeno/psydrain/free,
		/datum/action/ability/activable/xeno/psychic_link,
		/datum/action/ability/activable/xeno/drain,
		/datum/action/ability/activable/xeno/transfusion,
		/datum/action/ability/activable/xeno/carnage,
		/datum/action/ability/activable/xeno/feast,
		/datum/action/ability/activable/xeno/devour,
	)

	mutations = list(
		/datum/mutation_upgrade/shell/unmoving_link,
		/datum/mutation_upgrade/spur/necrotic_link,
		/datum/mutation_upgrade/veil/burst_healing
	)

/datum/xeno_caste/gorger/normal
	upgrade = XENO_UPGRADE_NORMAL

/datum/xeno_caste/gorger/primordial
	upgrade_name = "Primordial"
	caste_desc = "Being within mere eyeshot of this hulking monstrosity fills you with a deep, unshakeable sense of unease. You are unsure if you can even harm it."
	upgrade = XENO_UPGRADE_PRIMO

	actions = list(
		/datum/action/ability/xeno_action/xeno_resting,
		/datum/action/ability/xeno_action/watch_xeno,
		/datum/action/ability/activable/xeno/psydrain/free,
		/datum/action/ability/activable/xeno/psychic_link,
		/datum/action/ability/activable/xeno/drain,
		/datum/action/ability/activable/xeno/transfusion,
		/datum/action/ability/activable/xeno/oppose,
		/datum/action/ability/activable/xeno/carnage,
		/datum/action/ability/activable/xeno/feast,
		/datum/action/ability/activable/xeno/devour,
	)
