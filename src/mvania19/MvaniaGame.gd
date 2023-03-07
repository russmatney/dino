@tool
extends Node

###########################################################
# area DB

const area_scenes = [
	"res://src/mvania19/maps/area01/Area01.tscn",
	"res://src/mvania19/maps/area02/Area02.tscn",
	"res://src/mvania19/maps/area03/Area03.tscn",
	"res://src/mvania19/maps/area04/Area04.tscn",
	"res://src/mvania19/maps/area05snow/Area05.tscn",
	"res://src/mvania19/maps/area06purplestone/Area06PurpleStone.tscn",
	"res://src/mvania19/maps/area07grassycave/Area07GrassyCave.tscn",
	"res://src/mvania19/maps/area08allthethings/Area08AllTheThings.tscn",
	]

func register_areas():
	Debug.pr("Checking area data into Hotel")

	for sfp in area_scenes:
		Hotel.book(sfp)

	var areas = Hotel.query({"group": "mvania_areas"})

	Debug.pr("recreated Hotel.scene_db with", len(areas), "areas.")

func validate():
	var elevators = Hotel.query({group="elevators"})
	for e in elevators:
		pass

		# TODO reconsider in elevator multi-select context

		# var dest_area = e.destination_area_full_path()
		# if dest_area not in area_scenes:
		# 	Debug.warn("Elevator with unknown destination", e, dest_area)

		# # TODO move elevators to selecting areas by name
		# var dest_area_name = ""
		# var dest_elevator_path = e.destination_elevator_path
		# var area_data = Hotel.query({group="mvania_areas",
		# 	filter=func(area): return area["name"] == dest_area_name})
		# var elevator_key = dest_area_name.path_join(dest_elevator_path)

		# var matches =

	# TODO validation apis
	# e.g. are all the elevator connections valid?

###########################################################
# ready

func _ready():
	register_areas()
	# register player scene
	Hotel.book(player_scene)
	validate()

	Navi.new_scene_instanced.connect(_on_new_scene_instanced)

	Hood.hud_ready.connect(_on_hud_ready)
	Hood.found_player.connect(_on_player_found)
	if Hood.player:
		_on_player_found(Hood.player)

###########################################################
# start game

var current_area_name
var current_area: MvaniaArea
var current_room: MvaniaRoom
var managed_game: bool = false

func restart_game():
	register_areas()

	# consider area selection logic
	# TODO pull from saved game?
	load_area(area_scenes[0])

func load_area(area_scene_path, spawn_node_path=null):
	# if we're starting the game via `load_area`,
	# this script manages the player (and game in general)
	# (vs. deving in a room or area)
	managed_game = true

	var area_scene_inst = load(area_scene_path).instantiate()
	set_current_area(area_scene_inst)

	if spawn_node_path:
		current_area.set_spawn_node(spawn_node_path)

	Navi.nav_to(current_area)

func set_current_area(area_scene_inst):
	current_area = area_scene_inst
	current_area_name = current_area.name

func _on_new_scene_instanced(s):
	if s == current_area:
		# deferring to run after the new scene is set (which is also deferred)
		spawn_player()

func spawn_player():
	create_new_player()
	Navi.add_child_to_current(player)

###########################################################
# Player

const player_scene = preload("res://src/mvania19/player/Monster.tscn")
var player

func create_new_player():
	var spawn_coords

	# may need to check if this instance is valid, etc
	if not current_area:
		find_current_area()

	spawn_coords = current_area.player_spawn_coords()

	if spawn_coords == Vector2.ZERO:
		Debug.warn("No spawn coords found for area", current_area)

	player = player_scene.instantiate()
	player.position = spawn_coords

func find_current_area():
	if not current_area:
		for c in get_tree().get_root().get_children():
			# could use groups instead
			if c is MvaniaArea:
				current_area = c
				if player:
					Debug.warn("found current_area in MvaniaGame after player found")

func _on_player_found(p):
	Debug.prn("MvaniaGame.player found")
	if not player:
		player = p

	update_rooms()

func update_rooms():
	# we could pass the 'entered' room in here, may be faster
	if not current_area:
		find_current_area()

	if not current_area:
		Debug.warn("No current area, cannot update rooms")
		return

	if len(current_area.rooms) == 0:
		Debug.warn("Cannot update zero rooms.")
		return

	for room in current_area.rooms:
		var rect = room.used_rect()
		rect.position += room.position

		# NOTE overlapping rooms may break this
		if rect.has_point(player.global_position):
			current_room = room
		else:
			# room.set_visible(false)
			# maybe want a cleanup here to clear bullets and things
			room.pause()

	if current_room:
		# current_room.set_visible(true)
		current_room.unpause()

func set_forced_movement_target(target_position):
	player.move_to_target(target_position)


###########################################################
# HUD

func _on_hud_ready():
	Debug.prn("hud ready")
	# TODO show current room, area data
	# TODO show player data
	# TODO show quest progress

###########################################################
# Area travel

func travel_to_area(dest_area, elevator_path):
	Debug.pr("traveling to area", dest_area, elevator_path)

	# TODO move to selecting area by name
	if current_area.scene_file_path == dest_area:
		# TODO handle if we're already in the right area
		# (smooth camera movement)
		Debug.pr("already in same area")
	else:
		Debug.pr("traveling to a new area")

	load_area(dest_area, elevator_path)

###########################################################
# dev helper functions

func maybe_spawn_player():
	if not managed_game and not Engine.is_editor_hint():
		Debug.pr("Unmanaged game, spawning player")
		if player == null:
			spawn_player()
