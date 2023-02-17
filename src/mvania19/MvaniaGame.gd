@tool
extends Node

func prn(msg, msg2=null, msg3=null):
	if msg3:
		print("[MvaniaGame]: ", msg, msg2, msg3)
	elif msg2:
		print("[MvaniaGame]: ", msg, msg2)
	else:
		print("[MvaniaGame]: ", msg)

###########################################################
# area DB

var area_scenes = [
	preload("res://src/mvania19/maps/area01/Area01.tscn")
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

func persist_room_data(area, room_data):
	area_db[area.name]["rooms"][room_data["name"]] = room_data

func get_area_data(area):
	if area.name in area_db:
		return area_db[area.name]

func get_rooms_data(area):
	return area_db[area.name]["rooms"]

func get_room_data(area, room):
	return area_db[area.name]["rooms"][room.name]

###########################################################
# ready

func _ready():
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
	current_area_name = area_db.keys()[0]

	load_area()
	spawn_player()

	Navi.nav_to(current_area)

func load_area():
	# unload current area?
	var area_data = area_db[current_area_name]
	current_area = load(area_data["scene_file_path"]).instantiate()


###########################################################
# Player

var player_scene = preload("res://src/mvania19/player/Monster.tscn")
var player

# persist/read logic
const default_player_data = {
	"health": 6,
	}
var player_data = default_player_data

func spawn_player():
	var spawn_coords = current_area.player_spawn_point()
	player = player_scene.instantiate()
	player.position = spawn_coords
	player.player_data = player_data
	Navi.add_child_to_current(player)

func _on_player_found(p):
	if not player:
		player = p

	prn("player found, hiding other rooms")

	if not current_area:
		for c in get_tree().get_root().get_children():
			if c is MvaniaArea:
				current_area = c
				# this should only happen in dev-mode
				prn("[WARN] manually setting current_area")

	if len(current_area.rooms) == 0:
		prn("[WARN] Zero current area rooms.")

	for room in current_area.rooms:
		var rect = room.used_rect()
		rect.position += room.position

		# NOTE overlapping rooms would break this
		if rect.has_point(player.global_position):
			current_room = room
		else:
			room.set_visible(false)

	if current_room:
		current_room.set_visible(true)
		current_room.unpause()


###########################################################
# HUD

func _on_hud_ready():
	prn("hud ready")
	# TODO set current room, area data?
