#define BASE_HEAL_RATE -0.0125


//Largely negative status effects go here, even if they have small benificial effects
//STUN EFFECTS
/datum/status_effect/incapacitating
	tick_interval = 0
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null

/datum/status_effect/incapacitating/on_creation(mob/living/new_owner, set_duration)
	if(new_owner.status_flags & GODMODE)
		qdel(src)
		return
	if(isnum(set_duration))
		duration = set_duration
	return ..()

//STAGGERED
/datum/status_effect/incapacitating/stagger
	id = "stagger"

/datum/status_effect/incapacitating/stagger/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_STAGGERED, TRAIT_STATUS_EFFECT(id))
	owner.adjust_mob_scatter(5)

/datum/status_effect/incapacitating/stagger/on_remove()
	REMOVE_TRAIT(owner, TRAIT_STAGGERED, TRAIT_STATUS_EFFECT(id))
	owner.adjust_mob_scatter(-5)

//STUN
/datum/status_effect/incapacitating/stun
	id = "stun"

/datum/status_effect/incapacitating/stun/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_IMMOBILE, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/stun/on_remove()
	REMOVE_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_IMMOBILE, TRAIT_STATUS_EFFECT(id))
	return ..()

//KNOCKDOWN
/datum/status_effect/incapacitating/knockdown
	id = "knockdown"

/datum/status_effect/incapacitating/knockdown/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/knockdown/on_remove()
	REMOVE_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))
	return ..()

//IMMOBILIZED
/datum/status_effect/incapacitating/immobilized
	id = "immobilized"

/datum/status_effect/incapacitating/immobilized/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_IMMOBILE, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/immobilized/on_remove()
	REMOVE_TRAIT(owner, TRAIT_IMMOBILE, TRAIT_STATUS_EFFECT(id))
	return ..()

//PARALYZED
/datum/status_effect/incapacitating/paralyzed
	id = "paralyzed"

/datum/status_effect/incapacitating/paralyzed/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_IMMOBILE, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/paralyzed/on_remove()
	REMOVE_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_IMMOBILE, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))
	return ..()

//UNCONSCIOUS
/datum/status_effect/incapacitating/unconscious
	id = "unconscious"

/datum/status_effect/incapacitating/unconscious/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/unconscious/on_remove()
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/status_effect/incapacitating/unconscious/tick(delta_time)
	if(owner.getStaminaLoss())
		owner.adjustStaminaLoss(-0.3) //reduce stamina loss by 0.3 per tick, 6 per 2 seconds

//SLEEPING
/datum/status_effect/incapacitating/sleeping
	id = "sleeping"
	alert_type = /atom/movable/screen/alert/status_effect/asleep
	var/mob/living/carbon/carbon_owner
	var/mob/living/carbon/human/human_owner

/datum/status_effect/incapacitating/sleeping/on_creation(mob/living/new_owner)
	. = ..()
	if(.)
		if(iscarbon(owner)) //to avoid repeated istypes
			carbon_owner = owner
		if(ishuman(owner))
			human_owner = owner

/datum/status_effect/incapacitating/sleeping/Destroy()
	carbon_owner = null
	human_owner = null
	return ..()

/datum/status_effect/incapacitating/sleeping/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/sleeping/on_remove()
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/status_effect/incapacitating/sleeping/tick(delta_time)
	if(!owner.maxHealth)
		return
	var/health_ratio = owner.health / owner.maxHealth
	var/healing = BASE_HEAL_RATE //set for a base of 0.25 healed per 2-second interval asleep in a bed with covers.
	if((locate(/obj/structure/bed) in owner.loc))
		healing += (2 * BASE_HEAL_RATE)
	else if((locate(/obj/structure/table) in owner.loc))
		healing += BASE_HEAL_RATE
	if(locate(/obj/item/bedsheet) in owner.loc)
		healing += BASE_HEAL_RATE
		if((locate(/obj/item/toy/plush) in owner.loc)) // plushie bonus in bed with a blanket
			healing += 0.75 * BASE_HEAL_RATE // plushie bonus in bed with a blanket
	if(health_ratio > -0.5)
		owner.adjustBruteLoss(healing)
		owner.adjustFireLoss(healing)
		owner.adjustToxLoss(healing * 0.5, TRUE, TRUE)
		owner.adjustStaminaLoss(healing * 100)
		owner.adjustCloneLoss(healing * health_ratio * 0.8)
	if(human_owner?.drunkenness)
		human_owner.drunkenness *= 0.997 //reduce drunkenness by 0.3% per tick, 6% per 2 seconds
	if(prob(20))
		if(carbon_owner)
			carbon_owner.handle_dreams()
		if(prob(10) && owner.health > owner.get_crit_threshold())
			owner.emote("snore")

///Basically a temporary self-inflicted shutdown for maintenance
/datum/status_effect/incapacitating/repair_mode
	id = "repairing"
	tick_interval = 1 SECONDS
	///How much brute or burn per second
	var/healing_per_tick = 4
	///Whether the last tick made a sound effect or not
	var/last_sound

/datum/status_effect/incapacitating/repair_mode/on_apply()
	. = ..()
	if(!.)
		return
	//Robots and synths are generally resistant to blinding, so we apply an overlay directly instead
	owner.overlay_fullscreen("repair-mode", /atom/movable/screen/fullscreen/blind)
	ADD_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_IMMOBILE, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/repair_mode/on_remove()
	owner.clear_fullscreen("repair-mode")
	REMOVE_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_IMMOBILE, TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/status_effect/incapacitating/repair_mode/tick(delta_time)
	var/sound_to_play
	if(owner.getBruteLoss())
		owner.heal_limb_damage(healing_per_tick, 0, TRUE, TRUE)
		sound_to_play = 'sound/effects/robotrepair.ogg'
	else if(owner.getFireLoss())
		owner.heal_limb_damage(0, healing_per_tick, TRUE, TRUE)
		sound_to_play = 'sound/effects/robotrepair2.ogg'
	if(!sound_to_play || last_sound)
		last_sound = FALSE
		return
	last_sound = TRUE
	playsound(owner, sound_to_play, 50)



/**
 * Adjusts a timed status effect on the mob,taking into account any existing timed status effects.
 * This can be any status effect that takes into account "duration" with their initialize arguments.
 *
 * Positive durations will add deciseconds to the duration of existing status effects
 * or apply a new status effect of that duration to the mob.
 *
 * Negative durations will remove deciseconds from the duration of an existing version of the status effect,
 * removing the status effect entirely if the duration becomes less than zero (less than the current world time).
 *
 * duration - the duration, in deciseconds, to add or remove from the effect
 * effect - the type of status effect being adjusted on the mob
 * max_duration - optional - if set, positive durations will only be added UP TO the passed max duration
 */
/mob/living/proc/adjust_timed_status_effect(duration, effect, max_duration)
	if(!isnum(duration))
		CRASH("adjust_timed_status_effect: called with an invalid duration. (Got: [duration])")

	if(!ispath(effect, /datum/status_effect))
		CRASH("adjust_timed_status_effect: called with an invalid effect type. (Got: [effect])")

	// If we have a max duration set, we need to check our duration does not exceed it
	if(isnum(max_duration))
		if(max_duration <= 0)
			CRASH("adjust_timed_status_effect: Called with an invalid max_duration. (Got: [max_duration])")

		if(duration >= max_duration)
			duration = max_duration

	var/datum/status_effect/existing = has_status_effect(effect)
	if(existing)
		if(isnum(max_duration) && duration > 0)
			// Check the duration remaining on the existing status effect
			// If it's greater than / equal to our passed max duration, we don't need to do anything
			var/remaining_duration = existing.duration - world.time
			if(remaining_duration >= max_duration)
				return

			// Otherwise, add duration up to the max (max_duration - remaining_duration),
			// or just add duration if it doesn't exceed our max at all
			existing.duration += min(max_duration - remaining_duration, duration)

		else
			existing.duration += duration

		// If the duration was decreased and is now less 0 seconds,
		// qdel it / clean up the status effect immediately
		// (rather than waiting for the process tick to handle it)
		if(existing.duration <= world.time)
			qdel(existing)

	else if(duration > 0)
		apply_status_effect(effect, duration)

/**
 * Sets a timed status effect of some kind on a mob to a specific value.
 * If only_if_higher is TRUE, it will only set the value up to the passed duration,
 * so any pre-existing status effects of the same type won't be reduced down
 *
 * duration - the duration, in deciseconds, of the effect. 0 or lower will either remove the current effect or do nothing if none are present
 * effect - the type of status effect given to the mob
 * only_if_higher - if TRUE, we will only set the effect to the new duration if the new duration is longer than any existing duration
 */
/mob/living/proc/set_timed_status_effect(duration, effect, only_if_higher = FALSE)
	if(!isnum(duration))
		CRASH("set_timed_status_effect: called with an invalid duration. (Got: [duration])")

	if(!ispath(effect, /datum/status_effect))
		CRASH("set_timed_status_effect: called with an invalid effect type. (Got: [effect])")

	var/datum/status_effect/existing = has_status_effect(effect)
	if(existing)
		// set_timed_status_effect to 0 technically acts as a way to clear effects,
		// though remove_status_effect would achieve the same goal more explicitly.
		if(duration <= 0)
			qdel(existing)
			return

		if(only_if_higher)
			// If the existing status effect has a higher remaining duration
			// than what we aim to set it to, don't downgrade it - do nothing (return)
			var/remaining_duration = existing.duration - world.time
			if(remaining_duration >= duration)
				return

		// Set the duration accordingly
		existing.duration = world.time + duration

	else if(duration > 0)
		apply_status_effect(effect, duration)

/atom/movable/screen/alert/status_effect/asleep
	name = "Asleep"
	desc = "You've fallen asleep. Wait a bit and you should wake up. Unless you don't, considering how helpless you are."
	icon_state = "asleep"

//ADMIN SLEEP
/datum/status_effect/incapacitating/adminsleep
	id = "adminsleep"
	alert_type = /atom/movable/screen/alert/status_effect/adminsleep
	duration = -1

/datum/status_effect/incapacitating/adminsleep/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/adminsleep/on_remove()
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	return ..()

/atom/movable/screen/alert/status_effect/adminsleep
	name = "Admin Slept"
	desc = "You've been slept by an Admin."
	icon_state = "asleep"

//CONFUSED
/datum/status_effect/incapacitating/confused
	id = "confused"
	alert_type = /atom/movable/screen/alert/status_effect/confused

/atom/movable/screen/alert/status_effect/confused
	name = "Confused"
	desc = "You're dazed and confused."
	icon_state = "asleep"

/datum/status_effect/plasmadrain
	id = "plasmadrain"

/datum/status_effect/plasmadrain/on_creation(mob/living/new_owner, set_duration)
	if(isxeno(new_owner))
		owner = new_owner
		duration = set_duration
		return ..()
	else
		CRASH("something applied plasmadrain on a nonxeno, dont do that")

/datum/status_effect/plasmadrain/tick(delta_time)
	var/mob/living/carbon/xenomorph/xenoowner = owner
	// This proc can handle everything and hud updating, use it.
	xenoowner.use_plasma(xenoowner.xeno_caste.plasma_max / 10)

/datum/status_effect/noplasmaregen
	id = "noplasmaregen"
	tick_interval = 2 SECONDS

/datum/status_effect/noplasmaregen/on_creation(mob/living/new_owner, set_duration)
	if(isxeno(new_owner))
		owner = new_owner
		duration = set_duration
		return ..()
	else
		CRASH("something applied noplasmaregen on a nonxeno, dont do that")

/datum/status_effect/noplasmaregen/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_NOPLASMAREGEN, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/noplasmaregen/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NOPLASMAREGEN, TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/status_effect/noplasmaregen/tick(delta_time)
	to_chat(owner, span_warning("You feel too weak to summon new plasma..."))

/datum/status_effect/incapacitating/harvester_slowdown
	id = "harvest_slow"
	tick_interval = 1 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	var/debuff_slowdown = 2

/datum/status_effect/incapacitating/harvester_slowdown/on_apply()
	. = ..()
	if(!.)
		return
	if(HAS_TRAIT(owner, TRAIT_SLOWDOWNIMMUNE))
		return
	owner.add_movespeed_modifier(MOVESPEED_ID_HARVEST_TRAM_SLOWDOWN, TRUE, 0, NONE, TRUE, debuff_slowdown)

/datum/status_effect/incapacitating/harvester_slowdown/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_HARVEST_TRAM_SLOWDOWN)
	return ..()

//MUTE
/datum/status_effect/mute
	id = "mute"
	alert_type = /atom/movable/screen/alert/status_effect/mute

/atom/movable/screen/alert/status_effect/mute
	name = "Muted"
	desc = "You can't speak!"
	icon_state = "mute"

/datum/status_effect/mute/on_creation(mob/living/new_owner, set_duration)
	owner = new_owner
	if(set_duration) //If the duration is limited, set it
		duration = set_duration
	return ..()

/datum/status_effect/mute/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_MUTED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/mute/on_remove()
	REMOVE_TRAIT(owner, TRAIT_MUTED, TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/status_effect/spacefreeze
	alert_type = /atom/movable/screen/alert/status_effect/spacefreeze
	id = "spacefreeze"

/datum/status_effect/spacefreeze/on_creation(mob/living/new_owner)
	. = ..()
	to_chat(new_owner, span_danger("The cold vacuum instantly freezes you, maybe this was a bad idea?"))

/datum/status_effect/spacefreeze/tick(delta_time)
	owner.adjustFireLoss(40)

/datum/status_effect/spacefreeze/light
	id = "spacefreeze_light"

/datum/status_effect/spacefreeze/light/tick(delta_time)
	owner.fire_stacks = max(owner.fire_stacks - 6, 0)
	if(owner.stat == DEAD)
		return
	owner.adjustFireLoss(10)

///irradiated mob
/datum/status_effect/incapacitating/irradiated
	id = "irradiated"
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = 2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/irradiated
	///Some effects only apply to carbons
	var/mob/living/carbon/carbon_owner

/datum/status_effect/incapacitating/irradiated/on_creation(mob/living/new_owner, set_duration)
	if(new_owner.status_flags & GODMODE || new_owner.stat == DEAD)
		qdel(src)
		return
	. = ..()
	if(.)
		if(iscarbon(owner))
			carbon_owner = owner

/datum/status_effect/incapacitating/irradiated/Destroy()
	carbon_owner = null
	return ..()

/datum/status_effect/incapacitating/irradiated/tick(delta_time)
	var/mob/living/living_owner = owner
	//Roulette of bad things
	if(prob(15))
		living_owner.adjustCloneLoss(2)
		to_chat(living_owner, span_warning("You feel like you're burning from the inside!"))
	else
		living_owner.adjustToxLoss(3)
	if(prob(15))
		living_owner.adjust_Losebreath(5)
	if(prob(15))
		living_owner.vomit()
	if(carbon_owner && prob(15))
		var/datum/internal_organ/organ = pick(carbon_owner.internal_organs)
		if(organ)
			organ.take_damage(5)

/atom/movable/screen/alert/status_effect/irradiated
	name = "Irradiated"
	desc = "You've been irradiated! The effects of the radiation will continue to harm you until purged from your system."
	icon_state = "radiation"

// ***************************************
// *********** Intoxicated
// ***************************************
/datum/status_effect/stacking/intoxicated
	id = "intoxicated"
	tick_interval = 2 SECONDS
	stacks = 1
	max_stacks = 30
	consumed_on_threshold = FALSE
	/// Owner of the debuff is limited to carbons.
	var/mob/living/carbon/debuff_owner
	/// The xenomorph who will receive healing.
	var/mob/living/carbon/xenomorph/xenomorph_to_heal
	/// The amount of health to restore for each stack.
	var/healing_per_stack = 0
	/// Used for particles. Holds the particles instead of the mob. See particle_holder for documentation.
	var/obj/effect/abstract/particle_holder/particle_holder

/datum/status_effect/stacking/intoxicated/can_gain_stacks()
	if(owner.status_flags & GODMODE || owner.stat == DEAD)
		return FALSE
	return ..()

/datum/status_effect/stacking/intoxicated/on_apply()
	if(HAS_TRAIT(owner, TRAIT_INTOXICATION_IMMUNE))
		return FALSE
	return ..()

/datum/status_effect/stacking/intoxicated/on_creation(mob/living/new_owner, stacks_to_apply, mob/living/carbon/xenomorph/expected_xenomorph_to_heal, expected_healing_per_stack = 0)
	if(new_owner.status_flags & GODMODE || new_owner.stat == DEAD)
		qdel(src)
		return
	. = ..()
	debuff_owner = new_owner
	xenomorph_to_heal = expected_xenomorph_to_heal
	healing_per_stack = expected_healing_per_stack
	RegisterSignal(debuff_owner, COMSIG_LIVING_DO_RESIST, PROC_REF(call_resist_debuff))
	debuff_owner.balloon_alert(debuff_owner, "Intoxicated")
	playsound(debuff_owner.loc, "sound/bullets/acid_impact1.ogg", 30)
	particle_holder = new(debuff_owner, /particles/toxic_slash)
	particle_holder.particles.spawning = 1 + round(stacks / 2)
	particle_holder.pixel_x = -2
	particle_holder.pixel_y = 0
	if(HAS_TRAIT(debuff_owner, TRAIT_INTOXICATION_RESISTANT) || (debuff_owner.get_soft_armor(BIO) >= 65))
		stack_decay = 2

/datum/status_effect/stacking/intoxicated/on_remove()
	UnregisterSignal(debuff_owner, COMSIG_LIVING_DO_RESIST)
	debuff_owner = null
	xenomorph_to_heal = null
	QDEL_NULL(particle_holder)
	return ..()

/datum/status_effect/stacking/intoxicated/tick(delta_time)
	. = ..()
	if(!debuff_owner)
		return
	if(HAS_TRAIT(debuff_owner, TRAIT_INTOXICATION_RESISTANT) || (debuff_owner.get_soft_armor(BIO) > 65))
		stack_decay = 2
	var/debuff_damage = SENTINEL_INTOXICATED_BASE_DAMAGE + round(stacks / 10)
	debuff_owner.adjustFireLoss(debuff_damage)
	playsound(debuff_owner.loc, "sound/bullets/acid_impact1.ogg", 4)
	particle_holder.particles.spawning = 1 + round(stacks / 2)
	if(stacks >= 20)
		debuff_owner.adjust_slowdown(1)
		debuff_owner.adjust_stagger(1 SECONDS)
	if(healing_per_stack && xenomorph_to_heal?.Adjacent(debuff_owner))
		var/amount_to_heal = stacks * healing_per_stack
		HEAL_XENO_DAMAGE(xenomorph_to_heal, amount_to_heal, FALSE)

/// Called when the debuff's owner uses the Resist action for this debuff.
/datum/status_effect/stacking/intoxicated/proc/call_resist_debuff()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(resist_debuff)) // grilled cheese sandwich

/// Resisting the debuff will allow the debuff's owner to remove some stacks from themselves.
/datum/status_effect/stacking/intoxicated/proc/resist_debuff()
	if(!debuff_owner)
		return
	if(length(debuff_owner.do_actions))
		return
	if(!do_after(debuff_owner, 5 SECONDS, NONE, debuff_owner, BUSY_ICON_GENERIC))
		debuff_owner?.balloon_alert(debuff_owner, "Interrupted")
		return
	if(QDELETED(src))
		return
	playsound(debuff_owner, 'sound/effects/slosh.ogg', 30)
	debuff_owner.balloon_alert(debuff_owner, "Succeeded")
	stacks -= SENTINEL_INTOXICATED_RESIST_REDUCTION
	if(stacks > 0)
		resist_debuff() // We repeat ourselves as long as the debuff persists.


// ***************************************
// *********** Melting fire
// ***************************************
/datum/status_effect/stacking/melting_fire
	id = "melting_fire"
	tick_interval = 2 SECONDS
	stack_decay = 1
	stacks = 1
	max_stacks = 10
	consumed_on_threshold = FALSE
	/// Owner of the debuff is limited to carbons.
	var/mob/living/carbon/debuff_owner
	/// Pyrogen creator of the debuff.
	var/mob/living/carbon/xenomorph/pyrogen/debuff_creator
	/// Used for the fire effect.
	var/obj/vis_melt_fire/visual_fire
	// The percentage of brute/burn healing that should be negated.
	var/healing_debuff = 0

/obj/vis_melt_fire
	name = "ouch ouch ouch"
	icon = 'icons/mob/OnFire.dmi'
	layer = ABOVE_MOB_LAYER
	vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_ID | VIS_INHERIT_PLANE

/datum/status_effect/stacking/melting_fire/on_creation(mob/living/new_owner, stacks_to_apply, atom/new_creator)
	if(new_owner.status_flags & GODMODE || new_owner.stat == DEAD || new_owner.soft_armor?.getRating(FIRE) >= 100)
		qdel(src)
		return
	. = ..()
	visual_fire = new
	visual_fire.icon_state = "melting_low_stacks"
	debuff_owner = new_owner
	debuff_owner.vis_contents += visual_fire
	debuff_owner.balloon_alert(debuff_owner, "Melting fire")
	playsound(debuff_owner.loc, "sound/bullets/acid_impact1.ogg", 30)
	RegisterSignal(debuff_owner, COMSIG_LIVING_DO_RESIST, PROC_REF(call_resist_debuff))
	set_creator(new_creator)

/// on remove has owner set to null
/datum/status_effect/stacking/melting_fire/on_remove()
	owner.vis_contents -= visual_fire
	set_creator(null)
	QDEL_NULL(visual_fire)
	return ..()

/datum/status_effect/stacking/melting_fire/tick(delta_time)
	. = ..()
	if(!debuff_owner)
		qdel(src)
		return
	if(debuff_owner.stat == DEAD || debuff_owner.status_flags & GODMODE)
		qdel(src)
		return
	debuff_owner.take_overall_damage(PYROGEN_DAMAGE_PER_STACK * stacks, BURN, FIRE, updating_health = TRUE)
	if(stacks > 4)
		visual_fire.icon_state = "melting_high_stacks"
	else
		visual_fire.icon_state = "melting_low_stacks"
	playsound(debuff_owner.loc, "sound/bullets/acid_impact1.ogg", 4)

	if(QDELETED(debuff_creator) || debuff_creator.stat == DEAD)
		return
	var/amount_to_heal = 2 // HEAL_XENO_DAMAGE requires it as a variable.
	HEAL_XENO_DAMAGE(debuff_creator, amount_to_heal, FALSE)
	debuff_creator.gain_plasma(5, TRUE)

/datum/status_effect/stacking/melting_fire/add_stacks(stacks_added, atom/xeno_creator)
	. = ..()
	set_creator(xeno_creator)

/// Sets the debuff creator of this status effect. Sets and (un)registers signals regarding healing reduction accordingly.
/datum/status_effect/stacking/melting_fire/proc/set_creator(atom/xeno_creator)
	if(!xeno_creator || !isxenopyrogen(xeno_creator))
		if(healing_debuff)
			UnregisterSignal(owner, list(COMSIG_HUMAN_BRUTE_DAMAGE, COMSIG_HUMAN_BURN_DAMAGE))
			healing_debuff = 0
		debuff_creator = null
		return
	var/mob/living/carbon/xenomorph/pyrogen/new_creator = xeno_creator
	if(healing_debuff && !new_creator.melting_fire_healing_reduction)
		UnregisterSignal(owner, list(COMSIG_HUMAN_BRUTE_DAMAGE, COMSIG_HUMAN_BURN_DAMAGE))
	if(!healing_debuff && new_creator.melting_fire_healing_reduction)
		RegisterSignals(debuff_owner, list(COMSIG_HUMAN_BRUTE_DAMAGE, COMSIG_HUMAN_BURN_DAMAGE), PROC_REF(on_heal))
	debuff_creator = new_creator
	healing_debuff = new_creator.melting_fire_healing_reduction

/// Called when the debuff's owner uses the Resist action for this debuff.
/datum/status_effect/stacking/melting_fire/proc/call_resist_debuff()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(resist_debuff)) // grilled cheese sandwich

/// Resisting the debuff will allow the debuff's owner to remove some stacks from themselves.
/datum/status_effect/stacking/melting_fire/proc/resist_debuff()
	if(!debuff_owner)
		qdel(src)
		return
	if(length(debuff_owner.do_actions))
		return
	debuff_owner.spin(30, 1.5)
	debuff_owner.Paralyze(3 SECONDS)
	if((stacks - PYROGEN_MELTING_FIRE_STACKS_PER_RESIST) > 0)
		debuff_owner.visible_message(span_danger("[debuff_owner] rolls on the floor, trying to put themselves out!"), \
		span_notice("You stop, drop, and roll!"), null, 5)
	else
		debuff_owner.visible_message(span_danger("[debuff_owner] has successfully extinguished themselves!"), \
		span_notice("You extinguish yourself."), null, 5)
	add_stacks(-PYROGEN_MELTING_FIRE_STACKS_PER_RESIST) // If their stacks hit zero, it is qdel'd right here.

// If the owner of this status effect were to heal, a percentage of that healing will be negated.
/datum/status_effect/stacking/melting_fire/proc/on_heal(datum/source, amount, list/amount_mod)
	SIGNAL_HANDLER
	if(amount >= 0 || !healing_debuff)
		return
	amount_mod += floor(amount) * healing_debuff

// ***************************************
// *********** dread
// ***************************************
/atom/movable/screen/alert/status_effect/dread
	name = "Dread"
	desc = "A dreadful presence. You are slowed down until this expires."
	icon_state = "dread"

/datum/status_effect/dread
	id = "dread"
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/dread

/datum/status_effect/dread/on_creation(mob/living/new_owner, set_duration)
	owner = new_owner
	duration = set_duration
	return ..()

/datum/status_effect/dread/tick(delta_time)
	. = ..()
	var/mob/living/living_owner = owner
	living_owner.do_jitter_animation(250)

/datum/status_effect/dread/on_apply()
	. = ..()
	if(!.)
		return
	owner.add_movespeed_modifier(MOVESPEED_ID_XENO_DREAD, TRUE, 0, NONE, TRUE, 0.4)

/datum/status_effect/dread/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_XENO_DREAD)
	return ..()

// ***************************************
// *********** Melting
// ***************************************
///amount of damage done per tick by the melting status effect
#define STATUS_EFFECT_MELTING_DAMAGE 5
///Sunder inflicted per tick by the melting status effect
#define STATUS_EFFECT_MELTING_SUNDER_DAMAGE 3

/datum/status_effect/stacking/melting
	id = "melting"
	tick_interval = 1 SECONDS
	max_stacks = 30
	consumed_on_threshold = FALSE
	alert_type = /atom/movable/screen/alert/status_effect/melting
	///Owner of the debuff is limited to carbons.
	var/mob/living/carbon/debuff_owner
	///Used for particles. Holds the particles instead of the mob. See particle_holder for documentation.
	var/obj/effect/abstract/particle_holder/particle_holder

/datum/status_effect/stacking/melting/can_gain_stacks()
	if(owner.status_flags & GODMODE || owner.stat == DEAD)
		return FALSE
	return ..()

/datum/status_effect/stacking/melting/on_creation(mob/living/new_owner, stacks_to_apply)
	if(new_owner.status_flags & GODMODE || new_owner.stat == DEAD)
		qdel(src)
		return
	if(new_owner.has_status_effect(STATUS_EFFECT_RESIN_JELLY_COATING))
		return

	. = ..()
	debuff_owner = new_owner
	debuff_owner.balloon_alert(debuff_owner, "Melting!")
	playsound(debuff_owner.loc, "sound/bullets/acid_impact1.ogg", 30)
	particle_holder = new(debuff_owner, /particles/melting_status)
	particle_holder.particles.spawning = 1 + round(stacks / 2)

/datum/status_effect/stacking/melting/on_remove()
	debuff_owner = null
	QDEL_NULL(particle_holder)
	return ..()

/datum/status_effect/stacking/melting/tick(delta_time)
	. = ..()
	if(!debuff_owner)
		return

	playsound(debuff_owner.loc, "sound/bullets/acid_impact1.ogg", 4)
	particle_holder.particles.spawning = 1 + round(stacks / 2)

	debuff_owner.apply_damage(STATUS_EFFECT_MELTING_DAMAGE, BURN, null, FIRE)

	if(!isxeno(debuff_owner))
		return
	var/mob/living/carbon/xenomorph/xenomorph_owner = debuff_owner
	xenomorph_owner.adjust_sunder(STATUS_EFFECT_MELTING_SUNDER_DAMAGE)

/atom/movable/screen/alert/status_effect/melting
	name = "Melting"
	desc = "You are melting away!"
	icon_state = "melting"

/particles/melting_status
	icon = 'icons/effects/particles/generic_particles.dmi'
	icon_state = "drip"
	width = 100
	height = 100
	count = 1000
	spawning = 4
	lifespan = 10
	fade = 8
	velocity = list(0, 0)
	position = generator(GEN_SPHERE, 16, 16, NORMAL_RAND)
	drift = generator(GEN_VECTOR, list(-0.1, 0), list(0.1, 0))
	gravity = list(0, -0.4)
	scale = generator(GEN_VECTOR, list(0.3, 0.3), list(1, 1), NORMAL_RAND)
	friction = -0.05
	color = "#cc5200"

// ***************************************
// *********** Microwave
// ***************************************
///amount of damage done per tick by the microwave status effect
#define MICROWAVE_STATUS_DAMAGE_MULT 4
///duration of the microwave effect. Refreshed on application
#define MICROWAVE_STATUS_DURATION 5 SECONDS

/datum/status_effect/stacking/microwave
	id = "microwaved"
	tick_interval = 1 SECONDS
	max_stacks = 5
	stack_decay = 0
	consumed_on_threshold = FALSE
	alert_type = /atom/movable/screen/alert/status_effect/microwave
	///Owner of the debuff is limited to carbons.
	var/mob/living/carbon/debuff_owner
	///Used for particles. Holds the particles instead of the mob. See particle_holder for documentation.
	var/obj/effect/abstract/particle_holder/particle_holder
	COOLDOWN_DECLARE(cooldown_microwave_status)

/datum/status_effect/stacking/microwave/can_gain_stacks()
	if(owner.status_flags & GODMODE || owner.stat == DEAD)
		return FALSE
	return ..()

/datum/status_effect/stacking/microwave/on_creation(mob/living/new_owner, stacks_to_apply)
	if(new_owner.status_flags & GODMODE || new_owner.stat == DEAD)
		qdel(src)
		return
	debuff_owner = new_owner
	debuff_owner.balloon_alert(debuff_owner, "microwaved!")
	playsound(debuff_owner.loc, "sound/bullets/acid_impact1.ogg", 30)
	particle_holder = new(debuff_owner, /particles/microwave_status)
	COOLDOWN_START(src, cooldown_microwave_status, MICROWAVE_STATUS_DURATION)
	return ..()

/datum/status_effect/stacking/microwave/on_remove()
	debuff_owner = null
	QDEL_NULL(particle_holder)
	return ..()

/datum/status_effect/stacking/microwave/add_stacks(stacks_added)
	. = ..()
	particle_holder.particles.spawning = stacks * 6
	if(stacks_added > 0 && stacks >= max_stacks) //proc is run even if stacks are not actually added
		COOLDOWN_START(src, cooldown_microwave_status, MICROWAVE_STATUS_DURATION)

/datum/status_effect/stacking/microwave/tick(delta_time)
	. = ..()
	if(COOLDOWN_FINISHED(src, cooldown_microwave_status))
		return qdel(src)

	if(!debuff_owner)
		return

	playsound(debuff_owner.loc, "sound/bullets/acid_impact1.ogg", 4)

	debuff_owner.adjustFireLoss(stacks * MICROWAVE_STATUS_DAMAGE_MULT * (debuff_owner.mob_size > MOB_SIZE_HUMAN ? 1 : 0.5)) //this shreds humans otherwise

/atom/movable/screen/alert/status_effect/microwave
	name = "Microwave"
	desc = "You are burning from the inside!"
	icon_state = "microwave"

/particles/microwave_status
	icon = 'icons/effects/particles/generic_particles.dmi'
	icon_state = "x"
	width = 100
	height = 100
	count = 1000
	spawning = 4
	lifespan = 10
	fade = 8
	velocity = list(0, 0)
	position = generator(GEN_SPHERE, 16, 16, NORMAL_RAND)
	drift = generator(GEN_VECTOR, list(-0.1, 0), list(0.1, 0))
	gravity = list(0, -0.4)
	scale = generator(GEN_VECTOR, list(0.3, 0.3), list(1, 1), NORMAL_RAND)
	friction = -0.05
	color = "#a7cc00"


// ***************************************
// *********** Shatter
// ***************************************
///Percentage reduction of armor removed by the shatter status effect
#define SHATTER_STATUS_EFFECT_ARMOR_MULT 0.2

/datum/status_effect/shatter
	id = "shatter"
	alert_type = /atom/movable/screen/alert/status_effect/shatter
	duration = 10 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	///A holder for the exact armor modified by this status effect
	var/datum/armor/armor_modifier
	///Used for particles. Holds the particles instead of the mob. See particle_holder for documentation.
	var/obj/effect/abstract/particle_holder/particle_holder

/datum/status_effect/shatter/on_creation(mob/living/new_owner, set_duration)
	if(new_owner.status_flags & GODMODE || new_owner.stat == DEAD)
		qdel(src)
		return

	owner = new_owner
	if(set_duration)
		duration = set_duration

	particle_holder = new(owner, /particles/shattered_status)
	return ..()

/datum/status_effect/shatter/on_apply()
	. = ..()
	if(!.)
		return
	armor_modifier = owner.soft_armor.scaleAllRatings(SHATTER_STATUS_EFFECT_ARMOR_MULT)
	owner.soft_armor = owner.soft_armor.detachArmor(armor_modifier)

/datum/status_effect/shatter/on_remove()
	owner.soft_armor = owner.soft_armor.attachArmor(armor_modifier)
	armor_modifier = null
	QDEL_NULL(particle_holder)
	return ..()

/atom/movable/screen/alert/status_effect/shatter
	name = "Shattered"
	desc = "Your armor has been shattered!"
	icon_state = "shatter"

/particles/shattered_status
	icon = 'icons/effects/particles/generic_particles.dmi'
	icon_state = "x"
	width = 100
	height = 100
	count = 1000
	spawning = 4
	lifespan = 10
	fade = 8
	velocity = list(0, 0)
	position = generator(GEN_SPHERE, 16, 16, NORMAL_RAND)
	drift = generator(GEN_VECTOR, list(-0.1, 0), list(0.1, 0))
	gravity = list(0, -0.4)
	scale = generator(GEN_VECTOR, list(0.6, 0.6), list(1, 1), NORMAL_RAND)
	friction = -0.05
	color = "#818181"

/atom/movable/screen/alert/status_effect/spacefreeze
	name = "Freezing"
	desc = "Space is very very cold, who would've thought?"
	icon_state = "cold3"

// ***************************************
// *********** Dancer Tagged
// ***************************************
/datum/status_effect/incapacitating/dancer_tagged
	id = "dancer_tagged"
	duration = 15 SECONDS

// ***************************************
// *********** Acid Melting
// ***************************************
/datum/status_effect/stacking/melting_acid
	id = "melting_acid"
	tick_interval = 1 SECONDS
	max_stacks = 30
	consumed_on_threshold = FALSE
	alert_type = /atom/movable/screen/alert/status_effect/melting_acid
	/// Used for particles. Holds the particles instead of the mob. See particle_holder for documentation.
	var/obj/effect/abstract/particle_holder/particle_holder

/datum/status_effect/stacking/melting_acid/can_gain_stacks()
	if(owner.status_flags & GODMODE || owner.stat == DEAD)
		return FALSE
	return ..()

/datum/status_effect/stacking/melting_acid/on_creation(mob/living/new_owner, stacks_to_apply)
	if(new_owner.status_flags & GODMODE || new_owner.stat == DEAD)
		qdel(src)
		return
	. = ..()
	playsound(owner.loc, "sound/bullets/acid_impact1.ogg", 30)
	particle_holder = new(owner, /particles/melting_acid_status)
	particle_holder.particles.spawning = 1 + round(stacks / 4)

/datum/status_effect/stacking/melting_acid/on_remove()
	QDEL_NULL(particle_holder)
	return ..()

/datum/status_effect/stacking/melting_acid/tick(delta_time)
	. = ..()
	if(!owner)
		return
	playsound(owner.loc, "sound/bullets/acid_impact1.ogg", 4)
	particle_holder.particles.spawning = 1 + round(stacks / 4)
	particle_holder.pixel_x = -2
	particle_holder.pixel_y = 0
	owner.apply_damage(5, BURN, null, ACID)

/atom/movable/screen/alert/status_effect/melting_acid
	name = "Melting (Acid)"
	desc = "You are melting away!"
	icon_state = "melting"

/particles/melting_acid_status
	icon = 'icons/effects/particles/generic_particles.dmi'
	icon_state = "drip"
	width = 100
	height = 100
	count = 1000
	spawning = 4
	lifespan = 10
	fade = 8
	velocity = list(0, 0)
	position = generator(GEN_SPHERE, 16, 16, NORMAL_RAND)
	drift = generator(GEN_VECTOR, list(-0.1, 0), list(0.1, 0))
	gravity = list(0, -0.4)
	scale = generator(GEN_VECTOR, list(0.3, 0.3), list(1, 1), NORMAL_RAND)
	friction = -0.05
	color = "#59ff4a"

// Recently sniped status effect, applied when hit by a sniper round
/datum/status_effect/incapacitating/recently_sniped
	id = "sniped"
	/// Used for the sniped effect
	var/obj/vis_sniped/visual_sniped
	/// Weakref to the gun that applied this effect
	var/datum/weakref/shooter

/obj/vis_sniped
	name = "sniped"
	icon = 'icons/mob/actions.dmi'
	pixel_x = 16
	pixel_y = 10
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_ID | VIS_INHERIT_PLANE

/datum/status_effect/incapacitating/recently_sniped/on_creation(mob/living/new_owner, set_duration, datum/weakref/_shooter)
	. = ..()

	if(!. || new_owner.stat != CONSCIOUS)
		return

	if(!_shooter)
		CRASH("_shooter not passed into sniped status effect.")

	shooter = _shooter

	visual_sniped = new
	visual_sniped.icon_state = "sniper_zoom"

	new_owner.vis_contents += visual_sniped

/datum/status_effect/incapacitating/recently_sniped/on_remove()
	owner.vis_contents -= visual_sniped
	QDEL_NULL(visual_sniped)

// ***************************************
// *********** Lifedrain
// ***************************************
/datum/status_effect/incapacitating/lifedrain
	id = "life_drain"
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/lifedrain

/atom/movable/screen/alert/status_effect/lifedrain
	name = "Lifedrain"
	desc = "Your life force transfers to xenos when they slash you!"
	icon_state = "skullemoji"
