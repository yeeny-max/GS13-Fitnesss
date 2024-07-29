/////////////////////////////////////////
///GS13 designs / nutri designs
/////////////////////////////////////////


//nutritech weapons
/datum/design/fatoray_weak
	name = "Basic Fatoray"
	id = "fatoray_weak"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 8000, MAT_GLASS = 6000, MAT_CALORITE = 10000)
	construction_time = 75
	build_path = /obj/item/gun/energy/fatoray/weak
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_SECURITY

/datum/design/fatoray_cannon_weak
	name = "Basic Cannonshot Fatoray"
	id = "fatoray_cannon_weak"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 10000, MAT_GLASS = 8000, MAT_CALORITE = 20000)
	construction_time = 200
	build_path = /obj/item/gun/energy/fatoray/cannon_weak
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_SECURITY

/datum/design/alter_ray_metabolism
	name = "AL-T-Ray: Metabolism"
	id = "alter_ray_metabolism"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 10000, MAT_GLASS = 8000, MAT_CALORITE = 26000)
	construction_time = 200
	build_path = /obj/item/gun/energy/laser/alter_ray/gainrate
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_SECURITY


/datum/design/alter_ray_reverser
	name = "AL-T-Ray: Reverser"
	id = "alter_ray_reverser"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 10000, MAT_GLASS = 8000, MAT_CALORITE = 26000)
	construction_time = 200
	build_path = /obj/item/gun/energy/laser/alter_ray/noloss
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_SECURITY

//nutritech tools
/datum/design/calorite_collar
	name = "Calorite Collar"
	desc = "A collar that amplifies caloric intake of the wearer."
	id = "calorite_collar"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_CALORITE = 4000)
	construction_time = 75
	build_path = /obj/item/clothing/neck/petcollar/calorite
	category = list("Equipment", "Misc", "Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/cyberimp_nutriment_turbo
	name = "Nutriment Pump Implant TURBO"
	desc = "This implant was meant to prevent people from going hungry, but due to a flaw in its designs, it permanently produces a small amount of nutriment overtime."
	id = "ci-nutrimentturbo"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 100
	materials = list(MAT_METAL = 800, MAT_GLASS = 800, MAT_GOLD = 750, MAT_URANIUM = 1000)
	build_path = /obj/item/organ/cyberimp/chest/nutriment/turbo
	category = list("Misc", "Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/bluespace_belt
	name = "Bluespace Belt"
	desc = "A belt made using bluespace technology. The power of space and time, used to hide the fact you are fat."
	id = "bluespace_belt"
	build_type = PROTOLATHE
	construction_time = 100
	materials = list(MAT_SILVER = 4000, MAT_GOLD = 4000, MAT_BLUESPACE = 2000, )
	build_path = /obj/item/bluespace_belt
	category = list("Misc", "Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/cookie_synthesizer
	name = "Cookie Synthesizer"
	desc = "A self-charging miraculous device that's able to produce cookies."
	id = "cookie_synthesizer"
	build_type = PROTOLATHE
	construction_time = 100
	materials = list(MAT_SILVER = 4000, MAT_URANIUM = 1000, MAT_BLUESPACE = 1000, MAT_CALORITE = 2000)
	build_path = /obj/item/cookiesynth
	category = list("Misc", "Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_SERVICE

//these are made in mech fabricator
/datum/design/borg_cookie_synthesizer
	name = "Cyborg Upgrade (Cookie Synthesizer)"
	id = "borg_upgrade_cookiesynthesizer"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/cookiesynth
	materials = list(MAT_METAL=10000, MAT_GOLD=1500, MAT_URANIUM=250, MAT_PLASMA=1500)
	construction_time = 100
	category = list("Cyborg Upgrade Modules")

/datum/design/borg_fatoray
	name = "Cyborg Upgrade (Fatoray)"
	id = "borg_upgrade_fatoray"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/fatoray
	materials = list(MAT_METAL = 8000, MAT_GLASS = 6000, MAT_CALORITE = 10000)
	construction_time = 100
	category = list("Cyborg Upgrade Modules")

/datum/design/borg_feedtube
	name = "Cyborg Upgrade (Feeding Tube)"
	id = "borg_upgrade_feedingtube"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/feedtube
	materials = list(MAT_METAL = 8000, MAT_GLASS = 6000, MAT_CALORITE = 10000)
	construction_time = 100
	category = list("Cyborg Upgrade Modules")

//todo: make a seperate file for extra borg modules

/obj/item/borg/upgrade/cookiesynth
	name = "cyborg cookie synthesizer"
	desc = "An extra module that allows cyborgs to dispense cookies."
	icon_state = "cyborg_upgrade3"

/obj/item/borg/upgrade/cookiesynth/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)		
		var/obj/item/cookiesynth/S = new(R.module)
		R.module.basic_modules += S
		R.module.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/cookiesynth/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/cookiesynth/S = locate() in R.module
		R.module.remove_module(S, TRUE)


/obj/item/gun/energy/fatoray/weak/cyborg
	name = "cyborg fatoray"
	desc = "An integrated fatoray for cyborg use."
	icon = 'GainStation13/icons/obj/fatoray.dmi'
	icon_state = "fatoray_weak"
	can_charge = FALSE
	selfcharge = EGUN_SELFCHARGE_BORG
	cell_type = /obj/item/stock_parts/cell/secborg
	charge_delay = 5

/obj/item/borg/upgrade/fatoray
	name = "cyborg fatoray module"
	desc = "An extra module that allows cyborgs to use fatoray weapons."
	icon_state = "cyborg_upgrade3"

/obj/item/borg/upgrade/fatoray/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)		
		var/obj/item/gun/energy/fatoray/weak/cyborg/S = new(R.module)
		R.module.basic_modules += S
		R.module.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/fatoray/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/gun/energy/fatoray/weak/cyborg/S = locate() in R.module
		R.module.remove_module(S, TRUE)



//cyborg regen feeding tube

/obj/item/reagent_containers/borghypo/feeding_tube
	name = "cyborg feeding tube"
	desc = "A feeding tube module for a cyborg."
	icon = 'GainStation13/icons/obj/feeding_tube.dmi'
	icon_state = "borg_tube"
	possible_transfer_amounts = list(5,10,20)
	charge_cost = 20
	recharge_time = 3
	accepts_reagent_upgrades = FALSE
	reagent_ids = list(/datum/reagent/consumable/cream, /datum/reagent/consumable/milk, /datum/reagent/consumable/nutriment)
	var/starttime = 0
	var/chemtoadd = 5

/obj/item/reagent_containers/borghypo/feeding_tube/attack(mob/living/carbon/M, mob/user)
	var/datum/reagents/R = reagent_list[mode]
	if(!R.total_volume)
		to_chat(user, "<span class='notice'>The injector is empty.</span>")
		return
	if(!istype(M))
		return
	if(R.total_volume && M.can_inject(user, 1, user.zone_selected,bypass_protection))
	
		if(M == user.pulling && ishuman(user.pulling))
			starttime = world.time
			while(starttime + 300 > world.time && in_range(user, M))
				if(do_mob(user, M, 10, 0, 1))
					M.reagents.add_reagent(/datum/reagent/consumable/nutriment, chemtoadd)
					M.visible_message("<span class='danger'>[user] pumps some liquid in [M]!</span>","<span class='userdanger'>[user] pumps some liquid in you!</span>")
		else
			to_chat(M, "<span class='warning'>You feel the cyborg's feeding tube pour liquid down your throat!</span>")
			to_chat(user, "<span class='warning'>You feed [M] with the integrated feeding tube.</span>")
			visible_message("<span class='warning'>The cyborg's feeding tube pours liquid down [M]'s throat!</span>")
			var/fraction = min(amount_per_transfer_from_this/R.total_volume, 1)
			R.reaction(M, INJECT, fraction)
			if(M.reagents)
				var/trans = R.trans_to(M, amount_per_transfer_from_this)
				to_chat(user, "<span class='notice'>[trans] unit\s injected.  [R.total_volume] unit\s remaining.</span>")

/obj/item/reagent_containers/borghypo/feeding_tube/regenerate_reagents()
	if(iscyborg(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		if(R && R.cell)
			for(var/i in modes) //Lots of reagents in this one, so it's best to regenrate them all at once to keep it from being tedious.
				var/valueofi = modes[i]
				var/datum/reagents/RG = reagent_list[valueofi]
				if(RG.total_volume < RG.maximum_volume)
					R.cell.use(charge_cost)
					RG.add_reagent(reagent_ids[valueofi], 5)


/obj/item/borg/upgrade/feedtube
	name = "cyborg feeding tube module"
	desc = "An extra module that allows cyborgs to use an integrated feeding tube along with a synthesizer."
	icon_state = "cyborg_upgrade3"

/obj/item/borg/upgrade/feedtube/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)		
		var/obj/item/reagent_containers/borghypo/feeding_tube/S = new(R.module)
		R.module.basic_modules += S
		R.module.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/feedtube/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/reagent_containers/borghypo/feeding_tube/S = locate() in R.module
		R.module.remove_module(S, TRUE)
