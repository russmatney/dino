@tool
extends Node

const zones_group = "metro_zones"
const rooms_group = "metro_rooms"
const checkpoints_group = "metro_checkpoints"

###########################################################
# start game

var current_zone: MetroZone

func load_zone(zone_scene_path, spawn_node_path=null):
	var zone_scene_inst = load(zone_scene_path).instantiate()
	current_zone = zone_scene_inst

	if spawn_node_path:
		current_zone.set_spawn_node(spawn_node_path)

	Navi.nav_to(current_zone)

###########################################################
# Zone travel

func travel_to(dest_zone_name, elevator_path):
	if current_zone.name == dest_zone_name:
		Debug.pr("Traveling in same zone", dest_zone_name, elevator_path)
		current_zone.set_spawn_node(elevator_path)
		Game.player.clear_forced_movement_target()
		Game.player.position = current_zone.player_spawn_coords()
		return

	Debug.pr("Traveling to zone", dest_zone_name, elevator_path)

	var dest_zone = Hotel.first({group=Metro.zones_group, zone_name=dest_zone_name})
	if dest_zone == null:
		Debug.warn("Can't travel_to(), no zone found", dest_zone_name, elevator_path)
		return

	if not "scene_file_path" in dest_zone:
		Debug.warn("Can't travel_to(), no scene_file_path in zone", dest_zone)
		return

	load_zone(dest_zone["scene_file_path"], elevator_path)

###########################################################
# world update

func ensure_current_zone(zone=null):
	if zone:
		current_zone = zone
		return
	# what situation does get used in?
	if not current_zone:
		Debug.warn("Metro had to seek out a current_zone")
		for c in get_tree().get_root().get_children():
			# could use groups instead
			if c is MetroZone:
				current_zone = c

###########################################################
# player respawn coords

func get_spawn_coords():
	ensure_current_zone()
	if not current_zone:
		Debug.warn("No current zone in metro, returning ZEROed spawn coords")
		return Vector2.ZERO

	var spawn_coords = current_zone.player_spawn_coords()

	if spawn_coords == null:
		Debug.warn("No spawn coords found for zone", current_zone)

	return spawn_coords

###########################################################
# world update

var current_room

func update_zone():
	ensure_current_zone()

	if not current_zone or not is_instance_valid(current_zone):
		Debug.warn("No current zone, cannot update rooms")
		return

	if len(current_zone.rooms) == 0:
		# this _should_ only happen when the room is being unloaded
		# commenting out the spammy warning for now
		# Debug.warn("Cannot update zero rooms.")
		return

	var new_current
	var rooms_to_pause = []
	for room in current_zone.rooms:
		if room.contains_player(Game.player):
			new_current = room
			continue
		if not room.paused:
			rooms_to_pause.append(room)

	for room in rooms_to_pause:
		if new_current == null and current_room == room:
			# don't pause the current room if we didn't find a new one
			continue
		# maybe want a cleanup here to clear bullets and things
		room.pause()

	if new_current:
		new_current.unpause()
		current_room = new_current
	elif current_room == null:
		# unpause all rooms, so the player is detected when entering one
		current_zone.rooms.map(func(room):
			room.unpause({process_only=true}))
