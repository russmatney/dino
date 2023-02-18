@tool
extends Node

func prn(msg, msg2=null, msg3=null, msg4=null):
	if msg4:
		print("[MvaniaGame]: ", msg, msg2, msg3, msg4)
	elif msg3:
		print("[MvaniaGame]: ", msg, msg2, msg3)
	elif msg2:
		print("[MvaniaGame]: ", msg, msg2)
	else:
		print("[MvaniaGame]: ", msg)

###########################################################
# area DB

var area_scenes = [
	preload("res://src/mvania19/maps/area01/Area01.tscn"),
	preload("res://src/mvania19/maps/area02/Area02.tscn")
	]

var area_db = {}

func recreate_db():
	prn("recreating area_db")
	area_db = {}
	for area in area_scenes:
		var area_inst = area.instantiate()
		area_inst.persist_area()
		area_inst.queue_free()
	prn("recreated area_db: ", len(area_db))

func print_area_db():
	# TODO pretty print
	prn(area_db)

func persist_area(area):
	area.ensure_rooms()
	if len(area.rooms) == 0:
		push_error(area.name, " [ERR] No rooms!")
		return

	# don't overwrite if exists?
	area_db[area.name] = {
		"name": area.name,
		"scene_file_path": area.scene_file_path,
		"rooms": {},
		}

	for r in area.rooms:
		persist_room_data(area, r.to_room_data())

func update_room_data(room):
	persist_room_data(room.area, room.to_room_data())

func persist_room_data(area, room_data):
	area_db[area.name]["rooms"][room_data["name"]] = room_data

func get_area_data(area):
	if area.name in area_db:
		return area_db[area.name]

func get_rooms_data(area):
	return area_db[area.name]["rooms"]

func get_room_data(room):
	return area_db[room.area.name]["rooms"][room.name]

###########################################################
# ready

func _ready():
	if len(area_db) == 0:
		recreate_db()

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
	recreate_db()

	# consider first area selection logic
	load_area(area_scenes[0])

func load_area(area_scene, spawn_node_path=null):
	current_area = area_scene.instantiate()
	current_area_name = current_area.name

	# var area_data = area_db[current_area_name]
	# current_area.set_area_data(area_data)

	if spawn_node_path:
		current_area.set_spawn_node(spawn_node_path)

	# bandaid to remove players from areas/rooms
	current_area.drop_player()

	Navi.nav_to(current_area)

func _on_new_scene_instanced(s):
	if s == current_area:
		# deferring to run after the new scene is set (which is also deferred)
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
	var spawn_coords = current_area.player_spawn_coords()
	player = player_scene.instantiate()
	player.position = spawn_coords
	player.player_data = player_data

func find_current_area():
	# this should only happen in dev-mode, when running an area in isolation
	for c in get_tree().get_root().get_children():
		if c is MvaniaArea:
			current_area = c
			prn("[WARN] manually setting current_area")

func _on_player_found(p):
	prn("player found")
	if not player:
		player = p

	update_current_rooms()


func update_current_rooms():
	# we could pass the 'entered' room in here, may be faster
	if not current_area:
		find_current_area()

	if not current_area:
		prn("[WARN] No current area.")
		return

	if len(current_area.rooms) == 0:
		prn("[WARN] Zero current area rooms.")
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


###########################################################
# HUD

func _on_hud_ready():
	prn("hud ready")
	# TODO show current room, area data?

###########################################################
# Area travel

func travel_to_area(dest_area, elevator_path):
	prn("traveling to area: ", dest_area, " ", elevator_path)

	if current_area.scene_file_path == dest_area:
		# we're already in the right area
		print("already in same area?")

	var area = load(dest_area)
	load_area(area, elevator_path)
