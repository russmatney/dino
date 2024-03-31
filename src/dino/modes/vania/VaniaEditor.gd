@tool
extends CanvasLayer

## vars ######################################################

var game: VaniaGame
var current_room_def: VaniaRoomDef

@onready var seed_label = $%SeedLabel
@onready var current_room_label = $%CurrentRoomLabel
@onready var room_entities_label = $%RoomEntitiesLabel
@onready var neighbors_label = $%NeighborsLabel
@onready var room_tiles_label = $%RoomTilesLabel
@onready var room_count_label = $%RoomCountLabel

@onready var edit_room_def_button = $%EditRoomDefButton
@onready var regen_button = $%RegenButton
@onready var respawn_player_button = $%RespawnPlayerButton

## enter tree ######################################################

func _enter_tree():
	var p = get_parent()
	if p is VaniaGame:
		game = p

## ready ######################################################

func _ready():
	if not game:
		Log.warn("VaniaEditor could not find game")
	Log.pr("Vania Editor ready", game.room_defs)

	game.room_loaded.connect(on_room_loaded, CONNECT_DEFERRED)
	update_room_def()

	edit_room_def_button.pressed.connect(on_edit_room_def_pressed)
	regen_button.pressed.connect(on_regen_pressed)
	respawn_player_button.pressed.connect(on_respawn_player_pressed)

func on_room_loaded():
	current_room_def = game.current_room_def()
	update_room_def()

########################################################

func on_edit_room_def_pressed():
	pass

func on_regen_pressed():
	game.regenerate_other_rooms()

func on_respawn_player_pressed():
	Dino.respawn_active_player()

func update_room_def():
	if current_room_def:
		Log.pr("current rd", current_room_def)
		seed_label.text = "seed: %s" % Dino.egg
		current_room_label.text = "room: %s" % current_room_def.room_path.get_file()
		room_entities_label.text = "ents: %s" % Log.to_printable([current_room_def.entities])
		neighbors_label.text = "ngbrs: %s" % Log.to_printable([MetSys.get_current_room_instance().get_neighbor_rooms(false).map(func(n): return n.get_file())])
		# room_tiles_label.text = Log.to_printable([current_room_def.entities])
		room_count_label.text = "rooms: %s" % len(game.room_defs)
