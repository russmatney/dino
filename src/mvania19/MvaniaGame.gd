@tool
extends Node

###########################################################
# area DB

# TODO can we gather all nodes of a type more generally?
var area_scenes = [
	preload("res://src/mvania19/maps/area01/Area01.tscn"),
	preload("res://src/mvania19/maps/area02/Area02.tscn"),
	preload("res://src/mvania19/maps/area03/Area03.tscn"),
	preload("res://src/mvania19/maps/area04/Area04.tscn"),
	preload("res://src/mvania19/maps/area05snow/Area05.tscn"),
	preload("res://src/mvania19/maps/area06purplestone/Area06PurpleStone.tscn"),
	preload("res://src/mvania19/maps/area07grassycave/Area07GrassyCave.tscn"),
	preload("res://src/mvania19/maps/area08allthethings/Area08AllTheThings.tscn"),
	]

var area_db = {}

signal area_db_recreated(area_db)
signal area_db_updated(area_db)

func recreate_db():
	Debug.prn("recreating area_db")
	area_db = {}


	var a = area_scenes[4]
	var d = Util.packed_scene_data(a)

	Hotel.check_in_area(a)

	var a_name = d[^"."]["name"]

	Debug.prn("hotel checkout", "a_name", a_name, Hotel.check_out(a_name))
	Debug.prn("hotel checkout", "room", Hotel.check_out(a_name, "01Entrance"))
	Debug.prn("hotel checkout", "candle", Hotel.check_out(a_name, "01Entrance/Candle"))

	Debug.prn("hotel scene_db keys", Hotel.scene_db.keys())

	Debug.prn("hotel elevators", Hotel.check_out(a_name, "01Entrance/Elevator"))
	Debug.prn("hotel elevators", Hotel.check_out_for_group("elevators"))

	# print("area: ", d[^"."])
	# print("area keys: ", d[^"."].keys())
	# print("area groups: ", d[^"."]["groups"])
	# print("area props: ", d[^"."]["properties"])
	# print("area script: ", d[^"."]["properties"]["script"])
	# print("area script: ", d[^"."]["properties"]["script"].resource_path)
	# print("area script: ", d[^"."]["properties"]["script"].resource_name)

	# print("room: ", d[^"./01Entrance"])
	# print("room keys: ", d[^"./01Entrance"].keys())
	# print("room props: ", d[^"./01Entrance"]["properties"])
	# print("room script: ", d[^"./01Entrance"]["properties"]["script"])
	# print("room script: ", d[^"./01Entrance"]["properties"]["script"].resource_name)
	# print("room script: ", d[^"./01Entrance"]["properties"]["script"].resource_path)

	# # print(d)
	# print("\n\n")
	# print("keys:", d.keys())
	# print("candle: ", d[^"./01Entrance/Candle"])
	# print("\n\n")
	# print("candle keys: ", d[^"./01Entrance/Candle"].keys())
	# print("\n\n")
	# print("candle props: ", d[^"./01Entrance/Candle"]["properties"])
	# print("candle pos: ", d[^"./01Entrance/Candle"]["properties"]["position"])
	# print("\n\n")
	# print("inst:", d[^"./01Entrance/Candle"]["instance"])
	# print("\n\n")
	for area in area_scenes:
		var area_inst = area.instantiate()
		if area_inst:
			persist_area(area_inst)
			area_inst.queue_free()
		else:
			Debug.prn("area failed to instantiate: ", area)
	Debug.prn("recreated area_db: ", len(area_db), " areas.")

	area_db_recreated.emit(area_db)

func print_area_db():
	# TODO pretty print
	Debug.prn(area_db)

# TODO refactor to alternatively work on a packed_scene
func to_area_data(area):
	area.ensure_rooms()

	var room_data = {}
	if len(area.rooms) == 0:
		Hood.warn(area.name, " No rooms in to_area_data! ", area)

	for r in area.rooms:
		var r_data = r.to_room_data(player)
		room_data[r.name] = r_data

	return {
		"name": area.name,
		"scene_file_path": area.scene_file_path,
		"rooms": room_data,
		}

func persist_area(area):
	var area_data = to_area_data(area)
	if area_data:
		# don't overwrite if exists?
		area_db[area.name] = area_data
		area_db_updated.emit(area_db)

func update_room_data(room):
	persist_room_data(room.area, room.to_room_data(player))

func persist_room_data(area, room_data):
	var old_room_data = area_db[area.name]["rooms"][room_data["name"]]
	if "visited" in room_data and room_data["visited"]:
		if not "visited" in old_room_data or not old_room_data["visited"]:
			MvaniaSounds.play_sound("new_room_blip")
	area_db[area.name]["rooms"][room_data["name"]] = room_data
	area_db_updated.emit(area_db)

func get_area_data(area):
	if area.name in area_db:
		return area_db[area.name]

func get_current_area_data():
	if current_area:
		return area_db[current_area.name]

func get_rooms_data(area):
	return area_db[area.name]["rooms"]

func get_room_data(room):
	if room.name in area_db[room.area.name]["rooms"]:
		return area_db[room.area.name]["rooms"][room.name]
	else:
		Hood.warn("Room data not in area_db: ", room.name)

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
	var spawn_coords = current_area.player_spawn_coords()
	player = player_scene.instantiate()
	player.position = spawn_coords
	player.player_data = player_data

func find_current_area():
	# this should only happen in dev-mode, when running an area in isolation
	for c in get_tree().get_root().get_children():
		if c is MvaniaArea:
			current_area = c
			Debug.prn("[WARN] manually setting current_area")

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
	Debug.prn("traveling to area: ", dest_area, " ", elevator_path)

	if current_area.scene_file_path == dest_area:
		# we're already in the right area
		Debug.prn("already in same area?")

	var area = load(dest_area)
	load_area(area, elevator_path)
