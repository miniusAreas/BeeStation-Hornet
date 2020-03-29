#define SERVER_PARENT 	0
#define SERVER_LAVALAND 1

#define STATUS_OFFLINE	0
#define STATUS_ONLINE	1

/datum/server_type
	var/name = "Parent"
	var/server_type = SERVER_PARENT
	var/ip = "127.0.0.1"
	var/port
	var/addr
	var/parent_port
	var/list/maps_to_load
	var/enabled = TRUE

	var/status = STATUS_ONLINE
	var/heart_failures = 0 //How many times we've failed to get a response
	var/max_heart_failures = 3 //Don't die just because world/Topic() screwed up once
	var/heartbeat_interval = (10 SECONDS) //May need to be adjusted. How often to send out a ping to the server.
	var/last_heartbeat

/datum/server_type/New()
	if(!port)
		if(server_type == SERVER_PARENT)
			port = text2num(world.params[PARENT_PORT])
			parent_port = port //Doesn't actually need to be set on the parent type but w/e, consistency or something
		else
			WARNING("Server type [server_type] has no port!")
	if(!parent_port)
		parent_port = text2num(world.params[PARENT_PORT])

	addr = "byond://[ip]:[port]"
	last_heartbeat = world.time

/datum/server_type/lavaland
	name = "Lavaland"
	server_type = SERVER_LAVALAND
	port = 25001
	maps_to_load = "map_files/Mining/Lavaland.dmm"
