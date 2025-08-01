// ***************************************
// *********** Toxic Spit
// ***************************************
/datum/action/ability/activable/xeno/xeno_spit/toxic_spit
	name = "Toxic Spit"
	desc = "Spit a toxin at your target up to 7 tiles away, inflicting the Intoxicated debuff and dealing damage over time."
	keybinding_signals = list(
		KEYBINDING_NORMAL = COMSIG_XENOABILITY_TOXIC_SPIT,
	)

/datum/ammo/xeno/acid/toxic_spit
	name = "toxic spit"
	icon_state = "xeno_toxic"
	bullet_color = COLOR_PALE_GREEN_GRAY
	damage = 16
	spit_cost = 30
	ammo_behavior_flags = AMMO_XENO|AMMO_SKIPS_ALIENS
	/// The amount of stacks applied on hit.
	var/intoxication_stacks = 5

/datum/ammo/xeno/acid/toxic_spit/on_hit_mob(mob/target_mob, atom/movable/projectile/proj)
	if(!iscarbon(target_mob))
		return
	var/mob/living/carbon/target_carbon = target_mob
	if(target_carbon.issamexenohive(proj.firer))
		return
	if(HAS_TRAIT(target_carbon, TRAIT_INTOXICATION_IMMUNE))
		return
	if(target_carbon.has_status_effect(STATUS_EFFECT_INTOXICATED))
		var/datum/status_effect/stacking/intoxicated/debuff = target_carbon.has_status_effect(STATUS_EFFECT_INTOXICATED)
		debuff.add_stacks(intoxication_stacks)
	target_carbon.apply_status_effect(STATUS_EFFECT_INTOXICATED, intoxication_stacks)

// ***************************************
// *********** Toxic Slash
// ***************************************
/datum/action/ability/xeno_action/toxic_slash
	name = "Toxic Slash"
	action_icon_state = "neuroclaws_off"
	action_icon = 'icons/Xeno/actions/sentinel.dmi'
	desc = "Imbue your claws with acid for a short duration, inflicting lasting effects on your victims."
	cooldown_duration = 10 SECONDS
	ability_cost = 100
	//use_state_flags = ABILITY_USE_BUCKLED
	keybinding_signals = list(
		KEYBINDING_NORMAL = COMSIG_XENOABILITY_TOXIC_SLASH,
	)
	/// The amount of stacks to apply per hit.
	var/intoxication_stacks = 0
	/// The remaining amount of Toxic Slashes.
	var/remaining_slashes = 0
	/// Timer for the ability; we reference this to delete the timer if the effect lapses before the timer does.
	var/ability_duration
	/// The amount of health to heal the owner multiplied by stack amount whenever Intoxicated status effect ticks.
	var/healing_per_stack = 0
	/// Used for particles. Holds the particles instead of the mob. See particle_holder for documentation.
	var/obj/effect/abstract/particle_holder/particle_holder

/datum/action/ability/xeno_action/toxic_slash/action_activate()
	. = ..()
	intoxication_stacks = SENTINEL_TOXIC_SLASH_STACKS_PER + xeno_owner.xeno_caste.additional_stacks
	remaining_slashes = SENTINEL_TOXIC_SLASH_COUNT
	ability_duration = addtimer(CALLBACK(src, PROC_REF(toxic_slash_deactivate), xeno_owner), SENTINEL_TOXIC_SLASH_DURATION, TIMER_STOPPABLE) //Initiate the timer and set the timer ID for reference
	RegisterSignal(xeno_owner, COMSIG_XENOMORPH_ATTACK_LIVING, PROC_REF(toxic_slash))
	xeno_owner.balloon_alert(xeno_owner, "Toxic Slash active")
	xeno_owner.playsound_local(xeno_owner, 'sound/voice/alien/drool2.ogg', 25)
	action_icon_state = "neuroclaws_on"
	particle_holder = new(owner, /particles/toxic_slash)
	particle_holder.pixel_x = 9
	particle_holder.pixel_y = 2
	succeed_activate()
	add_cooldown()

///Called when Toxic Slash is active.
/datum/action/ability/xeno_action/toxic_slash/proc/toxic_slash(datum/source, mob/living/target, damage, list/damage_mod, list/armor_mod)
	SIGNAL_HANDLER
	var/mob/living/carbon/xeno_target = target
	if(HAS_TRAIT(xeno_target, TRAIT_INTOXICATION_IMMUNE))
		xeno_target.balloon_alert(xeno_owner, "Immune to Intoxication")
		return
	playsound(xeno_target, 'sound/effects/spray3.ogg', 20, TRUE)
	var/datum/status_effect/stacking/intoxicated/debuff = xeno_target.has_status_effect(STATUS_EFFECT_INTOXICATED)
	if(debuff)
		debuff.add_stacks(intoxication_stacks)
		debuff.xenomorph_to_heal = xeno_owner
		debuff.healing_per_stack = healing_per_stack
	else
		xeno_target.apply_status_effect(STATUS_EFFECT_INTOXICATED, intoxication_stacks, xeno_owner, healing_per_stack)
	remaining_slashes-- //Decrement the toxic slash count
	if(!remaining_slashes) //Deactivate if we have no toxic slashes remaining
		toxic_slash_deactivate(xeno_owner)

///Called when Toxic Slash expires.
/datum/action/ability/xeno_action/toxic_slash/proc/toxic_slash_deactivate(mob/living/carbon/xenomorph/xeno_owner)
	UnregisterSignal(xeno_owner, COMSIG_XENOMORPH_ATTACK_LIVING)
	remaining_slashes = 0
	deltimer(ability_duration) // Delete the timer so we don't have mismatch issues, and so we don't potentially try to deactivate the ability twice
	ability_duration = null
	QDEL_NULL(particle_holder)
	xeno_owner.balloon_alert(xeno_owner, "Toxic Slash over") //Let the user know
	xeno_owner.playsound_local(xeno_owner, 'sound/voice/hiss5.ogg', 25)
	action_icon_state = "neuroclaws_off"

/datum/action/ability/xeno_action/toxic_slash/on_cooldown_finish()
	owner.playsound_local(owner, 'sound/effects/alien/new_larva.ogg', 25, 0, 1)
	owner.balloon_alert(owner, "Toxic Slash ready")
	return ..()

/particles/toxic_slash
	icon = 'icons/effects/particles/generic_particles.dmi'
	icon_state = "x"
	width = 100
	height = 100
	count = 1000
	spawning = 4
	lifespan = 9
	fade = 10
	grow = 0.2
	velocity = list(0, 0)
	position = generator(GEN_CIRCLE, 10, 10, NORMAL_RAND)
	drift = generator(GEN_VECTOR, list(0, -0.15), list(0, 0.15))
	gravity = list(0, 0.4)
	scale = generator(GEN_VECTOR, list(0.3, 0.3), list(0.9,0.9), NORMAL_RAND)
	rotation = 0
	spin = generator(GEN_NUM, 10, 20)
	color = "#7DCC00"

// ***************************************
// *********** Drain Sting
// ***************************************
/datum/action/ability/activable/xeno/drain_sting
	name = "Drain Sting"
	action_icon_state = "neuro_sting"
	action_icon = 'icons/Xeno/actions/sentinel.dmi'
	desc = "Sting your victim, draining them and gaining benefits if they are Intoxicated."
	cooldown_duration = 25 SECONDS
	ability_cost = 75
	target_flags = ABILITY_MOB_TARGET
	use_state_flags = ABILITY_USE_BUCKLED
	keybinding_signals = list(
		KEYBINDING_NORMAL = COMSIG_XENOABILITY_DRAIN_STING,
	)
	/// How far can the target be in order for the ability to work?
	var/targetable_range = 1
	/// If the ability was used from a range that was above 1, then all effects are mulitplied by this value.
	var/ranged_effectiveness = 0
	/// If the target has any xeno-chemicals in them, how many units will be counted as one stack of Intoxicated? Only activated if it is more than 1.
	var/xenochemicals_unit_per_stack = 0

/datum/action/ability/activable/xeno/drain_sting/can_use_ability(atom/A, silent = FALSE, override_flags)
	. = ..()
	if(!.)
		return FALSE
	if(!istype(A, /mob/living/carbon/human))
		if(!silent)
			A.balloon_alert(owner, "Cannot sting")
		return FALSE
	var/mob/living/carbon/target = A
	if((get_dist(owner, target) > targetable_range) || !line_of_sight(owner, target))
		if(!silent)
			target.balloon_alert(owner, "Cannot reach")
		return FALSE
	if(HAS_TRAIT(target, TRAIT_INTOXICATION_IMMUNE))
		target.balloon_alert(owner, "Immune to intoxication")
		return FALSE
	if(!target.has_status_effect(STATUS_EFFECT_INTOXICATED))
		target.balloon_alert(owner, "Not intoxicated")
		return FALSE

/datum/action/ability/activable/xeno/drain_sting/use_ability(atom/A)
	var/mob/living/carbon/xeno_target = A
	var/datum/status_effect/stacking/intoxicated/debuff = xeno_target.has_status_effect(STATUS_EFFECT_INTOXICATED)

	var/bonus_potency = 0
	if(xenochemicals_unit_per_stack)
		for(var/datum/reagent/target_reagent AS in xeno_target.reagents.reagent_list)
			if(!is_type_in_typecache(target_reagent, GLOB.defiler_toxins_typecache_list))
				continue
			bonus_potency += xeno_target.reagents.get_reagent_amount(target_reagent)
		bonus_potency = round(bonus_potency) / xenochemicals_unit_per_stack
	var/drain_potency = (debuff.stacks + bonus_potency) * SENTINEL_DRAIN_MULTIPLIER * (xeno_owner.Adjacent(xeno_target) ? 1 : ranged_effectiveness)
	if(debuff.stacks > debuff.max_stacks - 10)
		xeno_target.emote("scream")
		xeno_owner.apply_status_effect(STATUS_EFFECT_DRAIN_SURGE)
		new /obj/effect/temp_visual/drain_sting_crit(get_turf(xeno_target))
	xeno_target.adjustFireLoss(drain_potency / 5)
	xeno_target.AdjustKnockdown(max(0.1 SECONDS, debuff.stacks - 10))
	HEAL_XENO_DAMAGE(xeno_owner, drain_potency, FALSE)
	xeno_owner.gain_plasma(drain_potency * 3.5)
	xeno_owner.do_attack_animation(xeno_target, ATTACK_EFFECT_DRAIN_STING)
	playsound(owner.loc, 'sound/effects/alien/tail_swipe1.ogg', 30)
	xeno_owner.visible_message(message = span_xenowarning("\A [xeno_owner] stings [xeno_target]!"), self_message = span_xenowarning("We sting [xeno_target]!"))
	debuff.add_stacks(-round(debuff.stacks * 0.7))
	succeed_activate()
	add_cooldown()
	GLOB.round_statistics.sentinel_drain_stings++
	SSblackbox.record_feedback("tally", "round_statistics", 1, "sentinel_drain_stings")

/datum/action/ability/activable/xeno/drain_sting/on_cooldown_finish()
	playsound(owner.loc, 'sound/voice/alien/drool1.ogg', 50, 1)
	owner.balloon_alert(owner, "Drain Sting ready")
	return ..()

/obj/effect/temp_visual/drain_sting_crit
	name = "drain_sting"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "drain_sting_crit"
	duration = 3.5
	pixel_x = -18
	pixel_y = -18

// ***************************************
// *********** Toxic Grenade
// ***************************************
/datum/action/ability/activable/xeno/toxic_grenade
	name = "Toxic grenade"
	action_icon_state = "gas mine"
	action_icon = 'icons/Xeno/actions/sentinel.dmi'
	desc = "Throws a lump of compressed acidic gases, which will inflict damage over time and Intoxicate victims."
	ability_cost = 200
	cooldown_duration = 50 SECONDS
	keybinding_signals = list(
		KEYBINDING_NORMAL = COMSIG_XENOABILITY_TOXIC_GRENADE,
	)
	///Type of nade to be thrown
	var/nade_type = /obj/item/explosive/grenade/smokebomb/xeno

/datum/action/ability/activable/xeno/toxic_grenade/use_ability(atom/A)
	. = ..()
	succeed_activate()
	add_cooldown()
	var/obj/item/explosive/grenade/smokebomb/xeno/nade = new nade_type(get_turf(owner))
	nade.throw_at(A, 5, 1, owner, TRUE)
	nade.activate(owner)
	owner.visible_message(span_warning("[owner] vomits up a bulbous lump and throws it at [A]!"), span_warning("We vomit up a bulbous lump and throw it at [A]!"))

/obj/item/explosive/grenade/smokebomb/xeno
	name = "toxic grenade"
	desc = "A fleshy mass that bounces along the ground. It seems to be heating up."
	greyscale_colors = "#42A500"
	greyscale_config = /datum/greyscale_config/xenogrenade
	det_time = 15
	smoke_duration = 4
	dangerous = TRUE
	smoketype = /datum/effect_system/smoke_spread/xeno/toxic
	arm_sound = 'sound/voice/alien/yell_alt.ogg'
	smokeradius = 3

/obj/item/explosive/grenade/smokebomb/xeno/update_overlays()
	. = ..()
	if(active)
		. += image('icons/obj/items/grenade.dmi', "xenonade_active")

//Neuro variant
/datum/action/ability/activable/xeno/toxic_grenade/neuro
	name = "Neuro grenade"
	action_icon_state = "gas mine"
	action_icon = 'icons/Xeno/actions/sentinel.dmi'
	desc = "Throws a lump of compressed neurotoxin, which explodes into a small gas cloud."
	ability_cost = 200
	cooldown_duration = 50 SECONDS
	keybinding_signals = list(
		KEYBINDING_NORMAL = COMSIG_XENOABILITY_TOXIC_GRENADE,
	)
	nade_type = /obj/item/explosive/grenade/smokebomb/xeno/neuro

/obj/item/explosive/grenade/smokebomb/xeno/neuro
	name = "Neuro grenade"
	desc = "A fleshy mass that bounces along the ground. It seems to be heating up."
	greyscale_colors = "#bfc208"
	greyscale_config = /datum/greyscale_config/xenogrenade
	det_time = 15
	smoke_duration = 4
	dangerous = TRUE
	smoketype = /datum/effect_system/smoke_spread/xeno/neuro/light
	arm_sound = 'sound/voice/alien/yell_alt.ogg'
	smokeradius = 3
