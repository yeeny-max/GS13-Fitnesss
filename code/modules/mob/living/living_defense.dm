
/mob/living/proc/run_armor_check(def_zone = null, attack_flag = "melee", absorb_text = "Your armor absorbs the blow!", soften_text = "Your armor softens the blow!", armour_penetration, penetrated_text = "Your armor was penetrated!")
	var/armor = getarmor(def_zone, attack_flag)

	//the if "armor" check is because this is used for everything on /living, including humans
	if(armor && armour_penetration)
		armor = max(0, armor - armour_penetration)
		if(penetrated_text)
			to_chat(src, "<span class='danger'>[penetrated_text]</span>")
	else if(armor >= 100)
		if(absorb_text)
			to_chat(src, "<span class='danger'>[absorb_text]</span>")
	else if(armor > 0)
		if(soften_text)
			to_chat(src, "<span class='danger'>[soften_text]</span>")
	return armor


/mob/living/proc/getarmor(def_zone, type)
	return 0

//this returns the mob's protection against eye damage (number between -1 and 2) from bright lights
/mob/living/proc/get_eye_protection()
	return 0

//this returns the mob's protection against ear damage (0:no protection; 1: some ear protection; 2: has no ears)
/mob/living/proc/get_ear_protection()
	return 0

/mob/living/proc/is_mouth_covered(head_only = 0, mask_only = 0)
	return FALSE

/mob/living/proc/is_eyes_covered(check_glasses = 1, check_head = 1, check_mask = 1)
	return FALSE

/mob/living/proc/on_hit(obj/item/projectile/P)
	return

/mob/living/proc/check_shields(atom/AM, damage, attack_text = "the attack", attack_type = MELEE_ATTACK, armour_penetration = 0)
	var/block_chance_modifier = round(damage / -3)
	for(var/obj/item/I in held_items)
		if(!istype(I, /obj/item/clothing))
			var/final_block_chance = I.block_chance - (CLAMP((armour_penetration-I.armour_penetration)/2,0,100)) + block_chance_modifier //So armour piercing blades can still be parried by other blades, for example
			if(I.hit_reaction(src, AM, attack_text, final_block_chance, damage, attack_type))
				return TRUE
	return FALSE

/mob/living/proc/check_reflect(def_zone) //Reflection checks for anything in your hands, based on the reflection chance of the object(s)
	for(var/obj/item/I in held_items)
		if(I.IsReflect(def_zone))
			return TRUE
	return FALSE

/mob/living/proc/reflect_bullet_check(obj/item/projectile/P, def_zone)
	if(P.is_reflectable && check_reflect(def_zone)) // Checks if you've passed a reflection% check
		visible_message("<span class='danger'>The [P.name] gets reflected by [src]!</span>", \
						"<span class='userdanger'>The [P.name] gets reflected by [src]!</span>")
		// Find a turf near or on the original location to bounce to
		if(P.starting)
			var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/turf/curloc = get_turf(src)
			// redirect the projectile
			P.original = locate(new_x, new_y, P.z)
			P.starting = curloc
			P.firer = src
			P.yo = new_y - curloc.y
			P.xo = new_x - curloc.x
			var/new_angle_s = P.Angle + rand(120,240)
			while(new_angle_s > 180)	// Translate to regular projectile degrees
				new_angle_s -= 360
			P.setAngle(new_angle_s)
		return TRUE
	return FALSE

/mob/living/bullet_act(obj/item/projectile/P, def_zone)
	if(P.original != src || P.firer != src) //try to block or reflect the bullet, can't do so when shooting oneself
		if(reflect_bullet_check(P, def_zone))
			return -1 // complete projectile permutation
		if(check_shields(P, P.damage, "the [P.name]", PROJECTILE_ATTACK, P.armour_penetration))
			P.on_hit(src, 100, def_zone)
			return 2
	var/armor = run_armor_check(def_zone, P.flag, null, null, P.armour_penetration, null)
	if(!P.nodamage)
		apply_damage(P.damage, P.damage_type, def_zone, armor)
		if(P.dismemberment)
			check_projectile_dismemberment(P, def_zone)
	return P.on_hit(src, armor)

/mob/living/proc/check_projectile_dismemberment(obj/item/projectile/P, def_zone)
	return 0

/obj/item/proc/get_volume_by_throwforce_and_or_w_class()
		if(throwforce && w_class)
				return CLAMP((throwforce + w_class) * 5, 30, 100)// Add the item's throwforce to its weight class and multiply by 5, then clamp the value between 30 and 100
		else if(w_class)
				return CLAMP(w_class * 8, 20, 100) // Multiply the item's weight class by 8, then clamp the value between 20 and 100
		else
				return 0

/mob/living/proc/catch_item(obj/item/I, skip_throw_mode_check = FALSE)
	return FALSE

/mob/living/proc/embed_item(obj/item/I)
	return

/mob/living/proc/can_embed(obj/item/I)
	return FALSE

/mob/living/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	var/obj/item/I
	var/throwpower = 30
	if(isitem(AM))
		I = AM
		throwpower = I.throwforce
	if(check_shields(AM, throwpower, "\the [AM.name]", THROWN_PROJECTILE_ATTACK))
		hitpush = FALSE
		skipcatch = TRUE
		blocked = TRUE
	else if(I && I.throw_speed >= EMBED_THROWSPEED_THRESHOLD && can_embed(I, src) && prob(I.embedding.embed_chance) && !HAS_TRAIT(src, TRAIT_PIERCEIMMUNE) && (!HAS_TRAIT(src, TRAIT_AUTO_CATCH_ITEM) || incapacitated() || get_active_held_item()))
		embed_item(I)
		hitpush = FALSE
		skipcatch = TRUE //can't catch the now embedded item
	if(I)
		if(!skipcatch && isturf(I.loc) && catch_item(I))
			return TRUE
		var/zone = ran_zone(BODY_ZONE_CHEST, 65)//Hits a random part of the body, geared towards the chest
		var/dtype = BRUTE

		SEND_SIGNAL(I, COMSIG_MOVABLE_IMPACT_ZONE, src, zone)
		dtype = I.damtype

		if(!blocked)
			visible_message("<span class='danger'>[src] has been hit by [I].</span>", \
							"<span class='userdanger'>[src] has been hit by [I].</span>")
			var/armor = run_armor_check(zone, "melee", "Your armor has protected your [parse_zone(zone)].", "Your armor has softened hit to your [parse_zone(zone)].",I.armour_penetration)
			apply_damage(I.throwforce, dtype, zone, armor)
			if(I.thrownby)
				log_combat(I.thrownby, src, "threw and hit", I)
		else
			return 1
	else
		playsound(loc, 'sound/weapons/genhit.ogg', 50, 1, -1)
	..()


/mob/living/mech_melee_attack(obj/mecha/M)
	if(M.occupant.a_intent == INTENT_HARM)
		M.do_attack_animation(src)
		if(M.damtype == "brute")
			step_away(src,M,15)
		switch(M.damtype)
			if(BRUTE)
				Unconscious(20)
				take_overall_damage(rand(M.force/2, M.force))
				playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
			if(BURN)
				take_overall_damage(0, rand(M.force/2, M.force))
				playsound(src, 'sound/items/welder.ogg', 50, 1)
			if(TOX)
				M.mech_toxin_damage(src)
			else
				return
		updatehealth()
		visible_message("<span class='danger'>[M.name] has hit [src]!</span>", \
						"<span class='userdanger'>[M.name] has hit [src]!</span>", null, COMBAT_MESSAGE_RANGE)
		log_combat(M.occupant, src, "attacked", M, "(INTENT: [uppertext(M.occupant.a_intent)]) (DAMTYPE: [uppertext(M.damtype)])")
	else
		step_away(src,M)
		log_combat(M.occupant, src, "pushed", M)
		visible_message("<span class='warning'>[M] pushes [src] out of the way.</span>", null, null, 5)

/mob/living/fire_act()
	adjust_fire_stacks(3)
	IgniteMob()

/mob/living/proc/grabbedby(mob/living/carbon/user, supress_message = FALSE)
	if(user == anchored || !isturf(user.loc))
		return FALSE

	//pacifist vore check.
	if(user.pulling && HAS_TRAIT(user, TRAIT_PACIFISM) && user.voremode) //they can only do heals, noisy guts, absorbing (technically not harm)
		if(ismob(user.pulling))
			var/mob/P = user.pulling
			if(src != user)
				to_chat(user, "<span class='notice'>You can't risk digestion!</span>")
				return FALSE
			else
				user.vore_attack(user, P, user)
				return

	//normal vore check.
	if(user.pulling && user.grab_state == GRAB_AGGRESSIVE && user.voremode)
		if(ismob(user.pulling))
			var/mob/P = user.pulling
			user.vore_attack(user, P, src) // User, Pulled, Predator target (which can be user, pulling, or src)
			return

	if(user == src) //we want to be able to self click if we're voracious
		return FALSE

	if(!user.pulling || user.pulling != src)
		user.start_pulling(src, supress_message = supress_message)
		return

	if(!(status_flags & CANPUSH) || HAS_TRAIT(src, TRAIT_PUSHIMMUNE))
		to_chat(user, "<span class='warning'>[src] can't be grabbed more aggressively!</span>")
		return FALSE

	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, "<span class='notice'>You don't want to risk hurting [src]!</span>")
		return FALSE

	grippedby(user)

//proc to upgrade a simple pull into a more aggressive grab.
/mob/living/proc/grippedby(mob/living/carbon/user, instant = FALSE)
	if(user.grab_state < GRAB_KILL)
		user.changeNext_move(CLICK_CD_GRABBING)
		playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

		if(user.grab_state) //only the first upgrade is instantaneous
			var/old_grab_state = user.grab_state
			var/grab_upgrade_time = instant ? 0 : 30
			visible_message("<span class='danger'>[user] starts to tighten [user.p_their()] grip on [src]!</span>", \
				"<span class='userdanger'>[user] starts to tighten [user.p_their()] grip on you!</span>")
			switch(user.grab_state)
				if(GRAB_AGGRESSIVE)
					log_combat(user, src, "attempted to neck grab", addition="neck grab")
				if(GRAB_NECK)
					log_combat(user, src, "attempted to strangle", addition="kill grab")
			if(!do_mob(user, src, grab_upgrade_time))
				return 0
			if(!user.pulling || user.pulling != src || user.grab_state != old_grab_state || user.a_intent != INTENT_GRAB)
				return 0
			if(user.voremode && user.grab_state == GRAB_AGGRESSIVE)
				return 0
		user.grab_state++
		switch(user.grab_state)
			if(GRAB_AGGRESSIVE)
				log_combat(user, src, "grabbed", addition="aggressive grab")
				visible_message("<span class='danger'>[user] has grabbed [src] aggressively!</span>", \
								"<span class='userdanger'>[user] has grabbed [src] aggressively!</span>")
				drop_all_held_items()
				stop_pulling()
			if(GRAB_NECK)
				log_combat(user, src, "grabbed", addition="neck grab")
				visible_message("<span class='danger'>[user] has grabbed [src] by the neck!</span>",\
								"<span class='userdanger'>[user] has grabbed you by the neck!</span>")
				update_canmove() //we fall down
				if(!buckled && !density)
					Move(user.loc)
			if(GRAB_KILL)
				log_combat(user, src, "strangled", addition="kill grab")
				visible_message("<span class='danger'>[user] is strangling [src]!</span>", \
								"<span class='userdanger'>[user] is strangling you!</span>")
				update_canmove() //we fall down
				if(!buckled && !density)
					Move(user.loc)
		return 1

/mob/living/attack_hand(mob/user)
	..() //Ignoring parent return value here.
	SEND_SIGNAL(src, COMSIG_MOB_ATTACK_HAND, user)
	if((user != src) && user.a_intent != INTENT_HELP && check_shields(user, 0, user.name, attack_type = UNARMED_ATTACK))
		log_combat(user, src, "attempted to touch")
		visible_message("<span class='warning'>[user] attempted to touch [src]!</span>")
		return TRUE

/mob/living/attack_hulk(mob/living/carbon/human/user, does_attack_animation = FALSE)
	if(user.a_intent == INTENT_HARM)
		if(HAS_TRAIT(user, TRAIT_PACIFISM))
			to_chat(user, "<span class='notice'>You don't want to hurt [src]!</span>")
			return TRUE
		var/hulk_verb = pick("smash","pummel")
		if(user != src && check_shields(user, 15, "the [hulk_verb]ing"))
			return TRUE
		..()
	return FALSE

/mob/living/attack_slime(mob/living/simple_animal/slime/M)
	if(!SSticker.HasRoundStarted())
		to_chat(M, "You cannot attack people before the game has started.")
		return

	if(M.buckled)
		if(M in buckled_mobs)
			M.Feedstop()
		return // can't attack while eating!

	if(HAS_TRAIT(src, TRAIT_PACIFISM))
		to_chat(M, "<span class='notice'>You don't want to hurt anyone!</span>")
		return FALSE

	var/damage = rand(5, 35)
	if(M.is_adult)
		damage = rand(20, 40)
	if(check_shields(M, damage, "the [M.name]"))
		return FALSE

	if (stat != DEAD)
		log_combat(M, src, "attacked")
		M.do_attack_animation(src)
		visible_message("<span class='danger'>The [M.name] glomps [src]!</span>", \
				"<span class='userdanger'>The [M.name] glomps [src]!</span>", null, COMBAT_MESSAGE_RANGE)
		return TRUE

/mob/living/attack_animal(mob/living/simple_animal/M)
	M.face_atom(src)
	if(M.melee_damage_upper == 0)
		M.visible_message("<span class='notice'>\The [M] [M.friendly] [src]!</span>")
		return FALSE
	else
		if(HAS_TRAIT(M, TRAIT_PACIFISM))
			to_chat(M, "<span class='notice'>You don't want to hurt anyone!</span>")
			return FALSE
		if(check_shields(M, rand(M.melee_damage_lower, M.melee_damage_upper), "the [M.name]", MELEE_ATTACK, M.armour_penetration))
			return FALSE
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 50, 1, 1)
		M.do_attack_animation(src)
		visible_message("<span class='danger'>\The [M] [M.attacktext] [src]!</span>", \
						"<span class='userdanger'>\The [M] [M.attacktext] [src]!</span>", null, COMBAT_MESSAGE_RANGE)
		log_combat(M, src, "attacked")
		return TRUE


/mob/living/attack_paw(mob/living/carbon/monkey/M)
	if (M.a_intent == INTENT_HARM)
		if(HAS_TRAIT(M, TRAIT_PACIFISM))
			to_chat(M, "<span class='notice'>You don't want to hurt anyone!</span>")
			return FALSE

		if(M.is_muzzled() || (M.wear_mask && M.wear_mask.flags_cover & MASKCOVERSMOUTH))
			to_chat(M, "<span class='warning'>You can't bite with your mouth covered!</span>")
			return FALSE
		if(check_shields(M, 0, "the [M.name]"))
			return FALSE
		M.do_attack_animation(src, ATTACK_EFFECT_BITE)
		if (prob(75))
			log_combat(M, src, "attacked")
			playsound(loc, 'sound/weapons/bite.ogg', 50, 1, -1)
			visible_message("<span class='danger'>[M.name] bites [src]!</span>", \
					"<span class='userdanger'>[M.name] bites [src]!</span>", null, COMBAT_MESSAGE_RANGE)
			return TRUE
		else
			visible_message("<span class='danger'>[M.name] has attempted to bite [src]!</span>", \
				"<span class='userdanger'>[M.name] has attempted to bite [src]!</span>", null, COMBAT_MESSAGE_RANGE)
	return FALSE

/mob/living/attack_larva(mob/living/carbon/alien/larva/L)
	switch(L.a_intent)
		if(INTENT_HELP)
			visible_message("<span class='notice'>[L.name] rubs its head against [src].</span>")
			return FALSE

		else
			if(HAS_TRAIT(L, TRAIT_PACIFISM))
				to_chat(L, "<span class='notice'>You don't want to hurt anyone!</span>")
				return FALSE
			if(L != src && check_shields(L, rand(1, 3), "the [L.name]"))
				return FALSE

			L.do_attack_animation(src)
			if(prob(90))
				log_combat(L, src, "attacked")
				visible_message("<span class='danger'>[L.name] bites [src]!</span>", \
					"<span class='userdanger'>[L.name] bites [src]!</span>", null, COMBAT_MESSAGE_RANGE)
				playsound(loc, 'sound/weapons/bite.ogg', 50, 1, -1)
				return TRUE
			else
				visible_message("<span class='danger'>[L.name] has attempted to bite [src]!</span>", \
					"<span class='userdanger'>[L.name] has attempted to bite [src]!</span>", null, COMBAT_MESSAGE_RANGE)
	return FALSE

/mob/living/attack_alien(mob/living/carbon/alien/humanoid/M)
	if((M != src) && M.a_intent != INTENT_HELP && check_shields(M, 0, "the [M.name]"))
		visible_message("<span class='danger'>[M] attempted to touch [src]!</span>")
		return FALSE
	switch(M.a_intent)
		if (INTENT_HELP)
			if(!isalien(src)) //I know it's ugly, but the alien vs alien attack_alien behaviour is a bit different.
				visible_message("<span class='notice'>[M] caresses [src] with its scythe like arm.</span>")
			return FALSE
		if (INTENT_GRAB)
			grabbedby(M)
			return FALSE
		if(INTENT_HARM)
			if(HAS_TRAIT(M, TRAIT_PACIFISM))
				to_chat(M, "<span class='notice'>You don't want to hurt anyone!</span>")
				return FALSE
			if(!isalien(src))
				M.do_attack_animation(src)
			return TRUE
		if(INTENT_DISARM)
			if(!isalien(src))
				M.do_attack_animation(src, ATTACK_EFFECT_DISARM)
			return TRUE

/mob/living/ex_act(severity, target, origin)
	if(origin && istype(origin, /datum/spacevine_mutation) && isvineimmune(src))
		return
	..()

//Looking for irradiate()? It's been moved to radiation.dm under the rad_act() for mobs.

/mob/living/acid_act(acidpwr, acid_volume)
	take_bodypart_damage(acidpwr * min(1, acid_volume * 0.1))
	return 1

/mob/living/proc/electrocute_act(shock_damage, obj/source, siemens_coeff = 1, safety = 0, tesla_shock = 0, illusion = 0, stun = TRUE)
	SEND_SIGNAL(src, COMSIG_LIVING_ELECTROCUTE_ACT, shock_damage)
	if(tesla_shock && (flags_1 & TESLA_IGNORE_1))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_SHOCKIMMUNE))
		return FALSE
	if(shock_damage > 0)
		if(!illusion)
			adjustFireLoss(shock_damage)
		visible_message(
			"<span class='danger'>[src] was shocked by \the [source]!</span>", \
			"<span class='userdanger'>You feel a powerful shock coursing through your body!</span>", \
			"<span class='italics'>You hear a heavy electrical crack.</span>" \
		)
		return shock_damage

/mob/living/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_CONTENTS)
		return
	for(var/obj/O in contents)
		O.emp_act(severity)

/mob/living/singularity_act()
	var/gain = 20
	investigate_log("([key_name(src)]) has been consumed by the singularity.", INVESTIGATE_SINGULO) //Oh that's where the clown ended up!
	gib()
	return(gain)

/mob/living/narsie_act()
	if(status_flags & GODMODE || QDELETED(src))
		return

	if(is_servant_of_ratvar(src) && !stat)
		to_chat(src, "<span class='userdanger'>You resist Nar'Sie's influence... but not all of it. <i>Run!</i></span>")
		adjustBruteLoss(35)
		if(src && reagents)
			reagents.add_reagent(/datum/reagent/toxin/heparin, 5)
		return FALSE
	if(GLOB.cult_narsie && GLOB.cult_narsie.souls_needed[src])
		GLOB.cult_narsie.souls_needed -= src
		GLOB.cult_narsie.souls += 1
		if((GLOB.cult_narsie.souls == GLOB.cult_narsie.soul_goal) && (GLOB.cult_narsie.resolved == FALSE))
			GLOB.cult_narsie.resolved = TRUE
			sound_to_playing_players('sound/machines/alarm.ogg')
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cult_ending_helper), 1), 120)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ending_helper)), 270)
	if(client)
		makeNewConstruct(/mob/living/simple_animal/hostile/construct/harvester, src, cultoverride = TRUE)
	else
		switch(rand(1, 6))
			if(1)
				new /mob/living/simple_animal/hostile/construct/armored/hostile(get_turf(src))
			if(2)
				new /mob/living/simple_animal/hostile/construct/wraith/hostile(get_turf(src))
			if(3 to 6)
				new /mob/living/simple_animal/hostile/construct/builder/hostile(get_turf(src))
	spawn_dust()
	gib()
	return TRUE


/mob/living/ratvar_act()
	if(status_flags & GODMODE)
		return
	if(stat != DEAD && !is_servant_of_ratvar(src))
		to_chat(src, "<span class='userdanger'>A blinding light boils you alive! <i>Run!</i></span>")
		adjust_fire_stacks(20)
		IgniteMob()
		return FALSE


//called when the mob receives a bright flash
/mob/living/proc/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0, type = /obj/screen/fullscreen/flash)
	if(get_eye_protection() < intensity && (override_blindness_check || !(HAS_TRAIT(src, TRAIT_BLIND))))
		overlay_fullscreen("flash", type)
		addtimer(CALLBACK(src,PROC_REF(clear_fullscreen), "flash", 25), 25)
		return TRUE
	return FALSE

//called when the mob receives a loud bang
/mob/living/proc/soundbang_act()
	return 0

//to damage the clothes worn by a mob
/mob/living/proc/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	return


/mob/living/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!used_item)
		used_item = get_active_held_item()
	..()
	floating = 0 // If we were without gravity, the bouncing animation got stopped, so we make sure we restart the bouncing after the next movement.
