@tool
extends Node

enum Powerup { Sword, DoubleJump, Climb }
var all_powerups = [Powerup.Sword, Powerup.DoubleJump, Powerup.Climb]

###########################################################

const demoland_area_scenes = [
	"res://src/mvania19/maps/demoland/area01/Area01.tscn",
	"res://src/mvania19/maps/demoland/area02/Area02.tscn",
	"res://src/mvania19/maps/demoland/area03/Area03.tscn",
	"res://src/mvania19/maps/demoland/area04/Area04.tscn",
	"res://src/mvania19/maps/demoland/area05snow/Area05.tscn",
	"res://src/mvania19/maps/demoland/area06purplestone/Area06PurpleStone.tscn",
	"res://src/mvania19/maps/demoland/area07grassycave/Area07GrassyCave.tscn",
	"res://src/mvania19/maps/demoland/area08allthethings/Area08AllTheThings.tscn",
	]

const hatbot_area_scenes = [
	"res://src/mvania19/maps/hatbot/TheLandingSite.tscn",
	"res://src/mvania19/maps/hatbot/Simulation.tscn",
	"res://src/mvania19/maps/hatbot/TheKingdom.tscn",
	"res://src/mvania19/maps/hatbot/Volcano.tscn",
	]

# var area_scenes = demoland_area_scenes
var area_scenes = hatbot_area_scenes

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

# public start/restart game function (from title screen)
func restart_game():
	register_areas()

	# this script manages the player
	# so remove/don't add debugging tools, powerup helpers, dev_notify logs, etc
	managed_game = true

	# consider area selection logic
	# TODO pull from saved game?
	load_area(area_scenes[0])

func load_area(area_scene_path, spawn_node_path=null):
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
		respawn_player()

func respawn_player():
	var p = create_new_player()
	Navi.add_child_to_current(p)
	update_rooms()

###########################################################
# Player

const player_scene = preload("res://src/mvania19/player/Monster.tscn")
var player

func create_new_player():
	if player:
		var p = player
		player = null
		Navi.current_scene.remove_child(p)
		update_rooms()
		p.free()

	var spawn_coords

	# may need to check if this instance is valid, etc
	ensure_current_area()

	spawn_coords = current_area.player_spawn_coords()

	if spawn_coords == Vector2.ZERO:
		Debug.warn("No spawn coords found for area", current_area)

	player = player_scene.instantiate()
	player.position = spawn_coords
	return player

func ensure_current_area():
	if not current_area:
		for c in get_tree().get_root().get_children():
			# could use groups instead
			if c is MvaniaArea:
				current_area = c
				if player:
					# really shouldn't have a player without a current area
					Debug.warn("found current_area in MvaniaGame after player found")

func _on_player_found(p):
	Debug.prn("MvaniaGame.player found")
	if not player:
		player = p

	update_rooms()

func update_rooms():
	# we could pass the 'entered' room in here, may be faster
	ensure_current_area()

	if not current_area or not is_instance_valid(current_area):
		Debug.warn("No current area, cannot update rooms")
		return

	if len(current_area.rooms) == 0:
		# this _should_ only happen when the room is being unloaded
		# commenting out the spammy warning for now
		# Debug.warn("Cannot update zero rooms.")
		return

	var new_current
	for room in current_area.rooms:
		var rect = room.used_rect()
		rect.position += room.position

		# NOTE overlapping rooms may break this
		if player and is_instance_valid(player) and rect.has_point(player.global_position):
			new_current = room
		else:
			# room.set_visible(false)
			# maybe want a cleanup here to clear bullets and things
			room.pause()

	if new_current:
		current_room = new_current
	else:
		current_room = null

	if current_room:
		# current_room.set_visible(true)
		current_room.unpause()

func set_forced_movement_target(target_position):
	player.move_to_target(target_position)

func clear_forced_movement_target():
	player.clear_move_target()


###########################################################
# HUD

func _on_hud_ready():
	Debug.prn("hud ready")
	# TODO show current room, area data
	# TODO show player data
	# TODO show quest progress

###########################################################
# Area travel

func travel_to(dest_area_name, elevator_path):
	if current_area.name == dest_area_name:
		Debug.pr("Traveling in same area", dest_area_name, elevator_path)
		current_area.set_spawn_node(elevator_path)
		clear_forced_movement_target()
		player.position = current_area.player_spawn_coords()
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
# dev helper functions

func maybe_spawn_player():
	if not managed_game and not Engine.is_editor_hint():
		Debug.pr("Unmanaged game, spawning player")
		if player == null:
			respawn_player()
