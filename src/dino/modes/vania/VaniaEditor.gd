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
@onready var respawn_player_button = $%RespawnPlayerButton

@onready var regen_button = $%RegenButton
@onready var inc_room_count_button = $%IncRoomCountButton
@onready var dec_room_count_button = $%DecRoomCountButton
@onready var rerender_background_button = $%RerenderBackgroundButton

## enter tree ######################################################

func _enter_tree():
	var p = get_parent()
	if p is VaniaGame:
		game = p

## ready ######################################################

func _ready():
	if not game:
		Log.warn("VaniaEditor could not find game")
		return
	Log.pr("Vania Editor ready", game.room_defs)

	game.room_loaded.connect(on_room_loaded, CONNECT_DEFERRED)
	update_room_def()

	edit_room_def_button.pressed.connect(on_edit_room_def_pressed)
	respawn_player_button.pressed.connect(on_respawn_player_pressed)

	regen_button.pressed.connect(on_regen_pressed)
	inc_room_count_button.pressed.connect(on_inc_room_count_pressed)
	dec_room_count_button.pressed.connect(on_dec_room_count_pressed)
	rerender_background_button.pressed.connect(on_rerender_background_pressed)

func on_room_loaded():
	current_room_def = game.current_room_def()
	update_room_def()

########################################################

func on_edit_room_def_pressed():
	pass

func on_regen_pressed():
	game.regenerate_other_rooms()

func on_inc_room_count_pressed():
	game.increment_room_count()
	update_room_def()

func on_dec_room_count_pressed():
	game.decrement_room_count()
	update_room_def()

func on_rerender_background_pressed():
	game.map.clear_background_tiles()
	game.map.add_background_tiles()

func on_respawn_player_pressed():
	Dino.respawn_active_player()

func update_room_def():
	if current_room_def:
		Log.pr("current rd", current_room_def)
		seed_label.text = "seed: %s" % Dino.egg
		current_room_label.text = "room: %s" % current_room_def.room_path.get_file()
		room_entities_label.text = "ents: %s" % Log.to_printable([current_room_def.entities])
		neighbors_label.text = "ngbrs: %s" % Log.to_printable([MetSys.get_current_room_instance().get_neighbor_rooms(false).map(func(n): return n.get_file())])
		room_tiles_label.text = "tileset: %s" % current_room_def.label_to_tilemap.get("Tile").scene.resource_path.get_file()
		room_count_label.text = "rooms: %s (%s)" % [len(game.room_defs), game.desired_room_count]
