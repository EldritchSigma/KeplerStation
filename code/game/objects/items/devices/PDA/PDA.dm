
//The advanced pea-green monochrome lcd of tomorro- yesterday. Fuck that old design with anything that I can throw at it. -aa

GLOBAL_LIST_EMPTY(PDAs)

#define PDA_SCANNER_NONE		0
#define PDA_SCANNER_MEDICAL		1
#define PDA_SCANNER_FORENSICS	2 //unused
#define PDA_SCANNER_REAGENT		3
#define PDA_SCANNER_HALOGEN		4
#define PDA_SCANNER_GAS			5
#define PDA_SPAM_DELAY		    2 MINUTES
#define PDA_STANDARD_OVERLAYS list("pda-r", "blank", "id_overlay", "insert_overlay", "light_overlay", "pai_overlay")

//pda icon overlays list defines
#define PDA_OVERLAY_ALERT		1
#define PDA_OVERLAY_SCREEN		2
#define PDA_OVERLAY_ID			3
#define PDA_OVERLAY_ITEM		4
#define PDA_OVERLAY_LIGHT		5
#define PDA_OVERLAY_PAI			6

/obj/item/pda
	name = "\improper PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	icon = 'icons/obj/pda_alt.dmi'
	icon_state = "pda"
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_ID | ITEM_SLOT_BELT
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF


	//Main variables
	var/owner = null // String name of owner
	var/default_cartridge = 0 // Access level defined by cartridge
	var/obj/item/cartridge/cartridge = null //current cartridge
	var/mode = 0 //Controls what menu the PDA will display. 0 is hub; the rest are either built in or based on cartridge.
	var/list/overlays_icons = list('icons/obj/pda_alt.dmi' = list("pda-r", "screen_default", "id_overlay", "insert_overlay", "light_overlay", "pai_overlay"))
	var/current_overlays = PDA_STANDARD_OVERLAYS
	var/font_index = 0 //This int tells DM which font is currently selected and lets DM know when the last font has been selected so that it can cycle back to the first font when "toggle font" is pressed again.
	var/font_mode = "font-family:monospace;" //The currently selected font.
	var/background_color = "#808000" //The currently selected background color.

	#define FONT_MONO "font-family:monospace;"
	#define FONT_SHARE "font-family:\"Share Tech Mono\", monospace;letter-spacing:0px;"
	#define FONT_ORBITRON "font-family:\"Orbitron\", monospace;letter-spacing:0px; font-size:15px"
	#define FONT_VT "font-family:\"VT323\", monospace;letter-spacing:1px;"
	#define MODE_MONO 0
	#define MODE_SHARE 1
	#define MODE_ORBITRON 2
	#define MODE_VT 3

	//Secondary variables
	var/scanmode = PDA_SCANNER_NONE
	var/fon = FALSE //Is the flashlight function on?
	var/f_lum = 2.3 //Luminosity for the flashlight function
	var/f_pow = 0.6 //Power for the flashlight function
	var/f_col = "#FFCC66" //Color for the flashlight function
	var/silent = FALSE //To beep or not to beep, that is the question
	var/toff = FALSE //If TRUE, messenger disabled
	var/tnote = null //Current Texts
	var/last_text //No text spamming
	var/last_everyone //No text for everyone spamming
	var/last_noise //Also no honk spamming that's bad too
	var/ttone = "beep" //The ringtone!
	var/honkamt = 0 //How many honks left when infected with honk.exe
	var/mimeamt = 0 //How many silence left when infected with mime.exe
	var/note = "Congratulations, your station has chosen the Thinktronic 5230 Personal Data Assistant! To help with navigation, we have provided the following definitions. North: Fore. South: Aft. West: Port. East: Starboard. Quarter is either side of aft." //Current note in the notepad function
	var/notehtml = ""
	var/notescanned = FALSE // True if what is in the notekeeper was from a paper.
	var/detonatable = TRUE // Can the PDA be blown up?
	var/hidden = FALSE // Is the PDA hidden from the PDA list?
	var/emped = FALSE
	var/equipped = FALSE  //used here to determine if this is the first time its been picked up

	var/obj/item/card/id/id = null //Making it possible to slot an ID card into the PDA so it can function as both.
	var/ownjob = null //related to above

	var/obj/item/paicard/pai = null	// A slot for a personal AI device

	var/datum/picture/picture //Scanned photo

	var/list/contained_item = list(/obj/item/pen, /obj/item/toy/crayon, /obj/item/lipstick, /obj/item/flashlight/pen, /obj/item/clothing/mask/cigarette)
	var/obj/item/inserted_item //Used for pen, crayon, and lipstick insertion or removal. Same as above.
	var/list/overlays_offsets // offsets to use for certain overlays
	var/overlays_x_offset = 0
	var/overlays_y_offset = 0

	var/underline_flag = TRUE //flag for underline

/obj/item/pda/suicide_act(mob/living/carbon/user)
	var/deathMessage = msg_input(user)
	if (!deathMessage)
		deathMessage = "i ded"
	user.visible_message("<span class='suicide'>[user] is sending a message to the Grim Reaper! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	tnote += "<i><b>&rarr; To The Grim Reaper:</b></i><br>[deathMessage]<br>"//records a message in their PDA as being sent to the grim reaper
	return BRUTELOSS

/obj/item/pda/examine(mob/user)
	. = ..()
	var/dat = id ? "<span class='notice'>Alt-click to remove the id.</span>" : ""
	
	if(inserted_item && (!isturf(loc)))
		dat += "\n<span class='notice'>Ctrl-click to remove [inserted_item].</span>"
	if(LAZYLEN(GLOB.pda_reskins))
		dat += "\n<span class='notice'>Ctrl-shift-click it to reskin it.</span>"
	to_chat(user, dat)

/obj/item/pda/Initialize()
	. = ..()
	if(fon)
		set_light(f_lum, f_pow, f_col)

	GLOB.PDAs += src
	if(default_cartridge)
		cartridge = new default_cartridge(src)
	if(inserted_item)
		inserted_item = new inserted_item(src)
	else
		inserted_item =	new /obj/item/pen(src)
	update_icon(FALSE, TRUE)

/obj/item/pda/CtrlShiftClick(mob/living/user)
	. = ..()
	if(GLOB.pda_reskins && user.canUseTopic(src, BE_CLOSE, NO_DEXTERY))
		reskin_obj(user)

/obj/item/pda/reskin_obj(mob/M)
	if(!LAZYLEN(GLOB.pda_reskins))
		return
	var/dat = "<b>Reskin options for [name]:</b>"
	for(var/V in GLOB.pda_reskins)
		var/output = icon2html(GLOB.pda_reskins[V], M, icon_state)
		dat += "\n[V]: <span class='reallybig'>[output]</span>"
	to_chat(M, dat)

	var/choice = input(M, "Choose the a reskin for [src]","Reskin Object") as null|anything in GLOB.pda_reskins
	var/new_icon = GLOB.pda_reskins[choice]
	if(QDELETED(src) || isnull(new_icon) || new_icon == icon || M.incapacitated() || !in_range(M,src))
		return
	icon = new_icon
	update_icon(FALSE, TRUE)
	to_chat(M, "[src] is now skinned as '[choice]'.")

/obj/item/pda/proc/set_new_overlays()
	if(!overlays_offsets || !(icon in overlays_offsets))
		overlays_x_offset = 0
		overlays_y_offset = 0
	else
		var/list/new_offsets = overlays_offsets[icon]
		if(new_offsets)
			overlays_x_offset = new_offsets[1]
			overlays_y_offset = new_offsets[2]
	if(!(icon in overlays_icons))
		current_overlays = PDA_STANDARD_OVERLAYS
		return
	current_overlays = overlays_icons[icon]

/obj/item/pda/equipped(mob/user, slot)
	. = ..()
	if(equipped)
		return
	if(user.client)
		var/pref_skin = GLOB.pda_reskins[user.client.prefs.pda_skin]
		if(icon != pref_skin)
			icon = pref_skin
			update_icon(FALSE, TRUE)
		equipped = TRUE

/obj/item/pda/proc/update_label()
	name = "PDA-[owner] ([ownjob])" //Name generalisation

/obj/item/pda/GetAccess()
	if(id)
		return id.GetAccess()
	else
		return ..()

/obj/item/pda/GetID()
	return id

/obj/item/pda/update_icon(alert = FALSE, new_overlays = FALSE)
	if(new_overlays)
		set_new_overlays()
	cut_overlays()
	add_overlay(alert ? current_overlays[PDA_OVERLAY_ALERT] : current_overlays[PDA_OVERLAY_SCREEN])
	var/mutable_appearance/overlay = new()
	overlay.pixel_x = overlays_x_offset
	if(id)
		overlay.icon_state = current_overlays[PDA_OVERLAY_ID]
		add_overlay(new /mutable_appearance(overlay))
	if(inserted_item)
		overlay.icon_state = current_overlays[PDA_OVERLAY_ITEM]
		add_overlay(new /mutable_appearance(overlay))
	if(fon)
		overlay.icon_state = current_overlays[PDA_OVERLAY_LIGHT]
		add_overlay(new /mutable_appearance(overlay))
	if(pai)
		overlay.icon_state = "[current_overlays[PDA_OVERLAY_PAI]][pai.pai ? "" : "_off"]"
		add_overlay(new /mutable_appearance(overlay))

/obj/item/pda/MouseDrop(mob/over, src_location, over_location)
	var/mob/M = usr
	if((M == over) && usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return attack_self(M)
	return ..()

/obj/item/pda/attack_self_tk(mob/user)
	to_chat(user, "<span class='warning'>The PDA's capacitive touch screen doesn't seem to respond!</span>")
	return

/obj/item/pda/interact(mob/user)
	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	..()

	var/datum/asset/spritesheet/assets = get_asset_datum(/datum/asset/spritesheet/simple/pda)
	assets.send(user)

	user.set_machine(src)

	var/dat = ""
	dat += assets.css_tag()

	dat += "[PDAIMG(refresh)]<a href='byond://?src=[REF(src)];choice=Refresh'>Refresh</a>"

	if ((!isnull(cartridge)) && (mode == 0))
		dat += " | [PDAIMG(eject)]<a href='byond://?src=[REF(src)];choice=Eject'>Eject [cartridge]</a>"
	if (mode)
		dat += " | [PDAIMG(menu)]<a href='byond://?src=[REF(src)];choice=Return'>Return</a>"

	dat += "<br>"

	if (!owner)
		dat += "Warning: No owner information entered.  Please swipe card.<br><br>"
		dat += "[PDAIMG(refresh)]<a href='byond://?src=[REF(src)];choice=Refresh'>Retry</a>"
	else
		switch (mode)
			if (0)
				dat += "<h2>PERSONAL DATA ASSISTANT v.1.2</h2>"
				dat += "Owner: [owner], [ownjob]<br>"
				if(id)
					dat += text("ID: <a href='?src=[REF(src)];choice=Authenticate'>[id ? "[id.registered_name], [id.assignment]" : "----------"]</a>")
					dat += text(" <a href='?src=[REF(src)];choice=UpdateInfo'>Update PDA Info</A><br>")

				dat += "[STATION_TIME_TIMESTAMP("hh:mm:ss")]<br>" //:[world.time / 100 % 6][world.time / 100 % 10]"
				dat += "[time2text(world.realtime, "MMM DD")] [GLOB.year_integer+540]"

				dat += "<br><br>"

				dat += "<h4>General Functions</h4>"
				dat += "<ul>"
				dat += "<li>[PDAIMG(notes)]<a href='byond://?src=[REF(src)];choice=1'>Notekeeper</a></li>"
				dat += "<li>[PDAIMG(mail)]<a href='byond://?src=[REF(src)];choice=2'>Messenger</a></li>"
				dat += "<li>[PDAIMG(notes)]<a href='byond://?src=[REF(src)];choice=41'>View Crew Manifest</a></li>"
				dat += "</ul>"

				if (cartridge && cartridge.has_menus)
					dat += "<h4>Cartridge Functions</h4><ul>"
					if (cartridge.access & CART_JANITOR)
						dat += "<li>[PDAIMG(bucket)]<a href='byond://?src=[REF(src)];choice=49'>Custodial Locator</a></li>"
					if (cartridge.access & CART_CLOWN)
						dat += "<li>[PDAIMG(honk)]<a href='byond://?src=[REF(src)];choice=Honk'>Honk Synthesizer</a></li>"
						dat += "<li>[PDAIMG(honk)]<a href='byond://?src=[REF(src)];choice=Trombone'>Sad Trombone</a></li>"						
					if(cartridge.access & CART_STATUS_DISPLAY)
						dat += "<li>[PDAIMG(status)]<a href='byond://?src=[REF(src)];choice=42'>Set Status Display</a></li>"
					if (cartridge.access & CART_ENGINE)
						dat += "<li>[PDAIMG(power)]<a href='byond://?src=[REF(src)];choice=43'>Power Monitor</a></li>"
					if (cartridge.access & CART_MEDICAL)
						dat += "<li>[PDAIMG(medical)]<a href='byond://?src=[REF(src)];choice=44'>Medical Records</a></li>"
						dat += "<li>[PDAIMG(scanner)]<a href='byond://?src=[REF(src)];choice=Medical Scan'>[scanmode == 1 ? "Disable" : "Enable"] Medical Scanner</a></li>"
					if (cartridge.access & CART_SECURITY)
						dat += "<li>[PDAIMG(cuffs)]<a href='byond://?src=[REF(src)];choice=45'>Security Records</A></li>"
					if(cartridge.access & CART_QUARTERMASTER)
						dat += "<li>[PDAIMG(crate)]<a href='byond://?src=[REF(src)];choice=47'>Supply Records</A></li>"
						dat += "<li>[PDAIMG(crate)]<a href='byond://?src=[REF(src)];choice=48'>Ore Silo Logs</a></li>"
					dat += "</ul>"

				dat += "<h4>Utilities</h4>"
				dat += "<ul>"
				if (cartridge)
					if(cartridge.bot_access_flags)
						dat += "<li>[PDAIMG(medbot)]<a href='byond://?src=[REF(src)];choice=54'>Bots Access</a></li>"
					if (istype(cartridge.radio))
						dat += "<li>[PDAIMG(signaler)]<a href='byond://?src=[REF(src)];choice=40'>Signaler System</a></li>"
					if (cartridge.access & CART_REAGENT_SCANNER)
						dat += "<li>[PDAIMG(reagent)]<a href='byond://?src=[REF(src)];choice=Reagent Scan'>[scanmode == 3 ? "Disable" : "Enable"] Reagent Scanner</a></li>"
					if (cartridge.access & CART_ENGINE)
						dat += "<li>[PDAIMG(notes)]<a href='byond://?src=[REF(src)];choice=Halogen Counter'>[scanmode == 4 ? "Disable" : "Enable"] Halogen Counter</a></li>"
					if (cartridge.access & CART_ATMOS)
						dat += "<li>[PDAIMG(notes)]<a href='byond://?src=[REF(src)];choice=Gas Scan'>[scanmode == 5 ? "Disable" : "Enable"] Gas Scanner</a></li>"
					if (cartridge.access & CART_REMOTE_DOOR)
						dat += "<li>[PDAIMG(rdoor)]<a href='byond://?src=[REF(src)];choice=Toggle Door'>Toggle Remote Door</a></li>"
					if (cartridge.access & CART_DRONEPHONE)
						dat += "<li>[PDAIMG(dronephone)]<a href='byond://?src=[REF(src)];choice=Drone Phone'>Drone Phone</a></li>"
				dat += "<li>[PDAIMG(atmos)]<a href='byond://?src=[REF(src)];choice=3'>Atmospheric Scan</a></li>"
				dat += "<li>[PDAIMG(flashlight)]<a href='byond://?src=[REF(src)];choice=Light'>[fon ? "Disable" : "Enable"] Flashlight</a></li>"
				if (pai)
					if(pai.loc != src)
						pai = null
						update_icon()
					else
						dat += "<li>[PDAIMG(status)]<a href='byond://?src=[REF(src)];choice=pai;option=1'>pAI Device Configuration</a></li>"
						dat += "<li>[PDAIMG(status)]<a href='byond://?src=[REF(src)];choice=pai;option=2'>Eject pAI Device</a></li>"
				dat += "</ul>"

			if (1)
				dat += "<h4>[PDAIMG(notes)] Notekeeper V2.2</h4>"
				dat += "<a href='byond://?src=[REF(src)];choice=Edit'>Edit</a><br>"
				if(notescanned)
					dat += "(This is a scanned image, editing it may cause some text formatting to change.)<br>"
				dat += "<HR><font face=\"[PEN_FONT]\">[(!notehtml ? note : notehtml)]</font>"

			if (2)
				dat += "<h4>[PDAIMG(mail)] SpaceMessenger V3.9.6</h4>"
				dat += "[PDAIMG(bell)]<a href='byond://?src=[REF(src)];choice=Toggle Ringer'>Ringer: [silent == 1 ? "Off" : "On"]</a> "
				dat += "[PDAIMG(mail)]<a href='byond://?src=[REF(src)];choice=Toggle Messenger'>Send / Receive: [toff == 1 ? "Off" : "On"]</a> "
				dat += "[PDAIMG(bell)]<a href='byond://?src=[REF(src)];choice=Ringtone'>Set Ringtone</a> "
				dat += "[PDAIMG(mail)]<a href='byond://?src=[REF(src)];choice=21'>Messages</a><br>"

				if(cartridge)
					dat += cartridge.message_header()

				dat += "<h4>[PDAIMG(menu)] Detected PDAs</h4>"

				dat += "<ul>"
				var/count = 0

				if (!toff)
					for (var/obj/item/pda/P in sortNames(get_viewable_pdas()))
						if (P == src)
							continue
						dat += "<li><a href='byond://?src=[REF(src)];choice=Message;target=[REF(P)]'>[P]</a>"
						if(cartridge)
							dat += cartridge.message_special(P)
						dat += "</li>"
						count++
				dat += "</ul>"
				if (count == 0)
					dat += "None detected.<br>"
				else if(cartridge && cartridge.spam_enabled)
					dat += "<a href='byond://?src=[REF(src)];choice=MessageAll'>Send To All</a>"

			if(41) //crew manifest
				dat += "<h4>Crew Manifest</h4>"
				dat += "<center>"
				dat += GLOB.data_core.get_manifest()
				dat += "</center>"

			if(21)
				dat += "<h4>[PDAIMG(mail)] SpaceMessenger V3.9.6</h4>"
				dat += "[PDAIMG(blank)]<a href='byond://?src=[REF(src)];choice=Clear'>Clear Messages</a>"

				dat += "<h4>[PDAIMG(mail)] Messages</h4>"

				dat += tnote
				dat += "<br>"

			if (3)
				dat += "<h4>[PDAIMG(atmos)] Atmospheric Readings</h4>"

				var/turf/T = user.loc
				if (isnull(T))
					dat += "Unable to obtain a reading.<br>"
				else
					var/datum/gas_mixture/environment = T.return_air()
					var/list/env_gases = environment.gases

					var/pressure = environment.return_pressure()
					var/total_moles = environment.total_moles()

					dat += "Air Pressure: [round(pressure,0.1)] kPa<br>"

					if (total_moles)
						for(var/id in env_gases)
							var/gas_level = env_gases[id]/total_moles
							if(gas_level > 0)
								dat += "[GLOB.meta_gas_names[id]]: [round(gas_level*100, 0.01)]%<br>"

					dat += "Temperature: [round(environment.temperature-T0C)]&deg;C<br>"
				dat += "<br>"
			else//Else it links to the cart menu proc. Although, it really uses menu hub 4--menu 4 doesn't really exist as it simply redirects to hub.
				dat += cartridge.generate_menu()

	dat += "</body></html>"

	if (underline_flag)
		dat = replacetext(dat, "text-decoration:none", "text-decoration:underline")
	if (!underline_flag)
		dat = replacetext(dat, "text-decoration:underline", "text-decoration:none")

	var/datum/browser/popup = new(user, "pda_ui", "<div align='center'>Personal Data Assistant</div>", 500, 600)
	popup.set_content(dat)
	popup.open(0)

/obj/item/pda/Topic(href, href_list)
	..()
	var/mob/living/U = usr
	//Looking for master was kind of pointless since PDAs don't appear to have one.

	if(usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK) && !href_list["close"])
		add_fingerprint(U)
		U.set_machine(src)

		switch(href_list["choice"])

//BASIC FUNCTIONS===================================

			if("Refresh")//Refresh, goes to the end of the proc.
				if (!silent)
					playsound(src, 'sound/machines/terminal_select.ogg', 15, 1)

			if("Return")//Return
				if(mode<=9)
					mode = 0
				else
					mode = round(mode/10)
					if(mode==4 || mode == 5)//Fix for cartridges. Redirects to hub.
						mode = 0
				if (!silent)
					playsound(src, 'sound/machines/terminal_select.ogg', 15, 1)

			if ("Authenticate")//Checks for ID
				id_check(U)

			if("UpdateInfo")
				ownjob = id.assignment
				if(istype(id, /obj/item/card/id/syndicate))
					owner = id.registered_name
				update_label()
				if (!silent)
					playsound(src, 'sound/machines/terminal_processing.ogg', 15, 1)
				addtimer(CALLBACK(GLOBAL_PROC, .proc/playsound, src, 'sound/machines/terminal_success.ogg', 15, 1), 13)

			if("Eject")//Ejects the cart, only done from hub.
				if (!isnull(cartridge))
					U.put_in_hands(cartridge)
					to_chat(U, "<span class='notice'>You remove [cartridge] from [src].</span>")
					scanmode = PDA_SCANNER_NONE
					cartridge.host_pda = null
					cartridge = null
					update_icon()
				if (!silent)
					playsound(src, 'sound/machines/terminal_eject_disc.ogg', 50, 1)

//MENU FUNCTIONS===================================

			if("0")//Hub
				mode = 0
				if (!silent)
					playsound(src, 'sound/machines/terminal_select.ogg', 15, 1)
			if("1")//Notes
				mode = 1
				if (!silent)
					playsound(src, 'sound/machines/terminal_select.ogg', 15, 1)
			if("2")//Messenger
				mode = 2
				if (!silent)
					playsound(src, 'sound/machines/terminal_select.ogg', 15, 1)
			if("21")//Read messeges
				mode = 21
				if (!silent)
					playsound(src, 'sound/machines/terminal_select.ogg', 15, 1)
			if("3")//Atmos scan
				mode = 3
				if (!silent)
					playsound(src, 'sound/machines/terminal_select.ogg', 15, 1)
			if("4")//Redirects to hub
				mode = 0
				if (!silent)
					playsound(src, 'sound/machines/terminal_select.ogg', 15, 1)


//MAIN FUNCTIONS===================================

			if("Light")
				toggle_light()
				if (!silent)
					playsound(src, 'sound/machines/terminal_select.ogg', 15, 1)

			if("Medical Scan")
				if(scanmode == PDA_SCANNER_MEDICAL)
					scanmode = PDA_SCANNER_NONE
				else if((!isnull(cartridge)) && (cartridge.access & CART_MEDICAL))
					scanmode = PDA_SCANNER_MEDICAL
				if (!silent)
					playsound(src, 'sound/machines/terminal_select.ogg', 15, 1)

			if("Reagent Scan")
				if(scanmode == PDA_SCANNER_REAGENT)
					scanmode = PDA_SCANNER_NONE
				else if((!isnull(cartridge)) && (cartridge.access & CART_REAGENT_SCANNER))
					scanmode = PDA_SCANNER_REAGENT
				if (!silent)
					playsound(src, 'sound/machines/terminal_select.ogg', 15, 1)

			if("Halogen Counter")
				if(scanmode == PDA_SCANNER_HALOGEN)
					scanmode = PDA_SCANNER_NONE
				else if((!isnull(cartridge)) && (cartridge.access & CART_ENGINE))
					scanmode = PDA_SCANNER_HALOGEN
				if (!silent)
					playsound(src, 'sound/machines/terminal_select.ogg', 15, 1)

			if("Honk")
				if ( !(last_noise && world.time < last_noise + 20) )
					playsound(src, 'sound/items/bikehorn.ogg', 50, 1)
					last_noise = world.time

			if("Trombone")
				if ( !(last_noise && world.time < last_noise + 20) )
					playsound(src, 'sound/misc/sadtrombone.ogg', 50, 1)
					last_noise = world.time

			if("Gas Scan")
				if(scanmode == PDA_SCANNER_GAS)
					scanmode = PDA_SCANNER_NONE
				else if((!isnull(cartridge)) && (cartridge.access & CART_ATMOS))
					scanmode = PDA_SCANNER_GAS
				if (!silent)
					playsound(src, 'sound/machines/terminal_select.ogg', 15, 1)

			if("Drone Phone")
				var/alert_s = input(U,"Alert severity level","Ping Drones",null) as null|anything in list("Low","Medium","High","Critical")
				var/area/A = get_area(U)
				if(A && alert_s && !QDELETED(U))
					var/msg = "<span class='boldnotice'>NON-DRONE PING: [U.name]: [alert_s] priority alert in [A.name]!</span>"
					_alert_drones(msg, TRUE, U)
					to_chat(U, msg)
					if (!silent)
						playsound(src, 'sound/machines/terminal_success.ogg', 15, 1)


//NOTEKEEPER FUNCTIONS===================================

			if ("Edit")
				var/n = stripped_multiline_input(U, "Please enter message", name, note)
				if (in_range(src, U) && loc == U)
					if (mode == 1 && n)
						note = n
						notehtml = parsemarkdown(n, U)
						notescanned = FALSE
				else
					U << browse(null, "window=pda")
					return

//MESSENGER FUNCTIONS===================================

			if("Toggle Messenger")
				toff = !toff
			if("Toggle Ringer")//If viewing texts then erase them, if not then toggle silent status
				silent = !silent
			if("Clear")//Clears messages
				tnote = null
			if("Ringtone")
				var/t = input(U, "Please enter new ringtone", name, ttone) as text
				if(in_range(src, U) && loc == U && t)
					if(SEND_SIGNAL(src, COMSIG_PDA_CHANGE_RINGTONE, U, t) & COMPONENT_STOP_RINGTONE_CHANGE)
						U << browse(null, "window=pda")
						return
					else
						ttone = copytext(sanitize(t), 1, 20)
				else
					U << browse(null, "window=pda")
					return
			if("Message")
				create_message(U, locate(href_list["target"]))

			if("MessageAll")
				send_to_all(U)

			if("cart")
				if(cartridge)
					cartridge.special(U, href_list)
				else
					U << browse(null, "window=pda")
					return

//SYNDICATE FUNCTIONS===================================

			if("Toggle Door")
				if(cartridge && cartridge.access & CART_REMOTE_DOOR)
					for(var/obj/machinery/door/poddoor/M in GLOB.machines)
						if(M.id == cartridge.remote_door_id)
							if(M.density)
								M.open()
							else
								M.close()

//pAI FUNCTIONS===================================
			if("pai")
				switch(href_list["option"])
					if("1")		// Configure pAI device
						pai.attack_self(U)
					if("2")		// Eject pAI device
						var/turf/T = get_turf(loc)
						if(T)
							pai.forceMove(T)

//LINK FUNCTIONS===================================

			else//Cartridge menu linking
				mode = max(text2num(href_list["choice"]), 0)

	else//If not in range, can't interact or not using the pda.
		U.unset_machine()
		U << browse(null, "window=pda")
		return

//EXTRA FUNCTIONS===================================

	if (mode == 2 || mode == 21)//To clear message overlays.
		update_icon()

	if ((honkamt > 0) && (prob(60)))//For clown virus.
		honkamt--
		playsound(src, 'sound/items/bikehorn.ogg', 30, 1)

	if(U.machine == src && href_list["skiprefresh"]!="1")//Final safety.
		attack_self(U)//It auto-closes the menu prior if the user is not in range and so on.
	else
		U.unset_machine()
		U << browse(null, "window=pda")
	return

/obj/item/pda/proc/remove_id()

	if(issilicon(usr) || !usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return

	if (id)
		usr.put_in_hands(id)
		to_chat(usr, "<span class='notice'>You remove the ID from the [name].</span>")
		id = null
		update_icon()

/obj/item/pda/proc/msg_input(mob/living/U = usr)
	var/t = stripped_input(U, "Please enter message", name)
	if (!t || toff)
		return
	if(!U.canUseTopic(src, BE_CLOSE))
		return
	if(emped)
		t = Gibberish(t, 100)
	return t

/obj/item/pda/proc/send_message(mob/living/user, list/obj/item/pda/targets, everyone)
	var/message = msg_input(user)
	if(!message || !targets.len)
		return
	if((last_text && world.time < last_text + 10) || (everyone && last_everyone && world.time < last_everyone + PDA_SPAM_DELAY))
		return
	if(prob(1))
		message += "\nSent from my PDA"
	// Send the signal
	var/list/string_targets = list()
	for (var/obj/item/pda/P in targets)
		if (P.owner && P.ownjob)  // != src is checked by the UI
			string_targets += "[P.owner] ([P.ownjob])"
	for (var/obj/machinery/computer/message_monitor/M in targets)
		// In case of "Reply" to a message from a console, this will make the
		// message be logged successfully. If the console is impersonating
		// someone by matching their name and job, the reply will reach the
		// impersonated PDA.
		string_targets += "[M.customsender] ([M.customjob])"
	if (!string_targets.len)
		return

	var/datum/signal/subspace/pda/signal = new(src, list(
		"name" = "[owner]",
		"job" = "[ownjob]",
		"message" = message,
		"targets" = string_targets
	))
	if (picture)
		signal.data["photo"] = picture
	signal.send_to_receivers()

	// If it didn't reach, note that fact
	if (!signal.data["done"])
		to_chat(user, "<span class='notice'>ERROR: Server isn't responding.</span>")
		return
		if (!silent)
			playsound(src, 'sound/machines/terminal_error.ogg', 15, 1)

	var/target_text = signal.format_target()
	// Log it in our logs
	tnote += "<i><b>&rarr; To [target_text]:</b></i><br>[signal.format_message()]<br>"
	// Show it to ghosts
	var/ghost_message = "<span class='name'>[owner] </span><span class='game say'>PDA Message</span> --> <span class='name'>[target_text]</span>: <span class='message'>[signal.format_message()]</span>"
	for(var/mob/M in GLOB.player_list)
		if(isobserver(M) && M.client && (M.client.prefs.chat_toggles & CHAT_GHOSTPDA))
			to_chat(M, "[FOLLOW_LINK(M, user)] [ghost_message]")
	// Log in the talk log
	user.log_talk(message, LOG_PDA, tag="PDA: [initial(name)] to [target_text]")
	to_chat(user, "<span class='info'>Message sent to [target_text]: \"[message]\"</span>")
	if (!silent)
		playsound(src, 'sound/machines/terminal_success.ogg', 15, 1)
	// Reset the photo
	picture = null
	last_text = world.time
	if (everyone)
		last_everyone = world.time

/obj/item/pda/proc/receive_message(datum/signal/subspace/pda/signal)
	tnote += "<i><b>&larr; From <a href='byond://?src=[REF(src)];choice=Message;target=[REF(signal.source)]'>[signal.data["name"]]</a> ([signal.data["job"]]):</b></i><br>[signal.format_message()]<br>"

	if (!silent)
		playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
		audible_message("[icon2html(src, hearers(src))] *[ttone]*", null, 3)
	//Search for holder of the PDA.
	var/mob/living/L = null
	if(loc && isliving(loc))
		L = loc
	//Maybe they are a pAI!
	else
		L = get(src, /mob/living/silicon)

	if(L && L.stat != UNCONSCIOUS)
		var/hrefstart
		var/hrefend
		if (isAI(L))
			hrefstart = "<a href='?src=[REF(L)];track=[html_encode(signal.data["name"])]'>"
			hrefend = "</a>"

		to_chat(L, "[icon2html(src)] <b>Message from [hrefstart][signal.data["name"]] ([signal.data["job"]])[hrefend], </b>[signal.format_message()] (<a href='byond://?src=[REF(src)];choice=Message;skiprefresh=1;target=[REF(signal.source)]'>Reply</a>)")

	update_icon(TRUE)

/obj/item/pda/proc/send_to_all(mob/living/U)
	if (last_everyone && world.time < last_everyone + PDA_SPAM_DELAY)
		to_chat(U,"<span class='warning'>Send To All function is still on cooldown.")
		return
	send_message(U,get_viewable_pdas(), TRUE)

/obj/item/pda/proc/create_message(mob/living/U, obj/item/pda/P)
	send_message(U,list(P))

/obj/item/pda/AltClick()
	..()

	if(id)
		remove_id()
		playsound(src, 'sound/machines/terminal_eject_disc.ogg', 50, 1)
	else
		remove_pen()
		playsound(src, 'sound/machines/button4.ogg', 50, 1)

/obj/item/pda/CtrlClick()
	..()

	if(isturf(loc)) //stops the user from dragging the PDA by ctrl-clicking it.
		return

	remove_pen()

/obj/item/pda/verb/verb_toggle_light()
	set category = "Object"
	set name = "Toggle Flashlight"

	toggle_light()

/obj/item/pda/verb/verb_remove_id()
	set category = "Object"
	set name = "Eject ID"
	set src in usr

	if(id)
		remove_id()
	else
		to_chat(usr, "<span class='warning'>This PDA does not have an ID in it!</span>")

/obj/item/pda/verb/verb_remove_pen()
	set category = "Object"
	set name = "Remove Pen"
	set src in usr

	remove_pen()

/obj/item/pda/proc/toggle_light()
	if(issilicon(usr) || !usr.canUseTopic(src, BE_CLOSE))
		return
	if(fon)
		fon = FALSE
		set_light(0)
	else if(f_lum)
		fon = TRUE
		set_light(f_lum, f_pow, f_col)
	update_icon()

/obj/item/pda/proc/remove_pen()

	if(issilicon(usr) || !usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return

	if(inserted_item)
		usr.put_in_hands(inserted_item)
		to_chat(usr, "<span class='notice'>You remove [inserted_item] from [src].</span>")
		inserted_item = null
		update_icon()
	else
		to_chat(usr, "<span class='warning'>This PDA does not have a pen in it!</span>")

//trying to insert or remove an id
/obj/item/pda/proc/id_check(mob/user, obj/item/card/id/I)
	if(!I)
		if(id && (src in user.contents))
			remove_id()
			return TRUE
		else
			var/obj/item/card/id/C = user.get_active_held_item()
			if(istype(C))
				I = C

	if(I && I.registered_name)
		if(!user.transferItemToLoc(I, src))
			return FALSE
		var/obj/old_id = id
		id = I
		if(old_id)
			user.put_in_hands(old_id)
		update_icon()
		playsound(src, 'sound/machines/button.ogg', 50, 1)
	return TRUE

// access to status display signals
/obj/item/pda/attackby(obj/item/C, mob/user, params)
	if(istype(C, /obj/item/cartridge) && !cartridge)
		if(!user.transferItemToLoc(C, src))
			return
		cartridge = C
		cartridge.host_pda = src
		to_chat(user, "<span class='notice'>You insert [cartridge] into [src].</span>")
		update_icon()
		playsound(src, 'sound/machines/button.ogg', 50, 1)

	else if(istype(C, /obj/item/card/id))
		var/obj/item/card/id/idcard = C
		if(!idcard.registered_name)
			to_chat(user, "<span class='warning'>\The [src] rejects the ID!</span>")
			return
			if (!silent)
				playsound(src, 'sound/machines/terminal_error.ogg', 15, 1)

		if(!owner)
			owner = idcard.registered_name
			ownjob = idcard.assignment
			update_label()
			to_chat(user, "<span class='notice'>Card scanned.</span>")
			if (!silent)
				playsound(src, 'sound/machines/terminal_success.ogg', 15, 1)
		else
			//Basic safety check. If either both objects are held by user or PDA is on ground and card is in hand.
			if(((src in user.contents) || (isturf(loc) && in_range(src, user))) && (C in user.contents))
				if(!id_check(user, idcard))
					return
				to_chat(user, "<span class='notice'>You put the ID into \the [src]'s slot.</span>")
				updateSelfDialog()//Update self dialog on success.
			return	//Return in case of failed check or when successful.
		updateSelfDialog()//For the non-input related code.
	else if(istype(C, /obj/item/paicard) && !pai)
		if(!user.transferItemToLoc(C, src))
			return
		pai = C
		to_chat(user, "<span class='notice'>You slot \the [C] into [src].</span>")
		update_icon()
		updateUsrDialog()
	else if(is_type_in_list(C, contained_item)) //Checks if there is a pen
		if(inserted_item)
			to_chat(user, "<span class='warning'>There is already \a [inserted_item] in \the [src]!</span>")
		else
			if(!user.transferItemToLoc(C, src))
				return
			to_chat(user, "<span class='notice'>You slide \the [C] into \the [src].</span>")
			inserted_item = C
			update_icon()
			playsound(src, 'sound/machines/button.ogg', 50, 1)

	else if(istype(C, /obj/item/photo))
		var/obj/item/photo/P = C
		picture = P.picture
		to_chat(user, "<span class='notice'>You scan \the [C].</span>")
	else
		return ..()

/obj/item/pda/attack(mob/living/carbon/C, mob/living/user)
	if(istype(C))
		switch(scanmode)

			if(PDA_SCANNER_MEDICAL)
				C.visible_message("<span class='alert'>[user] has analyzed [C]'s vitals!</span>")
				healthscan(user, C, 1)
				add_fingerprint(user)

			if(PDA_SCANNER_HALOGEN)
				C.visible_message("<span class='warning'>[user] has analyzed [C]'s radiation levels!</span>")

				user.show_message("<span class='notice'>Analyzing Results for [C]:</span>")
				if(C.radiation)
					user.show_message("\green Radiation Level: \black [C.radiation]")
				else
					user.show_message("<span class='notice'>No radiation detected.</span>")

/obj/item/pda/afterattack(atom/A as mob|obj|turf|area, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	switch(scanmode)
		if(PDA_SCANNER_REAGENT)
			if(!isnull(A.reagents))
				if(A.reagents.reagent_list.len > 0)
					var/reagents_length = A.reagents.reagent_list.len
					to_chat(user, "<span class='notice'>[reagents_length] chemical agent[reagents_length > 1 ? "s" : ""] found.</span>")
					for (var/re in A.reagents.reagent_list)
						to_chat(user, "<span class='notice'>\t [re]</span>")
				else
					to_chat(user, "<span class='notice'>No active chemical agents found in [A].</span>")
			else
				to_chat(user, "<span class='notice'>No significant chemical agents found in [A].</span>")

		if(PDA_SCANNER_GAS)
			A.analyzer_act(user, src)

	if (!scanmode && istype(A, /obj/item/paper) && owner)
		var/obj/item/paper/PP = A
		if (!PP.info)
			to_chat(user, "<span class='warning'>Unable to scan! Paper is blank.</span>")
			return
		notehtml = PP.info
		note = replacetext(notehtml, "<BR>", "\[br\]")
		note = replacetext(note, "<li>", "\[*\]")
		note = replacetext(note, "<ul>", "\[list\]")
		note = replacetext(note, "</ul>", "\[/list\]")
		note = html_encode(note)
		notescanned = TRUE
		to_chat(user, "<span class='notice'>Paper scanned. Saved to PDA's notekeeper.</span>" )


/obj/item/pda/proc/explode() //This needs tuning.
	if(!detonatable)
		return
	var/turf/T = get_turf(src)

	if (ismob(loc))
		var/mob/M = loc
		M.show_message("<span class='userdanger'>Your [src] explodes!</span>", 1)
	else
		visible_message("<span class='danger'>[src] explodes!</span>", "<span class='warning'>You hear a loud *pop*!</span>")

	if(T)
		T.hotspot_expose(700,125)
		if(istype(cartridge, /obj/item/cartridge/virus/syndicate))
			explosion(T, -1, 1, 3, 4)
		else
			explosion(T, -1, -1, 2, 3)
	qdel(src)
	return

/obj/item/pda/Destroy()
	GLOB.PDAs -= src
	if(istype(id))
		QDEL_NULL(id)
	if(istype(cartridge))
		QDEL_NULL(cartridge)
	if(istype(pai))
		QDEL_NULL(pai)
	if(istype(inserted_item))
		QDEL_NULL(inserted_item)
	return ..()

//AI verb and proc for sending PDA messages.

/mob/living/silicon/ai/proc/cmd_send_pdamesg(mob/user)
	var/list/plist = list()
	var/list/namecounts = list()

	if(aiPDA.toff)
		to_chat(user, "Turn on your receiver in order to send messages.")
		return

	for (var/obj/item/pda/P in get_viewable_pdas())
		if (P == src)
			continue
		else if (P == aiPDA)
			continue

		plist[avoid_assoc_duplicate_keys(P.owner, namecounts)] = P

	var/c = input(user, "Please select a PDA") as null|anything in sortList(plist)

	if (!c)
		return

	var/selected = plist[c]

	if(aicamera.stored.len)
		var/add_photo = input(user,"Do you want to attach a photo?","Photo","No") as null|anything in list("Yes","No")
		if(add_photo=="Yes")
			var/datum/picture/Pic = aicamera.selectpicture(user)
			aiPDA.picture = Pic

	if(incapacitated())
		return

	aiPDA.create_message(src, selected)


/mob/living/silicon/ai/verb/cmd_toggle_pda_receiver()
	set category = "AI Commands"
	set name = "PDA - Toggle Sender/Receiver"
	if(usr.stat == DEAD)
		return //won't work if dead
	if(!isnull(aiPDA))
		aiPDA.toff = !aiPDA.toff
		to_chat(usr, "<span class='notice'>PDA sender/receiver toggled [(aiPDA.toff ? "Off" : "On")]!</span>")
	else
		to_chat(usr, "You do not have a PDA. You should make an issue report about this.")

/mob/living/silicon/ai/verb/cmd_toggle_pda_silent()
	set category = "AI Commands"
	set name = "PDA - Toggle Ringer"
	if(usr.stat == DEAD)
		return //won't work if dead
	if(!isnull(aiPDA))
		//0
		aiPDA.silent = !aiPDA.silent
		to_chat(usr, "<span class='notice'>PDA ringer toggled [(aiPDA.silent ? "Off" : "On")]!</span>")
	else
		to_chat(usr, "You do not have a PDA. You should make an issue report about this.")

/mob/living/silicon/ai/proc/cmd_show_message_log(mob/user)
	if(incapacitated())
		return
	if(!isnull(aiPDA))
		var/HTML = "<html><head><title>AI PDA Message Log</title></head><body>[aiPDA.tnote]</body></html>"
		user << browse(HTML, "window=log;size=400x444;border=1;can_resize=1;can_close=1;can_minimize=0")
	else
		to_chat(user, "You do not have a PDA. You should make an issue report about this.")


// Pass along the pulse to atoms in contents, largely added so pAIs are vulnerable to EMP
/obj/item/pda/emp_act(severity)
	. = ..()
	if (!(. & EMP_PROTECT_CONTENTS))
		for(var/atom/A in src)
			A.emp_act(severity)
	if (!(. & EMP_PROTECT_SELF))
		emped += 1
		spawn(200 * severity)
			emped -= 1

/proc/get_viewable_pdas()
	. = list()
	// Returns a list of PDAs which can be viewed from another PDA/message monitor.
	for(var/obj/item/pda/P in GLOB.PDAs)
		if(!P.owner || P.toff || P.hidden)
			continue
		. += P

#undef PDA_SCANNER_NONE
#undef PDA_SCANNER_MEDICAL
#undef PDA_SCANNER_FORENSICS
#undef PDA_SCANNER_REAGENT
#undef PDA_SCANNER_HALOGEN
#undef PDA_SCANNER_GAS
#undef PDA_SPAM_DELAY

#undef PDA_STANDARD_OVERLAYS

#undef PDA_OVERLAY_ALERT
#undef PDA_OVERLAY_SCREEN
#undef PDA_OVERLAY_ID
#undef PDA_OVERLAY_ITEM
#undef PDA_OVERLAY_LIGHT
#undef PDA_OVERLAY_PAI
