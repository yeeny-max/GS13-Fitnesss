//GS13 - fat chems

//WG chem
/datum/chemical_reaction/lipoifier
	name = "lipoifier"
	id = /datum/reagent/consumable/lipoifier
	results = list(/datum/reagent/consumable/lipoifier = 3)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/consumable/cornoil = 1, /datum/reagent/medicine/synthflesh = 1)

//BURP CHEM
/datum/chemical_reaction/fizulphite
	name = "fizulphite"
	id = /datum/reagent/consumable/fizulphite
	results = list(/datum/reagent/consumable/fizulphite = 5)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/nitrogen = 1, /datum/reagent/oxygen = 3)

//ANTI-BURP / ANTI-FULLNESS CHEM
/datum/chemical_reaction/extilphite
	name = "extilphite"
	id = /datum/reagent/consumable/extilphite
	results = list(/datum/reagent/consumable/extilphite = 5)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/hydrogen = 2, /datum/reagent/carbon = 2)

// brap chem
/datum/chemical_reaction/flatulose
	name = "flatulose"
	id = /datum/reagent/consumable/flatulose
	results = list(/datum/reagent/consumable/flatulose = 3)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/toxin/bad_food = 1, /datum/reagent/consumable/cream = 1)
