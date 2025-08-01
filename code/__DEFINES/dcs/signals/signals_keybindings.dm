/*!
 * Contains keybinding signals
 */

#define COMSIG_KB_ACTIVATED (1<<0)
#define COMSIG_KB_NOT_ACTIVATED (1<<1) //used in unique action
//carbon
#define COMSIG_KB_CARBON_HOLDRUNMOVEINTENT_DOWN "keybinding_carbon_holdrunmoveintent_down"
#define COMSIG_KB_CARBON_TOGGLETHROWMODE_DOWN "keybinding_carbon_togglethrowmode_down"
#define COMSIG_KB_CARBON_TOGGLEREST_DOWN "kebinding_carbon_togglerest_down"
#define COMSIG_KB_CARBON_SELECTHELPINTENT_DOWN "keybinding_carbon_selecthelpintent_down"
#define COMSIG_KB_CARBON_SELECTDISARMINTENT_DOWN "keybinding_carbon_selectdisarmintent_down"
#define COMSIG_KB_CARBON_SELECTGRABINTENT_DOWN "keybinding_carbon_selectgrabintent_down"
#define COMSIG_KB_CARBON_SELECTHARMINTENT_DOWN "keybinding_carbon_selectharmintent_down"

//client
#define COMSIG_KB_CLIENT_GETHELP_DOWN "keybinding_client_gethelp_down"
#define COMSIG_KB_CLIENT_SCREENSHOT_DOWN "keybinding_client_screenshot_down"
#define COMSIG_KB_CLIENT_MINIMALHUD_DOWN "keybinding_client_minimalhud_down"
#define COMSIG_KB_CLIENT_FULLSCREEN_DOWN "keybinding_client_fullscreen_down"
#define COMSIG_KB_CLIENT_SAY_DOWN "keybinding_client_say_down"
#define COMSIG_KB_CLIENT_RADIO_DOWN "keybinding_client_radio_down"
#define COMSIG_KB_CLIENT_ME_DOWN "keybinding_client_me_down"
#define COMSIG_KB_CLIENT_OOC_DOWN "keybinding_client_ooc_down"
#define COMSIG_KB_CLIENT_XOOC_DOWN "keybinding_client_xooc_down"
#define COMSIG_KB_CLIENT_MOOC_DOWN "keybinding_client_mooc_down"
#define COMSIG_KB_CLIENT_LOOC_DOWN "keybinding_client_looc_down"

//living
#define COMSIG_KB_LIVING_RESIST_DOWN "keybinding_living_resist_down"
#define COMSIG_KB_LIVING_JUMP_DOWN "keybind_living_jump_down"
#define COMSIG_KB_LIVING_JUMP_UP "keybind_living_jump_up"
#define COMSIG_KB_LIVING_LOOKUP_DOWN "keybinding_living_lookup_down"
#define COMSIG_KB_LIVING_LOOKDOWN_DOWN "keybinding_living_lookdown_down"

//mob
#define COMSIG_KB_MOB_STOPPULLING_DOWN "keybinding_mob_stoppulling_down"
#define COMSIG_KB_MOB_CYCLEINTENTRIGHT_DOWN "keybinding_mob_cycleintentright_down"
#define COMSIG_KB_MOB_CYCLEINTENTLEFT_DOWN "keybinding_mob_cycleintentleft_down"
#define COMSIG_KB_MOB_SWAPHANDS_DOWN "keybinding_mob_swaphands_down"
#define COMSIG_KB_MOB_ACTIVATEINHAND_DOWN "keybinding_mob_activateinhand_down"
#define COMSIG_KB_MOB_DROPITEM_DOWN "keybinding_mob_dropitem_down"
#define COMSIG_KB_MOB_EXAMINE_DOWN "keybinding_mob_examine_down"
#define COMSIG_KB_MOB_TOGGLEMOVEINTENT_DOWN "keybinding_mob_togglemoveintent_down"
#define COMSIG_KB_MOB_TARGETCYCLEHEAD_DOWN "keybinding_mob_targetcyclehead_down"
#define COMSIG_KB_MOB_TARGETRIGHTARM_DOWN "keybinding_mob_targetrightarm_down"
#define COMSIG_KB_MOB_TARGETBODYCHEST_DOWN "keybinding_mob_targetbodychest_down"
#define COMSIG_KB_MOB_TARGETLEFTARM_DOWN "keybinding_mob_targetleftarm_down"
#define COMSIG_KB_MOB_TARGETRIGHTLEG_DOWN "keybinding_mob_targetrightleg_down"
#define COMSIG_KB_MOB_TARGETBODYGROIN_DOWN "keybinding_mob_targetbodygroin_down"
#define COMSIG_KB_MOB_TARGETLEFTLEG_DOWN "keybinding_mob_targetleftleg_down"

//movement
#define COMSIG_KB_MOVEMENT_NORTH_DOWN "keybinding_movement_north_down"
#define COMSIG_KB_MOVEMENT_SOUTH_DOWN "keybinding_movement_south_down"
#define COMSIG_KB_MOVEMENT_WEST_DOWN "keybinding_movement_west_down"
#define COMSIG_KB_MOVEMENT_EAST_DOWN "keybinding_movement_east_down"
#define COMSIG_KB_MOB_BLOCKMOVEMENT_DOWN "keybinding_mob_blockmovement_down"
#define COMSIG_KB_MOVEMENT_ZLEVEL_MOVEUP_DOWN "keybinding_mob_zlevel_moveup_down"
#define COMSIG_KB_MOVEMENT_ZLEVEL_MOVEDOWN_DOWN "keybinding_mob_zlevel_movedown_down"

//Admin
#define COMSIG_KB_ADMIN_ASAY_DOWN "keybinding_admin_asay_down"
#define COMSIG_KB_ADMIN_DSAY_DOWN "keybinding_admin_dsay_down"
#define COMSIG_KB_ADMIN_MSAY_DOWN "keybinding_admin_msay_down"
#define COMSIG_KB_ADMIN_TOGGLEBUILDMODE_DOWN "keybinding_admin_togglebuildmode_down"
#define COMSIG_KB_ADMIN_VIEWTAGS_DOWN "keybinding_admin_viewtags_down"

// mob keybinds
#define COMSIG_KB_HOLD_RUN_MOVE_INTENT_UP "keybinding_hold_run_move_intent_up"
#define COMSIG_KB_EMOTE "keybinding_emote"
#define COMSIG_KB_TOGGLE_MINIMAP "toggle_minimap"
#define COMSIG_KB_TOGGLE_EXTERNAL_MINIMAP "toggle_external_minimap"
#define COMSIG_KB_SELFHARM "keybind_selfharm"
#define COMSIG_KB_INTERACTIVE_EMOTE "keybinding_interactive_emote"
#define COMSIG_KB_MOB_TOGGLE_CLICKDRAG "keybinding_mob_toggle_clickdrag"

// human signals for keybindings
#define COMSIG_KB_QUICKEQUIP "keybinding_quickequip"
#define COMSIG_KB_GUN_SAFETY "keybinding_gun_safety"
#define COMSIG_KB_UNIQUEACTION "keybinding_uniqueaction"
#define COMSIG_KB_RAILATTACHMENT "keybinding_railattachment"
#define COMSIG_KB_MUZZLEATTACHMENT "keybinding_muzzleattachment"
#define COMSIG_KB_UNDERRAILATTACHMENT "keybinding_underrailattachment"
#define COMSIG_KB_UNLOADGUN "keybinding_unloadgun"
#define COMSIG_KB_AIMMODE "keybinding_aimmode"
#define COMSIG_KB_FIREMODE "keybind_firemode"
#define COMSIG_KB_AUTOEJECT "keybind_autoeject"
#define COMSIG_KB_HUMAN_INTERACT_OTHER_HAND "keybinding_human_interact_other_hand"
#define COMSIG_KB_GIVE "keybind_give"
#define COMSIG_KB_HELMETMODULE "keybinding_helmetmodule"
#define COMSIG_KB_ARMORMODULE "keybinding_armormodule"
#define COMSIG_KB_ROBOT_AUTOREPAIR "keybinding_robot_autorepair"
#define COMSIG_KB_STIMS "keybinding_stims_menu"
#define COMSIG_KB_SUITLIGHT "keybinding_suitlight"
#define COMSIG_KB_MOVEORDER "keybind_moveorder"
#define COMSIG_KB_HOLDORDER "keybind_holdorder"
#define COMSIG_KB_FOCUSORDER "keybind_focusorder"
#define COMSIG_KB_RALLYORDER "keybind_rallyorder"
#define COMSIG_KB_SENDORDER "keybind_sendorder"
#define COMSIG_KB_ATTACKORDER "keybind_attackorder"
#define COMSIG_KB_DEFENDORDER "keybind_defendorder"
#define COMSIG_KB_RETREATORDER "keybind_retreatorder"
#define COMSIG_KB_VEHICLEHONK "keybind_vehiclehonk"

//Item toggle keybinds
#define COMSIG_ITEM_TOGGLE_JETPACK "item_toggle_jetpack"
#define COMSIG_ITEM_TOGGLE_BLINKDRIVE "item_toggle_blinkdrive"
#define COMSIG_ITEM_TOGGLE_STRAP "item_toggle_strap"

//Weapon related ability keybinds
#define COMSIG_WEAPONABILITY_AXESWEEP "weaponability_axesweep"
#define COMSIG_WEAPONABILITY_SWORDLUNGE "weaponability_swordlunge"
#define COMSIG_WEAPONABILITY_SHIELDBASH "weaponability_shieldbash"

//Implant abilities
#define COMSIG_IMPLANT_ABILITY_SANDEVISTAN "implant_ability_sandevistan"

// human modules signals for keybindings
#define COMSIG_KB_VALI_CONFIGURE "keybinding_vali_configure"
#define COMSIG_KB_VALI_HEAL "keybinding_vali_heal"
#define COMSIG_KB_VALI_CONNECT "keybiding_vali_connect"
#define COMSIG_KB_SUITANALYZER "keybinding_suitanalyzer"

// Ability adding/removing signals
#define ACTION_GIVEN "gave_an_action"		//from base of /datum/action/proc/give_action(): (datum/action)
#define ACTION_REMOVED "removed_an_action"	//from base of /datum/action/proc/remove_action(): (datum/action)

// mecha keybinds
#define COMSIG_MECHABILITY_TOGGLE_INTERNALS "mechability_toggle_internals"
#define COMSIG_MECHABILITY_TOGGLE_STRAFE "mechability_toggle_strafe"
#define COMSIG_MECHABILITY_VIEW_STATS "mechability_view_stats"
#define COMSIG_MECHABILITY_SMOKE "mechability_smoke"
#define COMSIG_MECHABILITY_TOGGLE_ZOOM "mechability_toggle_zoom"
#define COMSIG_MECHABILITY_ASSAULT_ARMOR "mechability_assault_armor"
#define COMSIG_MECHABILITY_SKYFALL "mechability_skyfall"
#define COMSIG_MECHABILITY_STRIKE "mechability_strike"
#define COMSIG_MECHABILITY_RELOAD "mechability_reload"
#define COMSIG_MECHABILITY_REPAIRPACK "mechability_repairpack"
#define COMSIG_MECHABILITY_SWAPWEAPONS "mechability_swapweapons"
#define COMSIG_MECHABILITY_TOGGLE_ACTUATORS "mechability_toggle_actuators"
#define COMSIG_MECHABILITY_CLOAK "mechability_cloak"
#define COMSIG_MECHABILITY_OVERBOOST "mechability_overboost"
#define COMSIG_MECHABILITY_PULSE_ARMOR "mechability_pulse_armor"

#define COMSIG_ACTION_EXCLUSIVE_TOGGLE "action_exclusive_toggle"

#define COMSIG_ABILITY_PLACE_HOLOGRAM "ability_place_hologram"
#define COMSIG_ABILITY_SELECT_BUILDTYPE "ability_select_buildtype"

//---- XENO ABILITY KEYBINDS

#define COMSIG_XENOABILITY_REST "xenoability_rest"
#define COMSIG_XENOABILITY_HEADBITE "xenoability_headbite"
#define COMSIG_XENOABILITY_REGURGITATE "xenoability_regurgitate"
#define COMSIG_XENOABILITY_BLESSINGSMENU "xenoability_blesssingsmenu"
#define COMSIG_XENOABILITY_DROP_WEEDS "xenoability_drop_weeds"
#define COMSIG_XENOABILITY_CHOOSE_WEEDS "xenoability_choose_weeds"
#define COMSIG_XENOABILITY_DROP_PLANT "xenoability_drop_plant"
#define COMSIG_XENOABILITY_CHOOSE_PLANT "xenoability_choose_plant"
#define COMSIG_XENOABILITY_SECRETE_RESIN "xenoability_secrete_resin"
#define COMSIG_XENOABILITY_SECRETE_SPECIAL_RESIN "xenoability_secrete_special_resin"
#define COMSIG_XENOABILITY_PLACE_ACID_WELL "place_acid_well"
#define COMSIG_XENOABILITY_EMIT_RECOVERY "xenoability_emit_recovery"
#define COMSIG_XENOABILITY_EMIT_WARDING "xenoability_emit_warding"
#define COMSIG_XENOABILITY_EMIT_FRENZY "xenoability_emit_frenzy"
#define COMSIG_XENOABILITY_TRANSFER_PLASMA "xenoability_transfer_plasma"
#define COMSIG_XENOABILITY_CORROSIVE_ACID "xenoability_corrosive_acid"
#define COMSIG_XENOABILITY_SPRAY_ACID "xenoability_spray_acid"
#define COMSIG_XENOABILITY_ACID_DASH "xenoability_acid_dash"
#define COMSIG_XENOABILITY_ACID_DASH_MELTER "xenoability_acid_dash_melter"
#define COMSIG_XENOABILITY_ACIDIC_MISSILE "xenoability_acidic_missile"
#define COMSIG_XENOABILITY_DODGE "xenoability_dodge"
#define COMSIG_XENOABILITY_IMPALE "xenoability_impale"
#define COMSIG_XENOABILITY_TAIL_TRIP "xenoability_tail_trip"
#define COMSIG_XENOABILITY_TAILHOOK "xenoability_tailhook"
#define COMSIG_XENOABILITY_BATONPASS "xenoability_batonpass"
#define COMSIG_XENOABILITY_XENO_SPIT "xenoability_xeno_spit"
#define COMSIG_XENOABILITY_HIDE "xenoability_hide"
#define COMSIG_XENOABILITY_NEUROTOX_STING "xenoability_neurotox_sting"
#define COMSIG_XENOABILITY_OZELOMELYN_STING "xenoability_ozelomelyn_sting"
#define COMSIG_XENOABILITY_INJECT_EGG_NEUROGAS "xenoability_inject_egg_neurogas"
#define COMSIG_XENOABILITY_RALLY_HIVE "xenoability_rally_hive"
#define COMSIG_XENOABILITY_RALLY_MINION "xenoability_rally_minion"
#define COMSIG_XENOABILITY_MINION_BEHAVIOUR "xenoability_minion_behavior"
#define COMSIG_XENOABILITY_SILENCE "xenoability_silence"
#define COMSIG_XENOABILITY_PLACE_PATTERN "xenoability_place_pattern"
#define COMSIG_XENOABILITY_SELECT_PATTERN "xenoability_select_pattern"

#define COMSIG_XENOABILITY_TOXIC_SPIT "xenoability_toxic_spit"
#define COMSIG_XENOABILITY_TOXIC_SLASH "xenoability_toxic_slash"
#define COMSIG_XENOABILITY_DRAIN_STING "xenoability_drain_sting"
#define COMSIG_XENOABILITY_TOXIC_GRENADE "xenoability_toxic_grenade"

#define COMSIG_XENOABILITY_ACIDIC_SALVE "xenoability_acidic_salve"
#define COMSIG_XENOABILITY_ESSENCE_LINK "xenoability_essence_link"
#define COMSIG_XENOABILITY_ESSENCE_LINK_REMOVE "xenoability_essence_link_remove"
#define COMSIG_XENOABILITY_ENHANCEMENT "xenoability_enhancement"

#define COMSIG_XENOABILITY_LONG_RANGE_SIGHT "xenoability_long_range_sight"
#define COMSIG_XENOABILITY_TOGGLE_BOMB "xenoability_toggle_bomb"
#define COMSIG_XENOABILITY_TOGGLE_BOMB_RADIAL "xenoability_toggle_bomb_radial"
#define COMSIG_XENOABILITY_CREATE_BOMB "xenoability_create_bomb"
#define COMSIG_XENOABILITY_BOMBARD "xenoability_bombard"
#define COMSIG_XENOABILITY_ACID_SHROUD "xenoability_acid_shroud"
#define COMSIG_XENOABILITY_ACID_SHROUD_MELTER "xenoability_acid_shroud_melter"
#define COMSIG_XENOABILITY_ACID_SHROUD_SELECT "xenoability_acid_shroud_select"
#define COMSIG_XENOABILITY_SMOKESCREEN_SPIT "xenoability_smokescreen_spit"
#define COMSIG_XENOABILITY_STEAM_RUSH "xenoability_steam_rush"
#define COMSIG_XENOABILITY_HIGH_PRESSURE_SPIT "xenoability_high_pressure_spit"

#define COMSIG_XENOABILITY_THROW_HUGGER "xenoability_throw_hugger"
#define COMSIG_XENOABILITY_CALL_YOUNGER "xenoability_call_younger"
#define COMSIG_XENOABILITY_PLACE_TRAP "xenoability_place_trap"
#define COMSIG_XENOABILITY_SPAWN_HUGGER "xenoability_spawn_hugger"
#define COMSIG_XENOABILITY_SWITCH_HUGGER "xenoability_switch_hugger"
#define COMSIG_XENOABILITY_CHOOSE_HUGGER "xenoability_choose_hugger"
#define COMSIG_XENOABILITY_DROP_ALL_HUGGER "xenoability_drop_all_hugger"
#define COMSIG_XENOABILITY_BUILD_HUGGER_TURRET "xenoability_build_hugger_turret"

#define COMSIG_XENOABILITY_STOMP "xenoability_stomp"
#define COMSIG_XENOABILITY_TOGGLE_CHARGE "xenoability_toggle_charge"
#define COMSIG_XENOABILITY_CRESTTOSS "xenoability_cresttoss"
#define COMSIG_XENOABILITY_ADVANCE "xenoability_advance"

#define COMSIG_XENOABILITY_DEVOUR "xenoability_devour"
#define COMSIG_XENOABILITY_DRAIN "xenoability_drain"
#define COMSIG_XENOABILITY_TRANSFUSION "xenoability_transfusion"
#define COMSIG_XENOABILITY_OPPOSE "xenoability_oppose"
#define COMSIG_XENOABILITY_PSYCHIC_LINK "xenoability_psychic_link"
#define COMSIG_XENOABILITY_CARNAGE "xenoability_carnage"
#define COMSIG_XENOABILITY_FEAST "xenoability_feast"

#define COMSIG_XENOABILITY_BULLCHARGE "xenoability_bullcharge"
#define COMSIG_XENOABILITY_BULLHEADBUTT "xenoability_bullheadbutt"
#define COMSIG_XENOABILITY_BULLGORE "xenoability_bullgore"

#define COMSIG_XENOABILITY_TAIL_SWEEP "xenoability_tail_sweep"
#define COMSIG_XENOABILITY_FORWARD_CHARGE "xenoability_forward_charge"
#define COMSIG_XENOABILITY_CREST_DEFENSE "xenoability_crest_defense"
#define COMSIG_XENOABILITY_FORTIFY "xenoability_fortify"
#define COMSIG_XENOABILITY_REGENERATE_SKIN "xenoability_regenerate_skin"
#define COMSIG_XENOABILITY_CENTRIFUGAL_FORCE "xenoability_centrifugal_force"

#define COMSIG_XENOABILITY_EMIT_NEUROGAS "xenoability_emit_neurogas"
#define COMSIG_XENOABILITY_SELECT_REAGENT "xenoability_select_reagent"
#define COMSIG_XENOABILITY_RADIAL_SELECT_REAGENT "xenoability_radial_select_reagent"
#define COMSIG_XENOABILITY_REAGENT_SLASH "xenoability_reagent_slash"
#define COMSIG_XENOABILITY_DEFILE "xenoability_defile"
#define COMSIG_XENOABILITY_TENTACLE "xenoability tentacle"

#define COMSIG_XENOABILITY_RESIN_WALKER "xenoability_resin_walker"
#define COMSIG_XENOABILITY_BUILD_TUNNEL "xenoability_build_tunnel"
#define COMSIG_XENOABILITY_PLACE_JELLY_POD "xenoability_place_jelly_pod"
#define COMSIG_XENOABILITY_PLACE_RECOVERY_PYLON "xenoability_place_recovery_pylon"
#define COMSIG_XENOABILITY_CREATE_JELLY "xenoability_create_jelly"
#define COMSIG_XENOABILITY_HEALING_INFUSION "xenoability_healing_infusion"
#define COMSIG_XENOABILITY_RECYCLE "xenoability_recycle"

#define COMSIG_XENOABILITY_TOGGLE_STEALTH "xenoability_toggle_stealth"
#define COMSIG_XENOABILITY_TOGGLE_DISGUISE "xenoability_toggle_disguise"
#define COMSIG_XENOABILITY_MIRAGE "xenoability_mirage"
#define COMSIG_XENOABILITY_MIRAGE_SWAP "xenoability_mirage_swap"

#define COMSIG_XENOABILITY_SCREECH "xenoability_screech"
#define COMSIG_XENOABILITY_SCREECH_SWITCH "xenoability_screech_switch"

#define COMSIG_XENOABILITY_PSYCHIC_WHISPER "xenoability_psychic_whisper"
#define COMSIG_XENOABILITY_TOGGLE_QUEEN_ZOOM "xenoability_toggle_queen_zoom"
#define COMSIG_XENOABILITY_XENO_LEADERS "xenoability_xeno_leaders"
#define COMSIG_XENOABILITY_QUEEN_HEAL "xenoability_queen_heal"
#define COMSIG_XENOABILITY_QUEEN_GIVE_PLASMA "xenoability_queen_give_plasma"
#define COMSIG_XENOABILITY_QUEEN_HIVE_MESSAGE "xenoability_queen_hive_message"
#define COMSIG_XENOABILITY_DEEVOLVE "xenoability_deevolve"
#define COMSIG_XENOABILITY_QUEEN_BULWARK "xenoability_queen_bulwark"

#define COMSIG_XENOABILITY_LAY_HIVEMIND "xenoability_lay_hivemind"
#define COMSIG_XENOABILITY_LAY_EGG "xenoability_lay_egg"
#define COMSIG_XENOABILITY_CALL_OF_THE_BURROWED "xenoability_call_of_the_burrowed"
#define COMSIG_XENOABILITY_PSYCHIC_FLING "xenoability_psychic_fling"
#define COMSIG_XENOABILITY_PSYCHIC_CURE "xenoability_psychic_cure"
#define COMSIG_XENOABILITY_UNRELENTING_FORCE "xenoability_unrelenting_force"
#define COMSIG_XENOABILITY_UNRELENTING_FORCE_SELECT "xenoability_unrelenting_force_select"
#define COMSIG_XENOABILITY_PSYCHIC_VORTEX "xenoability_psychic_vortex"

#define COMSIG_XENOABILITY_RAVAGER_CHARGE "xenoability_ravager_charge"
#define COMSIG_XENOABILITY_RAVAGE "xenoability_ravage"
#define COMSIG_XENOABILITY_RAVAGE_SELECT "xenoability_ravage_select"
#define COMSIG_XENOABILITY_SECOND_WIND "xenoability_second_wind"
#define COMSIG_XENOABILITY_ENDURE "xenoability_endure"
#define COMSIG_XENOABILITY_RAGE "xenoability_rage"
#define COMSIG_XENOABILITY_VAMPIRISM "xenoability_vampirism"
#define COMSIG_XENOABILITY_DEATHMARK "xenoability_deathmark"

#define COMSIG_XENOABILITY_RUNNER_POUNCE "xenoability_runner_pounce"
#define COMSIG_XENOABILITY_HUNTER_POUNCE "xenoability_hunter_pounce"
#define COMSIG_XENOABILITY_TOGGLE_SAVAGE "xenoability_toggle_savage"
#define COMSIG_XENOABILITY_EVASION "xenoability_evasion"
#define COMSIG_XENOABILITY_AUTO_EVASION "xenoability_auto_evasion"
#define COMSIG_XENOABILITY_SNATCH "xenoability_snatch"

#define COMSIG_XENOABILITY_VENTCRAWL "xenoability_vent_crawl"

#define COMSIG_XENOABILITY_TOGGLE_AGILITY "xenoability_toggle_agility"
#define COMSIG_XENOABILITY_LUNGE "xenoability_lunge"
#define COMSIG_XENOABILITY_FLING "xenoability_fling"
#define COMSIG_XENOABILITY_PUNCH "xenoability_punch"
#define COMSIG_XENOABILITY_GRAPPLE_TOSS "xenoability_grapple_toss"
#define COMSIG_XENOABILITY_JAB "xenoability_jab"

#define COMSIG_XENOABILITY_PORTAL "xenoablity_portal"
#define COMSIG_XENOABILITY_PORTAL_ALTERNATE "xenoability_portal_alternate"
#define COMSIG_XENOABILITY_TIMESTOP "xenoability_timestop"
#define COMSIG_XENOABILITY_REWIND "xenoability_rewind"

#define COMSIG_XENOABILITY_NIGHTFALL "xenoability_nightfall"
#define COMSIG_XENOABILITY_PETRIFY "xenoability_petrify"
#define COMSIG_XENOABILITY_OFFGUARD "xenoability_offguard"
#define COMSIG_XENOABILITY_SHATTERING_ROAR "xenoability_shattering_roar"
#define COMSIG_XENOABILITY_ZEROFORMBEAM "xenoability_zeroformbeam"
#define COMSIG_XENOABILITY_HIVE_SUMMON "xenoability_hive_summon"

#define COMSIG_XENOABILITY_CONQUEROR_DASH "xenoability_conqueror_dash"
#define COMSIG_XENOABILITY_CONQUEROR_WILL "xenoability_conqueror_will"
#define COMSIG_XENOABILITY_CONQUEROR_ENDURANCE_HOLD "xenoability_conqueror_endurance_hold"
	#define COMSIG_XENOABILITY_CONQUEROR_ENDURANCE_UP "xenoability_conqueror_endurance_up"
#define COMSIG_XENOABILITY_CONQUEROR_ENDURANCE_TOGGLE "xenoability_conqueror_endurance_toggle"
#define COMSIG_XENOABILITY_CONQUEROR_DOMINATION "xenoability_conqueror_domination"
#define COMSIG_XENOABILITY_CONQUEROR_OBLITERATION_HOLD "xenoability_conqueror_obliteration_hold"
	#define COMSIG_XENOABILITY_CONQUEROR_OBLITERATION_UP "xenoability_conqueror_obliteration_up"
#define COMSIG_XENOABILITY_CONQUEROR_OBLITERATION_TOGGLE "xenoability_conqueror_obliteration_toggle"

#define COMSIG_XENOABILITY_SCATTER_SPIT "xenoability_scatter_spit"
#define COMSIG_XENOABILITY_TOSS_GRENADE "xenoability_toss_grenade"
#define COMSIG_XENOABILITY_PICK_GRENADE "xenoability_pick_grenade"
#define COMSIG_XENOABILITY_ACID_MINE "xenoability_acid_mine"
#define COMSIG_XENOABILITY_GAS_MINE "xenoability_gas_mine"
#define COMSIG_XENOABILITY_ACID_ROCKET "xenoability_acid_rocket"

#define COMSIG_XENOABILITY_WEB_SPIT "xenoability_web_spit"
#define COMSIG_XENOABILITY_BURROW "xenoability_burrow"
#define COMSIG_XENOABILITY_LEASH_BALL "xenoability_leash_ball"
#define COMSIG_XENOABILITY_CREATE_SPIDERLING "xenoability_create_spiderling"
#define COMSIG_XENOABILITY_CREATE_SPIDERLING_USING_CC "xenoability_create_spiderling_using_cc"
#define COMSIG_XENOABILITY_ATTACH_SPIDERLINGS "xenoability_attach_spiderlings"
#define COMSIG_XENOABILITY_CANNIBALISE_SPIDERLING "xenoability_cannibalise_spiderling"
#define COMSIG_XENOABILITY_WEB_HOOK "xenoability_web_hook"
#define COMSIG_XENOABILITY_SPIDERLING_MARK "xenoability_spiderling_mark"

#define COMSIG_XENOABILITY_PSYCHIC_SHIELD "xenoability_psychic_shield"
#define COMSIG_XENOABILITY_TRIGGER_PSYCHIC_SHIELD "xenoability_trigger_psychic_shield"
#define COMSIG_XENOABILITY_PSYCHIC_BLAST "xenoability_psychic_blast"
#define COMSIG_XENOABILITY_PSYCHIC_CRUSH "xenoability_psychic_crush"

#define COMSIG_XENOABILITY_FIRECHARGE "xenoability_firecharge"
#define COMSIG_XENOABILITY_FIRENADO "xenoability_firenado"
#define COMSIG_XENOABILITY_FIREBALL "xenoability_fireball"
#define COMSIG_XENOABILITY_INFERNO "xenoability_inferno"
#define COMSIG_XENOABILITY_INFERNAL_TRIGGER "xenoability_infernal_trigger"

#define COMSIG_XENOABILITY_TENDRILS "xenoability_tendrils"
#define COMSIG_XENOABILITY_ORGANICBOMB "xenoability_puppeteerorganicbomb"
#define COMSIG_XENOABILITY_PUPPET "xenoability_puppet"
#define COMSIG_XENOABILITY_REFURBISHHUSK "xenoability_refurbishhusk"
#define COMSIG_XENOABILITY_DREADFULPRESENCE "xenoability_dreadfulpresence"
#define COMSIG_XENOABILITY_PINCUSHION "xenoability_pincushion"
#define COMSIG_XENOABILITY_FLAY "xenoability_flay"
#define COMSIG_XENOABILITY_UNLEASHPUPPETS "xenoability_unleashpuppets"
#define COMSIG_XENOABILITY_RECALLPUPPETS "xenoability_recallpuppets"
#define COMSIG_XENOABILITY_BESTOWBLESSINGS "xenoability_giveblessings"

#define COMSIG_XENOABILITY_BANELING_EXPLODE "xenoability_baneling_explode"
#define COMSIG_XENOABILITY_BANELING_CHOOSE_REAGENT "xenoability_baneling_choose_reagent"

#define COMSIG_XENOABILITY_BEHEMOTH_ROLL "xenoability_behemoth_roll"
#define COMSIG_XENOABILITY_LANDSLIDE "xenoability_landslide"
#define COMSIG_XENOABILITY_CANCEL_LANDSLIDE "xenoability_cancel_landslide"
#define COMSIG_XENOABILITY_EARTH_RISER "xenoability_earth_riser"
#define COMSIG_XENOABILITY_EARTH_RISER_ALTERNATE "xenoability_earth_riser_alternate"
#define COMSIG_XENOABILITY_EARTH_PILLAR_THROW "xenoability_earth_pillar_throw"
#define COMSIG_XENOABILITY_SEISMIC_FRACTURE "xenoability_seismic_fracture"
#define COMSIG_XENOABILITY_PRIMAL_WRATH "xenoability_primal_wrath"

#define COMSIG_XENOABILITY_ABDUCT "xenoability_abduct"
#define COMSIG_XENOABILITY_DISLOCATE "xenoability_dislocate"
#define COMSIG_XENOABILITY_ITEM_THROW "xenoability_item_throw"
#define COMSIG_XENOABILITY_TAIL_LASH "xenoability_tail_lash"
#define COMSIG_XENOABILITY_TAIL_LASH_SELECT "xenoability_tail_lash_select"
#define COMSIG_XENOABILITY_ADVANCE_OPPRESSOR "xenoability_advance_oppressor"

#define COMSIG_XENOABILITY_BACKHAND "xenoability_backhand"
#define COMSIG_XENOABILITY_FLY "xenoability_fly"
#define COMSIG_XENOABILITY_DRAGON_BREATH "xenoability_dragon_breath"
#define COMSIG_XENOABILITY_WIND_CURRENT "xenoability_wind_current"
#define COMSIG_XENOABILITY_GRAB "xenoability_grab"
#define COMSIG_XENOABILITY_SCORCHED_LAND "xenoability_scorched_land"
