#define CHILD_SERVER "child-server"
#define CHILD_TYPE "child-type"
#define PARENT_PORT "parent-port"
#define DMB "beestation.dmb"

SUBSYSTEM_DEF(server_manager)
	name = "Server Manager"
	init_order = INIT_ORDER_SERVER_MANAGER //This may need to be higher priority
	priority = FIRE_PRIORITY_SERVER_MANAGER
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/is_parent = TRUE

	var/datum/server_type/server
	var/list/server_list = list()

//TODO: Heartbeat timer. Children should regularly check the status of the parent server in case the child needs to die. Also probably wouldn't hurt for parents to keep an eye on children.

//TODO: Francinum suggested using a goonchat cookie to see if there is a syndication cookie for the player, to kick them to the main server if they attempt to direct-connect to a child. Have a look at /datum/chatOutput/proc/analyzeClientData in code/modules/goonchat/browserOutput.dm

//TODO (Pipe dream): The main master server no longer handles anything except connections and managing the child servers. This will enable stuff like hot/cold station servers for instant round restarts.

/datum/controller/subsystem/server_manager/Initialize()
	. = ..()
	is_parent = text2num(world.params[CHILD_SERVER]) ? FALSE : TRUE
	to_chat(world, "IS PARENT: [is_parent]")
	WARNING("IS PARENT: [is_parent]")
	for(var/S in subtypesof(/datum/server_type))
		var/datum/server_type/child = new S()
		if(!child.enabled)
			continue
		server_list += child
	if(is_parent)
		server = new()
		for(var/datum/server_type/C in server_list)
			WARNING("Creating child server [C.name] of type [C.server_type] on port [C.port]")
			startup("[DMB]", "[C.port]", "-trusted", "-close", "-params child-server=1;child-type=[C.server_type];parent-port=[world.port]")
	else
		var/type_param = text2num(world.params[CHILD_TYPE])
		if(type_param == null)
			return
		for(var/datum/server_type/T in server_list)
			if(T.server_type == type_param)
				server = T
				server_list -= T
				break

		var/datum/server_type/P = new()
		server_list += P
		to_chat(world, "I'm a [server.name] server!")

/datum/controller/subsystem/server_manager/stat_entry()
	..("TYPE: [server ? server.name : "null"]")

/datum/controller/subsystem/server_manager/fire()
	//Heartbeat. The BYOND builtin auto-close doesn't seem to work when STOP in DD is used, and presumably won't work in the event of a crash either.
	for(var/datum/server_type/S in server_list)
		if(world.time >= (S.last_heartbeat + S.heartbeat_interval))
			S.last_heartbeat = world.time
			to_chat(world, "Attempting to ping [S.name]")
			var/response = world.Export("[S.addr]?heartbeat")
			response = text2num(response)
			to_chat(world, "RESPONSE: [response] FROM [S.name]")

		//if(world.time + S.heartbeat_timeout >= S.last_heartbeat_response)
			//Failed to receive any heartbeats. Assume it's dead.




//TODO: Make this an admin-only verb
/client/verb/client_to_child()
	set category = "OOC"
	set name = "Connect to child server"

	var/datum/server_type/target = input("Please, select a server!", "Connect to child server", null, null) as null|anything in SSserver_manager.server_list
	usr << link("[target.ip]:[target.port]")
