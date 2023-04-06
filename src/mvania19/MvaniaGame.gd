@tool
extends Node

###########################################################
# start game

var current_area: MvaniaArea

func load_area(area_scene_path, spawn_node_path=null):
	var area_scene_inst = load(area_scene_path).instantiate()
	current_area = area_scene_inst

	if spawn_node_path:
		current_area.set_spawn_node(spawn_node_path)

	Navi.nav_to(current_area)

###########################################################
# Area travel

func travel_to(dest_area_name, elevator_path):
	if current_area.name == dest_area_name:
		Debug.pr("Traveling in same area", dest_area_name, elevator_path)
		current_area.set_spawn_node(elevator_path)
		Game.player.clear_move_target()
		Game.player.position = current_area.player_spawn_coords()
		return

	Debug.pr("Traveling to area", dest_area_name, elevator_path)

	var dest_area = Hotel.first({group="mvania_areas", area_name=dest_area_name})
	if dest_area == null:
		Debug.warn("Can't travel_to(), no area found", dest_area_name, elevator_path)
		return

	if not "scene_file_path" in dest_area:
		Debug.warn("Can't travel_to(), no scene_file_path in area", dest_area)
		return

	load_area(dest_area["scene_file_path"], elevator_path)

###########################################################
# world update

func ensure_current_area():
	# what situation does get used in?
	if not current_area:
		Debug.warn("mvania game had to seek out a current_area")
		for c in get_tree().get_root().get_children():
			# could use groups instead
			if c is MvaniaArea:
				current_area = c

###########################################################
# player respawn coords

func get_spawn_coords():
	ensure_current_area()

	var spawn_coords = current_area.player_spawn_coords()

	if spawn_coords == null:
		Debug.warn("No spawn coords found for area", current_area)

	return spawn_coords

###########################################################
# world update

func update_rooms():
	ensure_current_area()

	if not current_area or not is_instance_valid(current_area):
		Debug.warn("No current area, cannot update rooms")
		return

	if len(current_area.rooms) == 0:
		# this _should_ only happen when the room is being unloaded
		# commenting out the spammy warning for now
		# Debug.warn("Cannot update zero rooms.")
		return

	var player = Game.player

	var new_current
	for room in current_area.rooms:
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

