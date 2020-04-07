GLOBAL_LIST_EMPTY(dimension_hoppers)

/obj/machinery/dimension_hopper
	name = "dimension hopper"
	desc = "An inter-dimensional transportation pad."
	icon = 'icons/obj/machines/teleporter.dmi'
	density = TRUE
	var/receiver = FALSE
	var/destination_type

/obj/machinery/dimension_hopper/lavaland
	destination_type = SERVER_LAVALAND

/obj/machinery/dimension_hopper/lavaland/receiver
	receiver = TRUE

/obj/machinery/dimension_hopper/Initialize()
	. = ..()
	dimension_hoppers += src

/obj/machinery/dimension_hopper/Destroy()
	dimension_hoppers -= src

/obj/machinery/dimension_hopper/Bumped(atom/AM) //TODO: Finish this after map_object is implemented
	if(receiver)
		return ..()
	/*
	if(!destination_type)
		to_chat(H, "<span class='warning'>No destination configured.</span>")
	if(SSserver_manager.save_mob(H))
		SSserver_manager.send_data(destination_type, "receive-mob=[H.ckey]") //TODO: Implement this
		//TODO: Finish this
	else
		to_chat(H, "<span class='warning'>Transportation failed.</span>")
	*/
