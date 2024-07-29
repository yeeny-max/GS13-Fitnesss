/obj/item/dyespray
	name = "hair dye spray"
	desc = "A spray to dye your hair any gradients you'd like."
	icon = 'icons/obj/dyespray.dmi'
	icon_state = "dyespray"

	var/uses = 10 //SKYRAT EDIT ADDITION

/obj/item/dyespray/attack_self(mob/user)
	dye(user)

/obj/item/dyespray/pre_attack(atom/target, mob/living/user, params)
	dye(target)
	return ..()

/**
 * Applies a gradient and a gradient color to a mob.
 *
 * Arguments:
 * * target - The mob who we will apply the gradient and gradient color to.
 */

/obj/item/dyespray/proc/dye(mob/target)
	if(!ishuman(target))
		return

	if(!uses) //SKYRAT EDIT ADDITION
		return //SKYRAT EDIT ADDITION
	
	var/mob/living/carbon/human/human_target = target

	var/new_hair_color = input(usr, "Choose a base hair color:", "Character Preference","#"+human_target.hair_color) as color|null
	if(!new_hair_color)
		return

	var/new_grad_style = input(usr, "Choose a color pattern:", "Character Preference")  as null|anything in GLOB.hair_gradients_list
	if(!new_grad_style)
		return

	var/new_grad_color = input(usr, "Choose a secondary hair color:", "Character Preference","#"+human_target.grad_color) as color|null
	if(!new_grad_color)
		return

	human_target.hair_color = sanitize_hexcolor(new_hair_color)
	human_target.grad_style = new_grad_style
	human_target.grad_color = sanitize_hexcolor(new_grad_color)
	to_chat(human_target, "<span class='notice'>You start applying the hair dye...</span>")
	if(!do_after(usr, 30, target = human_target))
		return
	playsound(src, 'sound/effects/spray.ogg', 5, TRUE, 5)
	human_target.update_hair()

	//SKYRAT EDIT ADDITION
	uses--

/obj/item/dyespray/examine(mob/user)
	. = ..()
	. += "It has [uses] uses left."

	//SKYRAT EDIT END
