@tool
extends Node

const zones_group = "metro_zones"
const rooms_group = "metro_rooms"

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
		Game.player.clear_move_target()
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

	var spawn_coords = current_zone.player_spawn_coords()

	if spawn_coords == null:
		Debug.warn("No spawn coords found for zone", current_zone)

	return spawn_coords

###########################################################
# world update

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

	var player = Game.player

	var new_current
	for room in current_zone.rooms:
		var rect = room.used_rect()
		rect.position += room.position

		# NOTE overlapping rooms may break this
		if player and is_instance_valid(player) and rect.has_point(player.global_position):
			new_current = room
		else:
			# maybe want a cleanup here to clear bullets and things
			room.pause()

	var current_room
	if new_current:
		current_room = new_current
	else:
		current_room = null

	if current_room:
		current_room.unpause()
