/obj/item/vending_refill/wardrobe
	icon_state = "refill_clothes"

/obj/machinery/vending/wardrobe/sec_wardrobe
	name = "\improper SecDrobe"
	desc = "A vending machine for security and security-related clothing!"
	icon_state = "secdrobe"
	product_ads = "Beat perps in style!;It's red so you can't see the blood!;You have the right to be fashionable!;Now you can be the fashion police you always wanted to be!"
	vend_reply = "Thank you for using the SecDrobe!"
	products = list(/obj/item/clothing/suit/hooded/wintercoat/security = 2,
					/obj/item/storage/backpack/security = 2,
					/obj/item/storage/backpack/satchel/sec = 2,
					/obj/item/storage/backpack/duffelbag/sec = 3,
					/obj/item/clothing/under/rank/security = 5,
					/obj/item/clothing/under/rank/security/skirt = 5,
					/obj/item/clothing/shoes/jackboots = 5,
					/obj/item/clothing/head/beret/sec =5,
					/obj/item/clothing/head/soft/sec = 5,
					/obj/item/clothing/mask/bandana/red = 5,
					/obj/item/clothing/under/rank/security/grey = 5,
					/obj/item/clothing/under/pants/khaki = 5)
	premium = list(/obj/item/clothing/under/rank/security/navyblue = 5,
					/obj/item/clothing/suit/security/officer = 5,
					/obj/item/clothing/head/beret/sec/navyofficer = 5)
	refill_canister = /obj/item/vending_refill/wardrobe/sec_wardrobe

/obj/item/vending_refill/wardrobe/sec_wardrobe
	machine_name = "SecDrobe"

/obj/machinery/vending/wardrobe/medi_wardrobe
	name = "\improper MediDrobe"
	desc = "A vending machine rumoured to be capable of dispensing clothing for medical personnel."
	icon_state = "medidrobe"
	product_ads = "Make those blood stains look fashionable!!"
	vend_reply = "Thank you for using the MediDrobe!"
	products = list(/obj/item/clothing/accessory/pocketprotector = 3,
					/obj/item/storage/backpack/duffelbag/med = 3,
					/obj/item/storage/backpack/medic = 3,
					/obj/item/storage/backpack/satchel/med = 3,
					/obj/item/clothing/suit/hooded/wintercoat/medical = 3,
					/obj/item/clothing/under/rank/nursesuit = 3,
					/obj/item/clothing/head/nursehat = 3,
					/obj/item/clothing/under/rank/medical/blue = 2,
					/obj/item/clothing/under/rank/medical/green = 2,
					/obj/item/clothing/under/rank/medical/purple = 2,
					/obj/item/clothing/under/rank/medical = 5,
					/obj/item/clothing/under/rank/medical/skirt = 5,
					/obj/item/clothing/suit/toggle/labcoat = 5,
					/obj/item/clothing/suit/toggle/labcoat/emt = 5,
					/obj/item/clothing/shoes/sneakers/white = 5,
					/obj/item/clothing/head/soft/emt = 5,
					/obj/item/clothing/suit/apron/surgical = 3,
					/obj/item/clothing/mask/surgical = 5)
	refill_canister = /obj/item/vending_refill/wardrobe/medi_wardrobe

/obj/item/vending_refill/wardrobe/medi_wardrobe
	machine_name = "MediDrobe"

/obj/machinery/vending/wardrobe/engi_wardrobe
	name = "EngiDrobe"
	desc = "A vending machine renowned for vending industrial grade clothing."
	icon_state = "engidrobe"
	product_ads = "Guaranteed to protect your feet from industrial accidents!;Afraid of radiation? Then wear yellow!"
	vend_reply = "Thank you for using the EngiDrobe!"
	products = list(/obj/item/clothing/accessory/pocketprotector = 5,
					/obj/item/storage/backpack/duffelbag/engineering = 2,
					/obj/item/storage/backpack/industrial = 3,
					/obj/item/storage/backpack/satchel/eng = 3,
					/obj/item/clothing/suit/hooded/wintercoat/engineering = 3,
					/obj/item/clothing/under/rank/engineer = 5,
					/obj/item/clothing/under/rank/engineer/skirt = 5,
					/obj/item/clothing/suit/hazardvest = 5,
					/obj/item/clothing/shoes/workboots = 5,
					/obj/item/clothing/head/hardhat = 5)
	refill_canister = /obj/item/vending_refill/wardrobe/engi_wardrobe

/obj/item/vending_refill/wardrobe/engi_wardrobe
	machine_name = "EngiDrobe"

/obj/machinery/vending/wardrobe/atmos_wardrobe
	name = "AtmosDrobe"
	desc = "This relatively unknown vending machine delivers clothing for Atmospherics Technicians, an equally unknown job."
	icon_state = "atmosdrobe"
	product_ads = "Get your inflammable clothing right here!!!"
	vend_reply = "Thank you for using the AtmosDrobe!"
	products = list(/obj/item/clothing/accessory/pocketprotector = 3,
					/obj/item/storage/backpack/duffelbag/engineering = 3,
					/obj/item/storage/backpack/satchel/eng = 3,
					/obj/item/storage/backpack/industrial = 3,
					/obj/item/clothing/suit/hooded/wintercoat/engineering/atmos = 5,
					/obj/item/clothing/under/rank/atmospheric_technician = 5,
					/obj/item/clothing/under/rank/atmospheric_technician/skirt = 5,
					/obj/item/clothing/shoes/sneakers/black = 5)
	refill_canister = /obj/item/vending_refill/wardrobe/atmos_wardrobe

/obj/item/vending_refill/wardrobe/atmos_wardrobe
	machine_name = "AtmosDrobe"

/obj/machinery/vending/wardrobe/cargo_wardrobe
	name = "CargoDrobe"
	desc = "A highly advanced vending machine for buying cargo related clothing for free."
	icon_state = "cargodrobe"
	product_ads = "Upgraded Assistant Style! Pick yours today!;These shorts are comfy and easy to wear, get yours now!"
	vend_reply = "Thank you for using the CargoDrobe!"
	products = list(/obj/item/clothing/suit/hooded/wintercoat/cargo = 3,
					/obj/item/clothing/under/rank/cargotech = 5,
					/obj/item/clothing/under/rank/cargotech/skirt = 5,
					/obj/item/clothing/shoes/sneakers/black = 5,
					/obj/item/clothing/gloves/fingerless = 5,
					/obj/item/clothing/head/soft = 5,
					/obj/item/radio/headset/headset_cargo = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/cargo_wardrobe

/obj/item/vending_refill/wardrobe/cargo_wardrobe
	machine_name = "CargoDrobe"

/obj/machinery/vending/wardrobe/robo_wardrobe
	name = "RoboDrobe"
	desc = "A vending machine designed to dispense clothing known only to roboticists."
	icon_state = "robodrobe"
	product_ads = "You turn me TRUE, use defines!;0110001101101100011011110111010001101000011001010111001101101000011001010111001001100101"
	vend_reply = "Thank you for using the RoboDrobe!"
	products = list(/obj/item/clothing/glasses/hud/diagnostic = 3,
					/obj/item/clothing/under/rank/roboticist = 3,
					/obj/item/clothing/under/rank/roboticist/skirt = 3,
					/obj/item/clothing/suit/toggle/labcoat = 3,
					/obj/item/clothing/shoes/sneakers/black = 3,
					/obj/item/clothing/gloves/fingerless = 3,
					/obj/item/clothing/head/soft/black = 3,
					/obj/item/clothing/mask/bandana/skull = 2)
	premium = list(/obj/item/radio/headset/headset_rob = 2) //Cit change
	contraband = list(/obj/item/clothing/suit/hooded/techpriest = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/robo_wardrobe

/obj/item/vending_refill/wardrobe/robo_wardrobe
	machine_name = "RoboDrobe"

/obj/machinery/vending/wardrobe/science_wardrobe
	name = "SciDrobe"
	desc = "A simple vending machine suitable to dispense well tailored science clothing. Endorsed by Cubans."
	icon_state = "scidrobe"
	product_ads = "Longing for the smell of flesh plasma? Buy your science clothing now!;Made with 10% Auxetics, so you don't have to worry losing your arm!"
	vend_reply = "Thank you for using the SciDrobe!"
	products = list(/obj/item/clothing/accessory/pocketprotector = 5,
					/obj/item/storage/backpack/science = 3,
					/obj/item/storage/backpack/satchel/tox = 3,
					/obj/item/clothing/suit/hooded/wintercoat/science = 3,
					/obj/item/clothing/under/rank/scientist = 4,
					/obj/item/clothing/under/rank/scientist/skirt = 4,
					/obj/item/clothing/suit/toggle/labcoat/science = 4,
					/obj/item/clothing/shoes/sneakers/white = 4,
					/obj/item/radio/headset/headset_sci = 4,
					/obj/item/clothing/mask/gas = 5)
	refill_canister = /obj/item/vending_refill/wardrobe/science_wardrobe

/obj/item/vending_refill/wardrobe/science_wardrobe
	machine_name = "SciDrobe"

/obj/machinery/vending/wardrobe/hydro_wardrobe
	name = "Hydrobe"
	desc = "A machine with a catchy name. It dispenses botany related clothing and gear."
	icon_state = "hydrobe"
	product_ads = "Do you love soil? Then buy our clothes!;Get outfits to match your green thumb here!"
	vend_reply = "Thank you for using the Hydrobe!"
	products = list(/obj/item/storage/backpack/botany = 3,
					/obj/item/storage/backpack/satchel/hyd = 3,
					/obj/item/clothing/suit/hooded/wintercoat/hydro = 2,
					/obj/item/clothing/suit/apron = 3,
					/obj/item/clothing/suit/apron/overalls = 5,
					/obj/item/clothing/under/rank/hydroponics = 5,
					/obj/item/clothing/mask/bandana = 4)
	refill_canister = /obj/item/vending_refill/wardrobe/hydro_wardrobe

/obj/item/vending_refill/wardrobe/hydro_wardrobe
	machine_name = "HyDrobe"

/obj/machinery/vending/wardrobe/curator_wardrobe
	name = "CuraDrobe"
	desc = "A lowstock vendor only capable of vending clothing for curators and librarians."
	icon_state = "curadrobe"
	product_ads = "Our clothes are endorsed by treasure hunters everywhere!"
	vend_reply = "Thank you for using the CuraDrobe!"
	products = list(/obj/item/clothing/head/fedora/curator = 2,
					/obj/item/clothing/suit/curator = 2,
					/obj/item/clothing/under/rank/curator/treasure_hunter = 2,
					/obj/item/clothing/shoes/workboots/mining = 2,
					/obj/item/storage/backpack/satchel/explorer = 2,
					/obj/item/storage/bag/books = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/curator_wardrobe

/obj/item/vending_refill/wardrobe/curator_wardrobe
	machine_name = "CuraDrobe"

/obj/machinery/vending/wardrobe/bar_wardrobe
	name = "BarDrobe"
	desc = "A stylish vendor to dispense the most stylish bar clothing!"
	icon_state = "bardrobe"
	product_ads = "Guaranteed to prevent stains from spilled drinks!"
	vend_reply = "Thank you for using the BarDrobe!"
	products = list(/obj/item/clothing/head/that = 3,
					/obj/item/radio/headset/headset_srv = 3,
					/obj/item/clothing/under/sl_suit = 3,
					/obj/item/clothing/under/rank/bartender = 3,
					/obj/item/clothing/under/rank/bartender/purple = 2,
					/obj/item/clothing/accessory/waistcoat = 3,
					/obj/item/clothing/suit/apron/purple_bartender = 2,
					/obj/item/clothing/head/soft/black = 4,
					/obj/item/clothing/shoes/sneakers/black = 4,
					/obj/item/reagent_containers/rag = 4,
					/obj/item/storage/box/beanbag = 1,
					/obj/item/clothing/suit/armor/vest/alt = 1,
					/obj/item/circuitboard/machine/dish_drive = 1,
					/obj/item/clothing/glasses/sunglasses/reagent = 1,
					/obj/item/clothing/neck/petcollar = 3,
					/obj/item/storage/belt/bandolier = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/bar_wardrobe

/obj/item/vending_refill/wardrobe/bar_wardrobe
	machine_name = "BarDrobe"

/obj/machinery/vending/wardrobe/chef_wardrobe
	name = "ChefDrobe"
	desc = "This vending machine might not dispense meat, but it certainly dispenses chef related clothing."
	icon_state = "chefdrobe"
	product_ads = "Our clothes are guaranteed to protect you from food splatters!"
	vend_reply = "Thank you for using the ChefDrobe!"
	products = list(/obj/item/clothing/under/waiter = 3,
					/obj/item/radio/headset/headset_srv = 4,
					/obj/item/clothing/accessory/waistcoat = 3,
					/obj/item/clothing/suit/apron/chef = 3,
					/obj/item/clothing/head/soft/mime = 2,
					/obj/item/storage/box/mousetraps = 2,
					/obj/item/circuitboard/machine/dish_drive = 1,
					/obj/item/clothing/suit/toggle/chef = 2,
					/obj/item/clothing/under/rank/chef = 2,
					/obj/item/clothing/head/chefhat = 2,
					/obj/item/reagent_containers/rag = 3,
					/obj/item/book/granter/crafting_recipe/cooking_sweets_101 = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/chef_wardrobe

/obj/item/vending_refill/wardrobe/chef_wardrobe
	machine_name = "ChefDrobe"

/obj/machinery/vending/wardrobe/jani_wardrobe
	name = "JaniDrobe"
	desc = "A self cleaning vending machine capable of dispensing clothing for janitors."
	icon_state = "janidrobe"
	product_ads = "Come and get your janitorial clothing, now endorsed by lizard janitors everywhere!"
	vend_reply = "Thank you for using the JaniDrobe!"
	products = list(/obj/item/clothing/under/rank/janitor = 2,
					/obj/item/cartridge/janitor = 3,
					/obj/item/clothing/gloves/color/black = 2,
					/obj/item/clothing/head/soft/purple = 2,
					/obj/item/paint/paint_remover = 2,
					/obj/item/melee/flyswatter = 1,
					/obj/item/flashlight = 2,
					/obj/item/caution = 8,
					/obj/item/holosign_creator = 1,
					/obj/item/lightreplacer = 1,
					/obj/item/soap = 1,
					/obj/item/storage/bag/trash = 1,
					/obj/item/clothing/shoes/galoshes = 1,
					/obj/item/watertank/janitor = 1,
					/obj/item/storage/belt/janitor = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/jani_wardrobe

/obj/item/vending_refill/wardrobe/jani_wardrobe
	machine_name = "JaniDrobe"

/obj/machinery/vending/wardrobe/law_wardrobe
	name = "LawDrobe"
	desc = "Objection! This wardrobe dispenses the rule of law... and lawyer clothing."
	icon_state = "lawdrobe"
	product_ads = "OBJECTION! Get the rule of law for yourself!"
	vend_reply = "Thank you for using the LawDrobe!"
	products = list(/obj/item/clothing/under/lawyer/female = 3,
					/obj/item/clothing/under/lawyer/black = 3,
					/obj/item/clothing/under/lawyer/red = 3,
					/obj/item/clothing/under/lawyer/bluesuit = 3,
					/obj/item/clothing/suit/toggle/lawyer = 3,
					/obj/item/clothing/under/lawyer/purpsuit = 3,
					/obj/item/clothing/suit/toggle/lawyer/purple = 3,
					/obj/item/clothing/under/lawyer/blacksuit = 3,
					/obj/item/clothing/suit/toggle/lawyer/black = 3,
					/obj/item/clothing/shoes/laceup = 3,
					/obj/item/clothing/accessory/lawyers_badge = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/law_wardrobe

/obj/item/vending_refill/wardrobe/law_wardrobe
	machine_name = "LawDrobe"

/obj/machinery/vending/wardrobe/chap_wardrobe
	name = "ChapDrobe"
	desc = "This most blessed and holy machine vends clothing only suitable for chaplains to gaze upon."
	icon_state = "chapdrobe"
	product_ads = "Are you being bothered by cultists or pesky revenants? Then come and dress like the holy man!;Clothes for men of the cloth!"
	vend_reply = "Thank you for using the ChapDrobe!"
	products = list(/obj/item/holybeacon = 1,
					/obj/item/storage/backpack/cultpack = 2,
					/obj/item/clothing/accessory/pocketprotector/cosmetology = 2,
					/obj/item/clothing/under/rank/chaplain = 2,
					/obj/item/clothing/shoes/sneakers/black = 2,
					/obj/item/clothing/suit/chaplain/nun = 2,
					/obj/item/clothing/head/nun_hood = 2,
					/obj/item/clothing/suit/chaplain/holidaypriest = 2,
					/obj/item/clothing/suit/chaplain/pharaoh = 2,
					/obj/item/clothing/head/nemes = 1,
					/obj/item/clothing/head/pharaoh = 1,
					/obj/item/storage/fancy/candle_box = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/chap_wardrobe

/obj/item/vending_refill/wardrobe/chap_wardrobe
	machine_name = "ChapDrobe"

/obj/machinery/vending/wardrobe/chem_wardrobe
	name = "ChemDrobe"
	desc = "A vending machine for dispensing chemistry related clothing."
	icon_state = "chemdrobe"
	product_ads = "Our clothes are 0.5% more resistant to acid spills! Get yours now!"
	vend_reply = "Thank you for using the ChemDrobe!"
	products = list(/obj/item/clothing/under/rank/chemist = 3,
					/obj/item/clothing/under/rank/chemist/skirt = 3,
					/obj/item/clothing/shoes/sneakers/white = 3,
					/obj/item/clothing/suit/toggle/labcoat/chemist = 3,
					/obj/item/storage/backpack/chemistry = 3,
					/obj/item/storage/backpack/satchel/chem = 3,
					/obj/item/storage/bag/chemistry = 3,
					/obj/item/fermichem/pHbooklet = 3)//pH indicator)
	refill_canister = /obj/item/vending_refill/wardrobe/chem_wardrobe

/obj/item/vending_refill/wardrobe/chem_wardrobe
	machine_name = "ChemDrobe"

/obj/machinery/vending/wardrobe/gene_wardrobe
	name = "GeneDrobe"
	desc = "A machine for dispensing clothing related to genetics."
	icon_state = "genedrobe"
	product_ads = "Perfect for the mad scientist in you!"
	vend_reply = "Thank you for using the GeneDrobe!"
	products = list(/obj/item/clothing/under/rank/geneticist = 3,
					/obj/item/clothing/under/rank/geneticist/skirt = 3,
					/obj/item/clothing/shoes/sneakers/white = 3,
					/obj/item/clothing/suit/toggle/labcoat/genetics = 3,
					/obj/item/storage/backpack/genetics = 3,
					/obj/item/storage/backpack/satchel/gen = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/gene_wardrobe

/obj/item/vending_refill/wardrobe/gene_wardrobe
	machine_name = "GeneDrobe"

/obj/machinery/vending/wardrobe/viro_wardrobe
	name = "ViroDrobe"
	desc = "An unsterilized machine for dispending virology related clothing."
	icon_state = "virodrobe"
	product_ads = " Viruses getting you down? Then upgrade to sterilized clothing today!"
	vend_reply = "Thank you for using the ViroDrobe"
	products = list(/obj/item/clothing/under/rank/virologist = 3,
					/obj/item/clothing/under/rank/virologist/skirt = 3,
					/obj/item/clothing/shoes/sneakers/white = 3,
					/obj/item/clothing/suit/toggle/labcoat/virologist = 3,
					/obj/item/clothing/mask/surgical = 3,
					/obj/item/storage/backpack/virology = 3,
					/obj/item/storage/backpack/satchel/vir = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/viro_wardrobe

/obj/item/vending_refill/wardrobe/viro_wardrobe
	machine_name = "ViroDrobe"
