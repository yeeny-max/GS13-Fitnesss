/////////////// GS13 - NUTRITIONAL TECHNOLOGY

/datum/techweb_node/nutritech_tools
	id = "nutritech_tools"
	display_name = "Nutri-Tech Tools"
	description = "Ending world hunger was never made easier!"
	prereq_ids = list("biotech", "adv_engi")
	design_ids = list("calorite_collar", "ci-nutrimentturbo", "bluespace_belt", "adipoelectric_transformer", "cookie_synthesizer", "borg_upgrade_cookiesynthesizer", "borg_upgrade_feedingtube")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	boost_item_paths = list(/obj/item/gun/energy/fatoray, /obj/item/gun/energy/fatoray/cannon, /obj/item/trash/fatoray_scrap1, /obj/item/trash/fatoray_scrap2)
	export_price = 5000
	hidden = TRUE

/datum/techweb_node/nutritech_weapons
	id = "nutritech_weapons"
	display_name = "Nutri-Tech Weapons"
	description = "Ever wanted to reach your daily caloric intake in just 5 seconds?"
	prereq_ids = list("biotech", "adv_engi")
	design_ids = list("fatoray_weak", "fatoray_cannon_weak", "alter_ray_metabolism", "alter_ray_reverser", "borg_upgrade_fatoray", "bwomf_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	boost_item_paths = list(/obj/item/gun/energy/fatoray, /obj/item/gun/energy/fatoray/cannon, /obj/item/trash/fatoray_scrap1, /obj/item/trash/fatoray_scrap2)
	export_price = 10000
	hidden = TRUE
