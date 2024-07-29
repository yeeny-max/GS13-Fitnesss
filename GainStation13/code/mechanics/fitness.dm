
/mob/living/carbon
	//right, so this might be a little sloppy, but I'm gonna do my best here, mostly just using the fatness code itself as a template, almost, just omitting stuff like XWG and stuckage.
	//What level of fitness is the parent mob currently at?
	var/fitness = 0
	//The list of items/effects that are being added/subtracted from our real fitness
	var/fit_hiders = list()
	//The actual value a mob is at. Is equal to fitness if fit_hider is FALSE.
	var/fitness_real = 0
	///At what rate does the parent mob gain fitness? 1 = 100%
	var/fitness_gain_rate = 1
	//At what rate does the parent mob lose fitness? 1 = 100%
	var/fitness_loss_rate = 1

/** 
* Adjusts the fitness level of the parent mob.
*
* * adjustment_amount - adjusts how much fitness is gained or loss. Positive numbers add fitness. 
* * type_of_fittening - what type of fittening is being used.
*/
/mob/living/carbon/proc/adjust_fitness(adjustment_amount, type_of_fittening = FITTENING_TYPE_ITEM)
	if(!adjustment_amount || !type_of_fittening)
		return FALSE


	var/amount_to_change = adjustment_amount
	if(adjustment_amount > 0)
		amount_to_change = amount_to_change * fitness_gain_rate	
	else
		amount_to_change = amount_to_change * fitness_loss_rate

	fitness_real += amount_to_change 
	//fitness_real = max(fitness_real, MINIMUM_FITNESS_LEVEL) //if you have negative muscles, I'm praying for you, dear god, that's rough, man. But it is what it is

	//if(client?.prefs?.max_fitness) // GS13
		//fitness_real = min(fitness_real, (client?.prefs?.max_fitness - 1))

	fitness = fitness_real //Make their current fitness their real fitness

	hiders_apply()

	return TRUE


/mob/living/carbon/fully_heal(admin_revive)
	fitness = 0
	fitness_real = 0
	. = ..()

/mob/living/carbon/human/handle_breathing(times_fired)
	. = ..()
	hiders_apply()


/proc/get_fitness_level_name(fitness_amount)
	if(fitness_amount < FITNESS_LEVEL_FIT)
		return "Normal"
	if(fitness_amount < FITNESS_LEVEL_TONED)
		return "Fit"
	if(fitness_amount < FITNESS_LEVEL_WELL_TONED)
		return "Toned"
	if(fitness_amount < FITNESS_LEVEL_SPORTY)
		return "Well Toned"
	if(fitness_amount < FITNESS_LEVEL_ATHLETIC)
		return "Sporty"
	if(fitness_amount < FITNESS_LEVEL_VERY_ATHLETIC)
		return "Athletic"
	if(fitness_amount < FITNESS_LEVEL_BODYBUILDER)
		return "Very Athletic"
	if(fitness_amount < FITNESS_LEVEL_AMAZONIAN)
		return "Bodybuilder"
	if(fitness_amount < FITNESS_LEVEL_HALSEY)
		return "Amazonian"

	return "Herculean"
