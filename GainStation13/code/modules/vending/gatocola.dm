/obj/machinery/vending/gato
	name = "GATO Vending Machine"
	desc = "A GATO branded cola machine, a cute little cat is plastered onto it."
	icon = 'icons/obj/vending.dmi'
	icon_state = "cola_black"
	product_slogans = "Meow~, time for some cola!"
	vend_reply = "Meow~ Meow~"
	products = list(
	            /obj/item/reagent_containers/food/drinks/beer = 10,
	            /obj/item/reagent_containers/food/drinks/soda_cans/cola = 10,
	            /obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb = 10,
				/obj/item/reagent_containers/food/drinks/soda_cans/starkist = 10,
				/obj/item/reagent_containers/food/drinks/soda_cans/space_up = 10,
				/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game = 10,
				)
	contraband = list(
				/obj/item/organ/ears/cat = 2,
				)
	premium = list(
				/obj/item/reagent_containers/food/drinks/soda_cans/air = 20,
				/obj/item/reagent_containers/food/drinks/soda_cans/fizzwiz = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/soothseltz = 8,
				)

	refill_canister = /obj/item/vending_refill/mealdor

/obj/item/vending_refill/mealdor
	machine_name = "Meal Vendor Refill"
	icon_state = "refill_mealdor"
