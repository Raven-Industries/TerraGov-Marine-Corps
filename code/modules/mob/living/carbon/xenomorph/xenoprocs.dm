/mob/living/carbon/xenomorph/Bump(atom/A)
	if(ismecha(A))
		var/obj/vehicle/sealed/mecha/mecha = A
		var/mob_swap_mode = NO_SWAP
		if(a_intent == INTENT_HELP)
			mob_swap_mode = SWAPPING
		// If we're moving diagonally, but the mob isn't on the diagonal destination turf and the destination turf is enterable we have no reason to shuffle/push them
		if(moving_diagonally && (get_dir(src, mecha) in GLOB.cardinals) && get_step(src, dir).Enter(src, loc))
			mob_swap_mode = PHASING
		if(mob_swap_mode)
			//switch our position with mech
			if(loc && !loc.Adjacent(mecha.loc))
				return
			now_pushing = TRUE
			var/oldloc = loc
			var/oldmechaloc = mecha.loc

			var/mecha_passmob = (mecha.allow_pass_flags & PASS_MOB) // we give PASS_MOB to both mobs to avoid bumping other mobs during swap.
			mecha.allow_pass_flags |= PASS_MOB

			if(!moving_diagonally) //the diagonal move already does this for us
				Move(oldmechaloc)
			if(mob_swap_mode == SWAPPING)
				mecha.Move(oldloc)

			if(!mecha_passmob)
				mecha.allow_pass_flags &= ~PASS_MOB

			now_pushing = FALSE

			return TURF_ENTER_ALREADY_MOVED

	if(!(xeno_flags & XENO_LEAPING))
		return ..()
	if(!isliving(A))
		return ..()
	return SEND_SIGNAL(src, COMSIG_XENOMORPH_LEAP_BUMP, A)

/mob/living/carbon/xenomorph/verb/hive_status()
	set name = "Hive Status"
	set desc = "Check the status of your current hive."
	set category = "Alien"

	check_hive_status(src)

/mob/living/carbon/xenomorph/verb/tunnel_list()
	set name = "Tunnel List"
	set desc = "See all currently active tunnels."
	set category = "Alien"

	check_tunnel_list(src)


/proc/check_tunnel_list(mob/user) //Creates a handy list of all xeno tunnels
	var/dat = "<br>"

	dat += "<b>List of Hive Tunnels:</b><BR>"

	for(var/hive AS in GLOB.xeno_tunnels_by_hive)
		for(var/obj/structure/xeno/tunnel/T in GLOB.xeno_tunnels_by_hive[hive])
			if(user.issamexenohive(T))
				var/distance = get_dist(user, T)
				dat += "<b>[T.name]</b> located at: <b><font color=green>([T.tunnel_desc][distance > 0 ? " <b>Distance: [distance])</b>" : ""]</b></font><BR>"

	var/datum/browser/popup = new(user, "tunnelstatus", "<div align='center'>Tunnel List</div>", 600, 600)
	popup.set_content(dat)
	popup.open(FALSE)

/proc/check_hive_status(mob/user)
	if(!SSticker)
		return

	var/datum/hive_status/hive
	if(isxeno(user))
		var/mob/living/carbon/xenomorph/xeno_user = user
		if(xeno_user.hive)
			hive = xeno_user.hive
	else
		hive = GLOB.hive_datums[XENO_HIVE_NORMAL]

	hive.interact(user)

	return

/mob/living/carbon/xenomorph/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(href_list["track_xeno_name"])
		var/xeno_name = href_list["track_xeno_name"]
		for(var/Y in hive.get_all_xenos())
			var/mob/living/carbon/xenomorph/X = Y
			if(isnum(X.nicknumber))
				if(num2text(X.nicknumber) != xeno_name)
					continue
			else
				if(X.nicknumber != xeno_name)
					continue
			to_chat(usr,span_notice("You will now track [X.name]"))
			set_tracked(X)
			break

	if(href_list["track_silo_number"])
		var/silo_number = href_list["track_silo_number"]
		for(var/obj/structure/xeno/silo/resin_silo AS in GLOB.xeno_resin_silos_by_hive[hivenumber])
			if(num2text(resin_silo.number_silo) == silo_number)
				set_tracked(resin_silo)
				to_chat(usr,span_notice("You will now track [resin_silo.name]"))
				break

	if(href_list["watch_xeno_name"])
		var/target = locate(href_list["watch_xeno_name"])
		if(isxeno(target))
			// Checks for can use done in overwatch action.
			SEND_SIGNAL(src, COMSIG_XENOMORPH_WATCHXENO, target)

///Send a message to all xenos. Force forces the message whether or not the hivemind is intact. Target is an atom that is pointed out to the hive. Filter list is a list of xenos we don't message.
/proc/xeno_message(message = null, span_class = "xenoannounce", size = 5, hivenumber = XENO_HIVE_NORMAL, force = FALSE, atom/target = null, sound = null, apply_preferences = FALSE, filter_list = null, arrow_type, arrow_color, report_distance = FALSE)
	if(!message)
		return

	if(!GLOB.hive_datums[hivenumber])
		CRASH("xeno_message called with invalid hivenumber")

	var/datum/hive_status/HS = GLOB.hive_datums[hivenumber]
	HS.xeno_message(message, span_class, size, force, target, sound, apply_preferences, filter_list, arrow_type, arrow_color, report_distance)

///returns TRUE if we are permitted to evo to the next caste FALSE otherwise
/mob/living/carbon/xenomorph/proc/upgrade_possible()
	if(!(upgrade in GLOB.xenoupgradetiers))
		stack_trace("Upgrade isn't in upgrade list, incorrect define provided")
		return FALSE
	if(HAS_TRAIT(src, TRAIT_VALHALLA_XENO))
		return FALSE
	if(upgrade == XENO_UPGRADE_NORMAL)
		return hive.purchases.upgrades_by_name[GLOB.tier_to_primo_upgrade[xeno_caste.tier]].times_bought
	if(upgrade == XENO_UPGRADE_INVALID || upgrade == XENO_UPGRADE_PRIMO || upgrade == XENO_UPGRADE_BASETYPE)
		return FALSE
	stack_trace("Logic for handling this Upgrade tier wasn't written")
	return FALSE

//Adds stuff to your "Status" pane -- Specific castes can have their own, like carrier hugger count
//Those are dealt with in their caste files.
/mob/living/carbon/xenomorph/get_status_tab_items()
	. = ..()

	if(!(xeno_caste.caste_flags & CASTE_EVOLUTION_ALLOWED))
		. += "Evolve Progress: (FINISHED)"
	else if(!hive.check_ruler())
		. += "Evolve Progress: (HALTED - NO RULER)"
	else
		. += "Evolve Progress: [evolution_stored]/[xeno_caste.evolution_threshold]"

	if(upgrade_possible())
		. += "Upgrade Progress: [upgrade_stored]/[xeno_caste.upgrade_threshold]"
	else //Upgrade process finished or impossible
		. += "Upgrade Progress: (FINISHED)"

	. += "Health: [health]/[maxHealth][overheal ? " + [overheal]": ""]" //Changes with balance scalar, can't just use the caste

	if((xeno_caste.caste_flags & CASTE_MUTATIONS_ALLOWED) || HAS_TRAIT(src, TRAIT_VALHALLA_XENO))
		. += "Biomass: [!isnull(SSpoints.xeno_biomass_points_by_hive[hivenumber]) ? SSpoints.xeno_biomass_points_by_hive[hivenumber] : 0]/[MUTATION_BIOMASS_MAXIMUM]"

	if(xeno_caste.plasma_max > 0)
		. += "Plasma: [plasma_stored]/[xeno_caste.plasma_max]"

	. += "Armor: [100-sunder]%"

	. += "Regeneration power: [max(regen_power * 100, 0)]%"

	var/casteswap_value = ((GLOB.key_to_time_of_caste_swap[key] ? GLOB.key_to_time_of_caste_swap[key] : -INFINITY)  + SSticker.mode.caste_swap_cooldown - world.time) * 0.1
	if(casteswap_value <= 0)
		. += "Caste Swap Timer: READY"
	else
		. += "Caste Swap Timer: [(casteswap_value / 60) % 60]:[add_leading(num2text(casteswap_value % 60), 2, "0")]"

	//Very weak <= 1.0, Weak <= 2.0, Medium < 3.0, Strong < 4.0, Very strong >= 4.0
	var/msg_holder = ""
	if(frenzy_aura)
		switch(frenzy_aura)
			if(-INFINITY to 1.0)
				msg_holder = "Very weak"
			if(1.1 to 2.0)
				msg_holder = "Weak"
			if(2.1 to 2.9)
				msg_holder = "Medium"
			if(3.0 to 3.9)
				msg_holder = "Strong"
			if(4.0 to INFINITY)
				msg_holder = "Very strong"
		. += "[AURA_XENO_FRENZY] pheromone strength: [msg_holder] ([frenzy_aura])"
	if(warding_aura)
		switch(warding_aura)
			if(-INFINITY to 1.0)
				msg_holder = "Very weak"
			if(1.1 to 2.0)
				msg_holder = "Weak"
			if(2.1 to 2.9)
				msg_holder = "Medium"
			if(3.0 to 3.9)
				msg_holder = "Strong"
			if(4.0 to INFINITY)
				msg_holder = "Very strong"
		. += "[AURA_XENO_WARDING] pheromone strength: [msg_holder] ([warding_aura])"
	if(recovery_aura)
		switch(recovery_aura)
			if(-INFINITY to 1.0)
				msg_holder = "Very weak"
			if(1.1 to 2.0)
				msg_holder = "Weak"
			if(2.1 to 2.9)
				msg_holder = "Medium"
			if(3.0 to 3.9)
				msg_holder = "Strong"
			if(4.0 to INFINITY)
				msg_holder = "Very strong"
		. += "[AURA_XENO_RECOVERY] pheromone strength: [msg_holder] ([recovery_aura])"

//A simple handler for checking your state. Used in pretty much all the procs.
/mob/living/carbon/xenomorph/proc/check_state()
	if(incapacitated() || lying_angle)
		to_chat(src, span_warning("We cannot do this in our current state."))
		return 0
	return 1

///A simple handler for checking your state. Will ignore if the xeno is lying down
/mob/living/carbon/xenomorph/proc/check_concious_state()
	if(incapacitated())
		to_chat(src, span_warning("We cannot do this in our current state."))
		return FALSE
	return TRUE

/mob/living/carbon/xenomorph/proc/set_plasma(value, update_plasma = TRUE)
	plasma_stored = clamp(value, 0, xeno_caste.plasma_max)
	if(!update_plasma)
		return
	hud_set_plasma()

/mob/living/carbon/xenomorph/proc/use_plasma(value, update_plasma = TRUE)
	plasma_stored = max(plasma_stored - value, 0)
	update_action_button_icons()
	if(!update_plasma)
		return
	hud_set_plasma()

/mob/living/carbon/xenomorph/proc/gain_plasma(value, update_plasma = TRUE)
	plasma_stored = min(plasma_stored + value, xeno_caste.plasma_max)
	update_action_button_icons()
	if(!update_plasma)
		return
	hud_set_plasma()

//Strip all inherent xeno verbs from your caste. Used in evolution.
/mob/living/carbon/xenomorph/proc/remove_inherent_verbs()
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			remove_verb(verbs, verb_path)

//Add all your inherent caste verbs and procs. Used in evolution.
/mob/living/carbon/xenomorph/proc/add_inherent_verbs()
	if(inherent_verbs)
		add_verb(src, inherent_verbs)


//Adds or removes a delay to movement based on your caste. If speed = 0 then it shouldn't do much.
//Runners are -2, -4 is BLINDLINGLY FAST, +2 is fat-level
/mob/living/carbon/xenomorph/proc/setXenoCasteSpeed(new_speed)
	if(new_speed == 0)
		remove_movespeed_modifier(MOVESPEED_ID_XENO_CASTE_SPEED)
		return
	add_movespeed_modifier(MOVESPEED_ID_XENO_CASTE_SPEED, TRUE, 0, NONE, TRUE, new_speed)


//Stealth handling


/mob/living/carbon/xenomorph/proc/update_progression(seconds_per_tick)
	// Upgrade is increased based on marine to xeno population taking stored_larva as a modifier.
	var/datum/job/xeno_job = SSjob.GetJobType(/datum/job/xenomorph)
	var/stored_larva = xeno_job.total_positions - xeno_job.current_positions
	upgrade_stored += (1 + (stored_larva/6) + hive.get_upgrade_boost()) * seconds_per_tick * XENO_PER_SECOND_LIFE_MOD //Do this regardless of whether we can upgrade so age accrues at primo
	if(!upgrade_possible())
		return
	if(upgrade_stored < xeno_caste.upgrade_threshold)
		return
	if(incapacitated())
		return
	upgrade_xeno(upgrade_next())


/mob/living/carbon/xenomorph/proc/update_evolving(seconds_per_tick)
	if(evolution_stored >= xeno_caste.evolution_threshold || !(xeno_caste.caste_flags & CASTE_EVOLUTION_ALLOWED) || HAS_TRAIT(src, TRAIT_VALHALLA_XENO))
		return
	if(!hive.check_ruler() && caste_base_type != /datum/xeno_caste/larva) // Larva can evolve without leaders at round start.
		return

	// Evolution is increased based on marine to xeno population taking stored_larva as a modifier.
	var/datum/job/xeno_job = SSjob.GetJobType(/datum/job/xenomorph)
	var/stored_larva = xeno_job.total_positions - xeno_job.current_positions
	var/evolution_points = 1 + (FLOOR(stored_larva / 3, 1)) + hive.get_evolution_boost() + spec_evolution_boost()
	var/evolution_points_lag = evolution_points * seconds_per_tick * XENO_PER_SECOND_LIFE_MOD
	evolution_stored = min(evolution_stored + evolution_points_lag, xeno_caste.evolution_threshold)

	if(!client || !ckey)
		return

	if(evolution_stored == xeno_caste.evolution_threshold)
		to_chat(src, span_xenodanger("Our carapace crackles and our tendons strengthen. We are ready to evolve!"))
		SEND_SOUND(src, sound('sound/effects/alien/evolve_ready.ogg'))


//This deals with "throwing" xenos -- ravagers, hunters, and runners in particular. Everyone else defaults to normal
//Pounce, charge both use throw_at, so we need extra code to do stuff rather than just push people aside.
/mob/living/carbon/xenomorph/throw_impact(atom/hit_atom, speed)
	set waitfor = FALSE

	if(stat || !(xeno_flags & XENO_LEAPING))
		return ..()

	if(isobj(hit_atom)) //Deal with smacking into dense objects. This overwrites normal throw code.
		var/obj/O = hit_atom
		if(!O.anchored && !isxeno(src))
			step(O, dir)
		SEND_SIGNAL(src, COMSIG_XENO_OBJ_THROW_HIT, O, speed)
		return TRUE

	if(isliving(hit_atom)) //Hit a mob! This overwrites normal throw code.
		if(SEND_SIGNAL(src, COMSIG_XENO_LIVING_THROW_HIT, hit_atom) & COMPONENT_KEEP_THROWING)
			return FALSE
		stop_throw() //Resert throwing since something was hit.
		return TRUE

	return ..() //Do the parent otherwise, for turfs.

/mob/living/carbon/xenomorph/proc/toggle_nightvision(new_lighting_cutoff)
	if(!new_lighting_cutoff)
		switch(lighting_cutoff)
			if(LIGHTING_CUTOFF_VISIBLE)
				new_lighting_cutoff = LIGHTING_CUTOFF_MEDIUM
			if(LIGHTING_CUTOFF_MEDIUM)
				new_lighting_cutoff = LIGHTING_CUTOFF_HIGH
			if(LIGHTING_CUTOFF_HIGH)
				new_lighting_cutoff = LIGHTING_CUTOFF_FULLBRIGHT
			else
				new_lighting_cutoff = LIGHTING_CUTOFF_VISIBLE

	var/new_sight = NONE
	switch(new_lighting_cutoff)
		if(LIGHTING_CUTOFF_FULLBRIGHT, LIGHTING_CUTOFF_HIGH, LIGHTING_CUTOFF_MEDIUM)
			new_sight = SEE_MOBS|SEE_OBJS|SEE_TURFS
		if(LIGHTING_CUTOFF_VISIBLE)
			new_sight = SEE_MOBS

	lighting_cutoff = new_lighting_cutoff

	set_sight(new_sight)
	update_sight()


/mob/living/carbon/xenomorph/proc/zoom_in(tileoffset = 5, viewsize = 12)
	if(stat)
		if(xeno_flags & XENO_ZOOMED)
			zoom_out()
			return
		return
	if(xeno_flags & XENO_ZOOMED)
		return
	if(!client)
		return
	zoom_turf = get_turf(src)
	xeno_flags |= XENO_ZOOMED
	client.view_size.set_view_radius_to(viewsize/2-2) //convert diameter to radius
	var/viewoffset = 32 * tileoffset
	switch(dir)
		if(NORTH)
			client.pixel_x = 0
			client.pixel_y = viewoffset
		if(SOUTH)
			client.pixel_x = 0
			client.pixel_y = -viewoffset
		if(EAST)
			client.pixel_x = viewoffset
			client.pixel_y = 0
		if(WEST)
			client.pixel_x = -viewoffset
			client.pixel_y = 0

/mob/living/carbon/xenomorph/proc/zoom_out()
	xeno_flags &= ~XENO_ZOOMED
	zoom_turf = null
	if(!client)
		return
	client.view_size.reset_to_default()
	client.pixel_x = 0
	client.pixel_y = 0

/mob/living/carbon/xenomorph/drop_held_item()
	if(status_flags & INCORPOREAL)
		return FALSE
	var/obj/item/clothing/mask/facehugger/F = get_active_held_item()
	if(istype(F))
		if(locate(/turf/closed/wall/resin) in loc)
			to_chat(src, span_warning("We decide not to drop [F] after all."))
			return

	. = ..()


//When the Queen's pheromones are updated, or we add/remove a leader, update leader pheromones
/mob/living/carbon/xenomorph/proc/handle_xeno_leader_pheromones(mob/living/carbon/xenomorph/ruler)
	QDEL_NULL(leader_current_aura)
	if(QDELETED(ruler) || !(xeno_flags & XENO_LEADER) || !ruler.current_aura || ruler.loc.z != loc.z) //We are no longer a leader, or the Queen attached to us has dropped from her ovi, disabled her pheromones or even died
		to_chat(src, span_xenowarning("Our pheromones wane. The Ruler is no longer granting us her pheromones."))
	else
		leader_current_aura = SSaura.add_emitter(src, ruler.current_aura.aura_types.Copy(), ruler.current_aura.range, ruler.current_aura.strength, ruler.current_aura.duration, ruler.current_aura.faction, ruler.current_aura.hive_number)
		to_chat(src, span_xenowarning("Our pheromones have changed. The Ruler has new plans for the Hive."))


/mob/living/carbon/xenomorph/proc/update_spits(skip_ammo_choice = FALSE)
	if(!ammo && length(xeno_caste.spit_types))
		ammo = GLOB.ammo_list[xeno_caste.spit_types[1]]
	if(!ammo || !xeno_caste.spit_types || !length(xeno_caste.spit_types)) //Only update xenos with ammo and spit types.
		return
	if(!skip_ammo_choice)
		for(var/i in 1 to length(xeno_caste.spit_types))
			var/datum/ammo/A = GLOB.ammo_list[xeno_caste.spit_types[i]]
			if(ammo.icon_state == A.icon_state)
				ammo = A
				break
	SEND_SIGNAL(src, COMSIG_XENO_AUTOFIREDELAY_MODIFIED, xeno_caste.spit_delay + ammo?.added_spit_delay)


// this mess will be fixed by obj damage refactor
/atom/proc/acid_spray_act(mob/living/carbon/xenomorph/X, skip_cooldown)
	return TRUE

/obj/structure/acid_spray_act(mob/living/carbon/xenomorph/X, skip_cooldown)
	if(!is_type_in_typecache(src, GLOB.acid_spray_hit))
		return TRUE // normal density flag
	take_damage(X.xeno_caste.acid_spray_structure_damage, BURN, ACID)
	return TRUE // normal density flag

/obj/structure/razorwire/acid_spray_act(mob/living/carbon/xenomorph/X, skip_cooldown)
	take_damage(2 * X.xeno_caste.acid_spray_structure_damage, BURN, ACID)
	return FALSE // not normal density flag

/mob/living/carbon/acid_spray_act(mob/living/carbon/xenomorph/X, skip_cooldown)
	ExtinguishMob()
	if(isnestedhost(src))
		return

	if(!skip_cooldown && TIMER_COOLDOWN_RUNNING(src, COOLDOWN_ACID))
		return
	TIMER_COOLDOWN_START(src, COOLDOWN_ACID, 2 SECONDS)

	if(isxenopraetorian(X))
		GLOB.round_statistics.praetorian_spray_direct_hits++
		SSblackbox.record_feedback("tally", "round_statistics", 1, "praetorian_spray_direct_hits")

	var/damage = X.xeno_caste.acid_spray_damage_on_hit
	INVOKE_ASYNC(src, PROC_REF(apply_acid_spray_damage), damage)
	to_chat(src, span_xenodanger("\The [X] showers you in corrosive acid!"))

/mob/living/carbon/proc/apply_acid_spray_damage(damage)
	apply_damage(damage, BURN, null, ACID, updating_health = TRUE)

/mob/living/carbon/human/apply_acid_spray_damage(damage)
	take_overall_damage(damage, BURN, ACID, updating_health = TRUE)
	emote("scream")
	Paralyze(2 SECONDS)

/mob/living/carbon/xenomorph/acid_spray_act(mob/living/carbon/xenomorph/X, skip_cooldown)
	ExtinguishMob()

/obj/fire/flamer/acid_spray_act(mob/living/carbon/xenomorph/X, skip_cooldown)
	qdel(src)

/obj/hitbox/acid_spray_act(mob/living/carbon/xenomorph/X, skip_cooldown)
	take_damage(X.xeno_caste.acid_spray_structure_damage, BURN, ACID)
	return TRUE

// Vent Crawl
/mob/living/carbon/xenomorph/proc/vent_crawl()
	set name = "Crawl through Vent"
	set desc = "Enter an air vent and crawl through the pipe system."
	set category = "Alien"
	if(!check_state())
		return
	var/pipe = start_ventcrawl()
	if(pipe)
		handle_ventcrawl(pipe, xeno_caste.vent_enter_speed, xeno_caste.silent_vent_crawl)

/mob/living/carbon/xenomorph/verb/toggle_xeno_mobhud()
	set name = "Toggle Xeno Status HUD"
	set desc = "Toggles the health and plasma hud appearing above Xenomorphs."
	set category = "Alien"

	xeno_flags ^= XENO_MOBHUD
	var/datum/atom_hud/H = GLOB.huds[DATA_HUD_XENO_STATUS]
	if(xeno_flags & XENO_MOBHUD)
		H.add_hud_to(src)
	else
		H.remove_hud_from(src)
	to_chat(src, span_notice("You have [(xeno_flags & XENO_MOBHUD) ? "enabled" : "disabled"] the Xeno Status HUD."))


/mob/living/carbon/xenomorph/proc/recurring_injection(mob/living/carbon/C, datum/reagent/toxin = /datum/reagent/toxin/xeno_neurotoxin, channel_time = XENO_NEURO_CHANNEL_TIME, transfer_amount = XENO_NEURO_AMOUNT_RECURRING, count = 4, datum/effect_system/smoke_spread/gas_type, gas_range)
	if(!C?.can_sting() || !toxin)
		return FALSE
	if(!do_after(src, channel_time, NONE, C, BUSY_ICON_HOSTILE))
		return FALSE
	if(gas_type && gas_range)
		var/datum/effect_system/smoke_spread/smoke_system = new gas_type()
		smoke_system.set_up(gas_range, get_turf(C))
		smoke_system.start()
	var/i = 1
	to_chat(C, span_danger("You feel a tiny prick."))
	to_chat(src, span_xenowarning("Our stinger injects our victim with [initial(toxin.name)]!"))
	playsound(C, 'sound/effects/spray3.ogg', 15, TRUE)
	playsound(C, SFX_ALIEN_DROOL, 15, TRUE)
	do
		face_atom(C)
		if(IsStaggered())
			return FALSE
		do_attack_animation(C)
		C.reagents.add_reagent(toxin, transfer_amount)
	while(i++ < count && do_after(src, channel_time, NONE, C, BUSY_ICON_HOSTILE))
	return TRUE

/atom/proc/can_sting()
	return FALSE

/mob/living/carbon/human/can_sting()
	if(species?.species_flags & (IS_SYNTHETIC|ROBOTIC_LIMBS))
		return FALSE
	if(status_flags & GODMODE)
		return FALSE
	if(stat != DEAD)
		return TRUE
	return FALSE

/mob/living/carbon/xenomorph/adjust_sunder(adjustment)
	. = ..()
	if(.)
		return
	var/old_sunder = sunder
	sunder = clamp(sunder + (adjustment > 0 ? adjustment * xeno_caste.sunder_multiplier : adjustment), 0, xeno_caste.sunder_max)
	SEND_SIGNAL(src, COMSIG_XENOMORPH_SUNDER_CHANGE, old_sunder, sunder)
//Applying sunder is an adjustment value above 0, healing sunder is an adjustment value below 0. Use multiplier when taking sunder, not when healing.

/mob/living/carbon/xenomorph/set_sunder(new_sunder)
	. = ..()
	if(.)
		return
	sunder = clamp(new_sunder, 0, xeno_caste.sunder_max)

/mob/living/carbon/xenomorph/get_sunder()
	. = ..()
	if(.)
		return
	return 1 - (sunder * 0.01)

/mob/living/carbon/xenomorph/adjust_stagger(amount)
	if(is_charging >= CHARGE_ON) //If we're charging we don't accumulate more stagger stacks.
		return FALSE
	return ..()

///Eject the mob inside our belly, and putting it in a cocoon if needed
/mob/living/carbon/xenomorph/proc/eject_victim(make_cocoon = FALSE, turf/eject_location = loc)
	if(!eaten_mob)
		return
	var/mob/living/carbon/victim = eaten_mob
	eaten_mob = null
	if(make_cocoon)
		ADD_TRAIT(victim, TRAIT_PSY_DRAINED, TRAIT_PSY_DRAINED)
		if(HAS_TRAIT(victim, TRAIT_UNDEFIBBABLE))
			victim.med_hud_set_status()
		new /obj/structure/cocoon(loc, hivenumber, victim)
		return
	victim.forceMove(eject_location)
	REMOVE_TRAIT(victim, TRAIT_STASIS, TRAIT_STASIS)

///Set the var tracked to to_track
/mob/living/carbon/xenomorph/proc/set_tracked(atom/to_track)
	if(tracked)
		UnregisterSignal(tracked, COMSIG_QDELETING)
		if (tracked == to_track)
			clean_tracked()
			return
	tracked = to_track
	RegisterSignal(tracked, COMSIG_QDELETING, PROC_REF(clean_tracked))

///Signal handler to null tracked
/mob/living/carbon/xenomorph/proc/clean_tracked(atom/to_track)
	SIGNAL_HANDLER
	tracked = null

///Handles icon updates when leadered/unleadered. Evolution.dm also uses this
/mob/living/carbon/xenomorph/proc/update_leader_icon(makeleader = TRUE)
	// Xenos with specialized icons (Queen, King, Shrike) do not get their icon changed
	if(istype(xeno_caste, /datum/xeno_caste/queen) || istype(xeno_caste, /datum/xeno_caste/shrike) || istype(xeno_caste, /datum/xeno_caste/king) || istype(xeno_caste, /datum/xeno_caste/dragon))
		return

	SSminimaps.remove_marker(src)
	var/image/blip = image('icons/UI_icons/map_blips.dmi', null, xeno_caste.minimap_icon, MINIMAP_BLIPS_LAYER)
	if(makeleader)
		blip.overlays += image('icons/UI_icons/map_blips.dmi', null, xeno_caste.minimap_leadered_overlay)
	SSminimaps.add_marker(src, MINIMAP_FLAG_XENO, blip)

///updates the xeno's glow, based on the ability being used
/mob/living/carbon/xenomorph/proc/update_glow(range, power, color)
	if(!range || !power || !color)
		set_light_on(FALSE)
		return
	set_light_range_power_color(range, power, color)
	set_light_on(TRUE)

/mob/living/carbon/xenomorph/on_eord(turf/destination)
	revive(TRUE)
