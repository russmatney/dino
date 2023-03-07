@tool
extends Node

###########################################################
# area DB

# TODO can we gather all nodes of a type more generally?
var area_scenes = [
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
	# TODO validation apis
	# e.g. are all the elevator connections valid?
	pass

###########################################################
# ready

func _ready():
	# TODO maybe every time? was formely only when no areas
	register_areas()
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

func restart_game():
	register_areas()

	# consider first area selection logic
	load_area(area_scenes[0])

func load_area(area_scene, spawn_node_path=null):
	current_area = load(area_scene).instantiate()
	current_area_name = current_area.name

	if spawn_node_path:
		current_area.set_spawn_node(spawn_node_path)

	Navi.nav_to(current_area)

func _on_new_scene_instanced(s):
	if s == current_area:
		# deferring to run after the new scene is set (which is also deferred)
		spawn_player()

func spawn_player():
	create_new_player()
	Navi.add_child_to_current(player)

###########################################################
# Player

var player_scene = preload("res://src/mvania19/player/Monster.tscn")
var player

# persist/read logic
const default_player_data = {
	"health": 6,
	}
var player_data = default_player_data

func create_new_player():
	var spawn_coords
	if current_area:
		spawn_coords = current_area.player_spawn_coords()
	else:
		spawn_coords = Vector2.ZERO
	player = player_scene.instantiate()
	player.position = spawn_coords
	player.player_data = player_data

func find_current_area():
	# this should only happen in dev-mode, when running an area in isolation
	for c in get_tree().get_root().get_children():
		if c is MvaniaArea:
			current_area = c
			Debug.warn("manually setting current_area")

func _on_player_found(p):
	Debug.prn("player found")
	if not player:
		player = p

	update_rooms()

func update_rooms():
	# we could pass the 'entered' room in here, may be faster
	if not current_area:
		find_current_area()

	if not current_area:
		Debug.prn("[WARN] No current area.")
		return

	if len(current_area.rooms) == 0:
		Debug.prn("[WARN] Zero current area rooms.")
		return

	for room in current_area.rooms:
		var rect = room.used_rect()
		rect.position += room.position

		# NOTE overlapping rooms would break this
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
	# TODO show current room, area data?

###########################################################
# Area travel

func travel_to_area(dest_area, elevator_path):
	Debug.pr("traveling to area", dest_area, elevator_path)

	if current_area.scene_file_path == dest_area:
		# TODO handle if we're already in the right area
		# (smooth camera movement)
		Debug.pr("already in same area?")

	load_area(dest_area, elevator_path)

###########################################################
# dev helper functions

func maybe_spawn_player():
	if not Engine.is_editor_hint():
		await get_tree().create_timer(0.5).timeout
		if player == null:
			spawn_player()
