/datum/quirk/web_weaving
	name = "Web Weaver"
	desc = "for whatever reason, you are able to weave silk webs, albeit to a limited extent"
	value = 0 //ERP quirk
	gain_text = "<span class='notice'>You find yourself able to weave webs.</span>"
	lose_text = "<span class='notice'>You are no longer able to weave webs.</span>"
	category = CATEGORY_SEXUAL
	mob_trait = TRAIT_WEB_WEAVER
	///What action is linked with this quirk?
	var/datum/action/innate/wrap_target/linked_action1
	var/datum/action/innate/make_web/linked_action2

/datum/quirk/web_weaving/post_add()
	linked_action1 = new
	linked_action1.Grant(quirk_holder)
	linked_action2 = new
	linked_action2.Grant(quirk_holder)

/datum/quirk/web_weaving/remove()
	linked_action1.Remove(quirk_holder)
	linked_action2.Remove(quirk_holder)
	return ..()
	
/datum/action/innate/wrap_target
	name = "wrap"
	desc = "encases a humanoid in a web cocoon."
	icon_icon = 'GainStation13/icons/obj/clothing/web.dmi'
	button_icon_state = "web_bindings"
	background_icon_state = "bg_alien"

/datum/action/innate/wrap_target/Activate()
	var/mob/living/carbon/user = owner
	if(!user || !ishuman(user))
		return FALSE
	
	var/mob/living/carbon/human/target = user.pulling
	if(!target || !ishuman(target) || user.grab_state < GRAB_AGGRESSIVE) //Add a check for a bondage pref whenever that gets added in.
		to_chat(user, "<span class='warning'>You need to aggressively grab a humanoid to use this.</span>")
		return FALSE

	if(target.wear_suit)
		var/obj/item/clothing/suit = target.wear_suit 
		if(istype(suit, /obj/item/clothing/suit/straight_jacket/web))
			user.visible_message("<span class='warning'>[user] begins to fully encase [target] in a cocoon!</span>", "<span class='warning'>You begin to fully encase [target] in a cocoon.</span>")
			if(!do_after_mob(user, target, 30 SECONDS))
				return FALSE

			var/obj/structure/spider/cocoon/quirk/spawned_cocoon = new(target.loc)
			if(!target.forceMove(spawned_cocoon))
				qdel(spawned_cocoon)
				return FALSE

			spawned_cocoon.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")
			var/cocoon_size = target.size_multiplier
			var/matrix/new_matrix = new

			new_matrix.Scale(cocoon_size)
			new_matrix.Translate(0,16 * (cocoon_size-1))
			spawned_cocoon.transform = new_matrix

			return TRUE 

		user.visible_message("<span class='warning'>[user] attempts to remove [target]'s [target.wear_suit]!</span>", "<span class='warning'>You attempt to remove [target]'s [target.wear_suit].</span>")
		if(!do_after_mob(user, target, 10 SECONDS) || !target.dropItemToGround(suit))
			return FALSE

	var/obj/item/clothing/suit/straight_jacket/web/wrapping = new
	if(!wrapping)
		return FALSE

	user.visible_message("<span class='warning'>[user] attempts to wrap [target] inside of [wrapping]!</span>", "<span class='warning'>You attempt to wrap [target] inside of [wrapping].</span>")
	if(!do_after_mob(user, target, 20 SECONDS) || !target.equip_to_slot_if_possible(wrapping, SLOT_WEAR_SUIT, TRUE, TRUE))
		user.visible_message("<span class='warning'>[user] fails to wrap [target] inside of [wrapping]!</span>", "<span class='warning'>You fail to wrap [target] inside of [wrapping].</span>")
		return FALSE

	user.visible_message("<span class='warning'>[user] successfully [target] inside of [wrapping]!</span>", "<span class='warning'>You successfully wrap [target] inside of [wrapping].</span>")
	return TRUE

/obj/item/clothing/suit/straight_jacket/web
	name = "web bindings"
	desc = "A mesh of sticky web that binds whoever is stuck inside of it"
	icon = 'GainStation13/icons/obj/clothing/web.dmi'
	alternate_worn_icon = 'GainStation13/icons/mob/web.dmi'
	icon_state = "web_bindings"
	item_state = "web_bindings"
	breakouttime = 600 //1 minute is reasonable.
	equip_delay_other = 0
	equip_delay_self = 0
	mutantrace_variation = NO_MUTANTRACE_VARIATION

/obj/item/clothing/suit/straight_jacket/web/equipped(mob/user, slot)
	. = ..()	
	if((user.get_item_by_slot(SLOT_WEAR_SUIT)) != src && !QDELETED(src))
		qdel(src)

/obj/structure/spider/cocoon/quirk
	max_integrity = 20

/datum/action/innate/make_web
	name = "weave"
	desc = "spins a sticky web."
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "stickyweb1"
	background_icon_state = "bg_alien"

/datum/action/innate/make_web/Activate()
	var/turf/T = get_turf(owner)
	owner.visible_message("<span class='warning'>[owner] begins spinning a web!</span>", "<span class='warning'>You begin spinning a web.</span>")
	if(!do_after(owner, 10 SECONDS, 1, null, 1))
		owner.visible_message("<span class='warning'>[owner] fails to spin a web!</span>", "<span class='warning'>You fail to spin web.</span>")
		return FALSE
	T.ChangeTurf(/obj/structure/spider/stickyweb)
	owner.visible_message("<span class='warning'>[owner] spin a sticky web!</span>", "<span class='warning'>You spin a sticky web.</span>")
	return TRUE
