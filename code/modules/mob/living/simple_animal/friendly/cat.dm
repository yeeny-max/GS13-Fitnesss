//Cat
/mob/living/simple_animal/pet/cat
	name = "cat"
	desc = "Kitty!!"
	icon = 'icons/mob/pets.dmi'
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	gender = MALE
	speak = list("Meow!", "Esp!", "Purr!", "HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows.", "mews.")
	emote_see = list("shakes its head.", "shivers.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minbodytemp = 200
	maxbodytemp = 400
	unsuitable_atmos_damage = 1
	animal_species = /mob/living/simple_animal/pet/cat
	childtype = list(/mob/living/simple_animal/pet/cat/kitten)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 2, /obj/item/organ/ears/cat = 1, /obj/item/organ/tail/cat = 1)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target
	gold_core_spawnable = FRIENDLY_SPAWN
	collar_type = "cat"
	size_multiplier = 0.5

	var/held_icon = "cat2"
	do_footstep = TRUE

/mob/living/simple_animal/pet/cat/Initialize()
	. = ..()
	add_verb(src, /mob/living/proc/lay_down)

/mob/living/simple_animal/pet/cat/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/wuv, "purrs!", EMOTE_AUDIBLE, /datum/mood_event/pet_animal, "hisses!", EMOTE_AUDIBLE)
	AddElement(/datum/element/mob_holder, held_icon)

/mob/living/simple_animal/pet/cat/update_canmove()
	..()
	if(client && stat != DEAD)
		if (resting)
			icon_state = "[icon_living]_rest"
			collar_type = "[initial(collar_type)]_rest"
		else
			icon_state = "[icon_living]"
			collar_type = "[initial(collar_type)]"
	regenerate_icons()


/mob/living/simple_animal/pet/cat/space
	name = "space cat"
	desc = "It's a cat... in space!"
	icon_state = "spacecat"
	icon_living = "spacecat"
	icon_dead = "spacecat_dead"
	held_icon = "spacecat"
	unsuitable_atmos_damage = 0
	minbodytemp = TCMB
	maxbodytemp = T0C + 40

/mob/living/simple_animal/pet/cat/original
	name = "Batsy"
	desc = "The product of alien DNA and bored geneticists."
	gender = FEMALE
	icon_state = "original"
	icon_living = "original"
	icon_dead = "original_dead"
	held_icon = "original"
	collar_type = null
	unique_pet = TRUE

/mob/living/simple_animal/pet/cat/kitten
	name = "kitten"
	desc = "D'aaawwww."
	icon_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	density = FALSE
	pass_flags = PASSMOB
	mob_size = MOB_SIZE_SMALL
	collar_type = "kitten"
	held_icon = "cat"

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/pet/cat/Runtime
	name = "Runtime"
	desc = "GCAT"
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	gender = FEMALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE
	var/list/family = list()//var restored from savefile, has count of each child type
	var/list/children = list()//Actual mob instances of children
	var/cats_deployed = 0
	//var/memory_saved = FALSE

/mob/living/simple_animal/pet/cat/Runtime/Initialize()
	if(prob(5))
		icon_state = "original"
		icon_living = "original"
		icon_dead = "original_dead"
	//Read_Memory()
	. = ..()
/*
/mob/living/simple_animal/pet/cat/Runtime/Life()
	if(!cats_deployed && SSticker.current_state >= GAME_STATE_SETTING_UP)
		Deploy_The_Cats()
	if(!stat && SSticker.current_state == GAME_STATE_FINISHED && !memory_saved)
		Write_Memory()
		memory_saved = TRUE
	..()
*/
/mob/living/simple_animal/pet/cat/Runtime/make_babies()
	var/mob/baby = ..()
	if(baby)
		children += baby
		return baby
/*
/mob/living/simple_animal/pet/cat/Runtime/death()
	if(!memory_saved)
		Write_Memory(TRUE)
	..()
*/
/mob/living/simple_animal/pet/cat/Runtime/proc/Read_Memory()
	if(fexists("data/npc_saves/Runtime.sav")) //legacy compatability to convert old format to new
		var/savefile/S = new /savefile("data/npc_saves/Runtime.sav")
		S["family"] >> family
		fdel("data/npc_saves/Runtime.sav")
	else
		var/json_file = file("data/npc_saves/Runtime.json")
		if(!fexists(json_file))
			return
		var/list/json = json_decode(file2text(json_file))
		family = json["family"]
	if(isnull(family))
		family = list()
//All you people can't fucking control yourselves and keep letting runtime breed his own children, so it's time to at -LEAST- take the function that saves cats for the next round out the back and shoot it with a 12 gauge
/*
/mob/living/simple_animal/pet/cat/Runtime/proc/Write_Memory(dead)
	var/json_file = file("data/npc_saves/Runtime.json")
	var/list/file_data = list()
	family = list()
	if(!dead)
		for(var/mob/living/simple_animal/pet/cat/kitten/C in children)
			if(istype(C,type) || C.stat || !C.z || !C.butcher_results) //That last one is a work around for hologram cats
				continue
			if(C.type in family)
				family[C.type] += 1
			else
				family[C.type] = 1
	file_data["family"] = family
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/mob/living/simple_animal/pet/cat/Runtime/proc/Deploy_The_Cats()
	cats_deployed = 1
	for(var/cat_type in family)
		if(family[cat_type] > 0)
			for(var/i in 1 to min(family[cat_type],100)) //Limits to about 500 cats, you wouldn't think this would be needed (BUT IT IS)
				new cat_type(loc)
*/

/mob/living/simple_animal/pet/cat/Proc
	name = "Proc"
	gender = MALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE

/mob/living/simple_animal/pet/cat/Life()
	if(!stat && !buckled && !client)
		if(prob(1))
			emote("me", 1, pick("stretches out for a belly rub.", "wags its tail.", "lies down."))
			icon_state = "[icon_living]_rest"
			collar_type = "[initial(collar_type)]_rest"
			resting = 1
			update_canmove()
		else if (prob(1))
			emote("me", 1, pick("sits down.", "crouches on its hind legs.", "looks alert."))
			icon_state = "[icon_living]_sit"
			collar_type = "[initial(collar_type)]_sit"
			resting = 1
			update_canmove()
		else if (prob(1))
			if (resting)
				emote("me", 1, pick("gets up and meows.", "walks around.", "stops resting."))
				icon_state = "[icon_living]"
				collar_type = "[initial(collar_type)]"
				resting = 0
				update_canmove()
			else
				emote("me", 1, pick("grooms its fur.", "twitches its whiskers.", "shakes out its coat."))

	//MICE!
	if((src.loc) && isturf(src.loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/mouse/M in view(1,src))
				if(!M.stat && Adjacent(M))
					emote("me", 1, "splats \the [M]!")
					M.splat()
					movement_target = null
					stop_automated_movement = 0
					break
			for(var/obj/item/toy/cattoy/T in view(1,src))
				if (T.cooldown < (world.time - 400))
					emote("me", 1, "bats \the [T] around with its paw!")
					T.cooldown = world.time

	..()

	make_babies()

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			walk_to(src,0)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/mob/living/simple_animal/mouse/snack in oview(src,3))
					if(isturf(snack.loc) && !snack.stat)
						movement_target = snack
						break
			if(movement_target)
				stop_automated_movement = 1
				walk_to(src,movement_target,0,3)


//Cat made
/mob/living/simple_animal/pet/cat/custom_cat
	name = "White cat" //Incase it somehow gets spawned without an ID
	desc = "A cute white catto!"
	icon_state = "custom_cat"
	icon_living = "custom_cat"
	icon_dead = "custom_cat_dead"
	gender = FEMALE
	gold_core_spawnable = NO_SPAWN
	health = 50 //So people can't instakill it s
	maxHealth = 50
	speak = list("Meowrowr!", "Mew!", "Miauen!")
	speak_emote = list("wigglepurrs", "mewls")
	emote_hear = list("meows.", "mews.")
	emote_see = list("looks at you eagerly for pets!", "wiggles enthusiastically.")
	gold_core_spawnable = NO_SPAWN
	var/pseudo_death = FALSE
	var/mob/living/carbon/human/origin

/mob/living/simple_animal/pet/cat/custom_cat/death()
	if (pseudo_death == TRUE) //secret cat chem
		icon_state = "custom_cat_dead"
		Stun(1000)
		canmove = 0
		friendly = "deads at"
		return
	else
		..()
