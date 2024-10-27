@tool
extends Node

const zones_group = "metro_zones"
const rooms_group = "metro_rooms"
const checkpoints_group = "metro_checkpoints"

###########################################################
# start game

var current_zone: MetroZone

func load_zone(zone_scene_or_path, spawn_node_path=null):
	var zone_scene
	if zone_scene_or_path is String:
		zone_scene = load(zone_scene_or_path)
	else:
		zone_scene = zone_scene_or_path
	var zone_scene_inst = zone_scene.instantiate()
	current_zone = zone_scene_inst

	if spawn_node_path:
		current_zone.set_spawn_node(spawn_node_path)

	Log.pr("loading zone", current_zone)
	Navi.nav_to(current_zone, {
			# TODO bake-in this level_node knowledge to Dino somehow? track a current_root_node?
			setup=func(n):
		Log.pr("setup zone", n)
		# waiting to let the old scene die first?
		await get_tree().create_timer(2.0).timeout,
			on_ready=func(n):

		Log.pr("on_ready zone", n)
		# ugh.....
		await get_tree().create_timer(1.0).timeout
		Dino.spawn_player({level_node=n})
		})

func reload_current_zone():
	if current_zone != null:
		load_zone(current_zone)
		return true
	else:
		Log.warn("no current zone, metro could not reload.")
		return false

###########################################################
# Zone travel

func travel_to(dest_zone, elevator_path=null):
	# could restore same-zone travel
	# var player = P.get_player()
	# if player and is_instance_valid(player) and current_zone.name == dest_zone_name:
	# 	Log.info("Traveling in same zone", dest_zone_name, elevator_path)
	# 	if elevator_path:
	# 		current_zone.set_spawn_node(elevator_path)
	# 	player.clear_forced_movement_target()
	# 	player.position = current_zone.player_spawn_coords()
	# 	return

	Log.info("Traveling to zone", dest_zone, elevator_path)

	load_zone(dest_zone, elevator_path)

###########################################################
# world update

func ensure_current_zone(zone=null):
	if zone:
		current_zone = zone
		return
	# what situation does get used in?
	if not current_zone:
		Log.warn("Metro had to seek out a current_zone")
		for c in get_tree().get_root().get_children():
			# could use groups instead
			if c is MetroZone:
				current_zone = c

###########################################################
# player respawn coords

func get_spawn_coords():
	ensure_current_zone()
	if not current_zone:
		Log.warn("No current zone in metro, returning ZEROed spawn coords")
		return Vector2.ZERO

	var spawn_coords = current_zone.player_spawn_coords()

	if spawn_coords == null:
		Log.warn("No spawn coords found for zone", current_zone)

	return spawn_coords

###########################################################
# world update

var last_containing_room
var last_n_containing_rooms = []
# support setting this from Game.gd, more nuanced per-game behavior
var unpaused_room_count = 3

# Attempts to find a room containing the player, and pause the other rooms
# If no room overlaps the player, the last room (last_containing_room) is left running
# (i.e. unpaused) until another one is found.
func update_zone():
	ensure_current_zone()

	if not current_zone or not is_instance_valid(current_zone):
		Log.warn("No current zone, cannot update rooms")
		return

	if len(current_zone.rooms) == 0:
		# this _should_ only happen when the room is being unloaded
		# commenting out the spammy warning for now
		# Log.warn("Cannot update zero rooms.")
		return

	var current_containing_room = null
	var rooms_to_pause = []
	# var player = P.get_player()
	for room in current_zone.rooms:
		# consider overlapping roomboxes (player in more than one room)
		# probably prefer the existing one until we're not overlapping
		# if player and room.contains_player(player):
		# 	current_containing_room = room
		# elif not room.paused:
		if not room.paused:
			rooms_to_pause.append(room)

	# don't pause last_containing_room if no current_containing_room found
	if current_containing_room == null and last_containing_room != null:
		rooms_to_pause = rooms_to_pause.filter(func(r): return not r == last_containing_room)

	rooms_to_pause = rooms_to_pause.filter(func(r): return not r in last_n_containing_rooms)

	# pausing all unless we have never seen a room (new or existing)
	# this guard might not be necessary anymore (b/c roomboxes are no longer 'paused' when rooms are paused)
	if len(rooms_to_pause) > 0 and not (current_containing_room == null and last_containing_room == null):
		for room in rooms_to_pause:
			# maybe want a cleanup here to clear bullets and things
			room.pause()

	if current_containing_room:
		if current_containing_room.paused:
			current_containing_room.unpause()
		last_containing_room = current_containing_room
		if not current_containing_room in last_n_containing_rooms:
			if len(last_n_containing_rooms) == unpaused_room_count:
				last_n_containing_rooms.pop_front()
			last_n_containing_rooms.push_back(current_containing_room)
	# else:
	# 	Log.warn("No rooms containing player!")
