@tool
extends CanvasLayer

## vars ######################################################

var game: VaniaGame
var current_room_def: VaniaRoomDef

@onready var seed_label = $%SeedLabel
@onready var current_room_label = $%CurrentRoomLabel
@onready var room_count_label = $%RoomCountLabel
@onready var neighbors_label = $%NeighborsLabel

@onready var room_entities_label = $%RoomEntitiesLabel
@onready var edit_entities_menu_button = $%EditEntitiesMenuButton

@onready var room_tiles_label = $%RoomTilesLabel
@onready var edit_tileset_menu_button = $%EditTilesetMenuButton

@onready var room_constraints_label = $%RoomConstraintsLabel
@onready var edit_constraints_menu_button = $%EditConstraintsMenuButton

@onready var edit_room_def_button = $%EditRoomDefButton
@onready var respawn_player_button = $%RespawnPlayerButton

@onready var regen_other_rooms_button = $%RegenOtherRoomsButton
@onready var reload_this_room_button = $%ReloadThisRoomButton
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
	if Engine.is_editor_hint():
		return
	if not game:
		Log.warn("VaniaEditor could not find game")
		return
	Log.pr("Vania Editor ready", game.room_defs)

	Debug.debug_toggled.connect(on_debug_toggled)
	set_visible(Debug.debugging)

	game.room_loaded.connect(on_room_loaded, CONNECT_DEFERRED)
	update_room_def()

	edit_room_def_button.pressed.connect(on_edit_room_def_pressed)
	respawn_player_button.pressed.connect(on_respawn_player_pressed)

	regen_other_rooms_button.pressed.connect(on_regen_other_rooms_pressed)
	reload_this_room_button.pressed.connect(on_reload_this_room_pressed)
	inc_room_count_button.pressed.connect(on_inc_room_count_pressed)
	dec_room_count_button.pressed.connect(on_dec_room_count_pressed)
	rerender_background_button.pressed.connect(on_rerender_background_pressed)

func on_debug_toggled(debugging):
	set_visible(debugging)

func on_room_loaded():
	current_room_def = game.current_room_def()
	update_room_def()
	update_edit_entities()
	update_edit_tilesets()
	update_edit_constraints()


## rerender ######################################################

func update_room_def():
	if not current_room_def:
		return
	Log.pr("current rd", current_room_def)
	seed_label.text = "seed: %s" % Dino._seed
	room_count_label.text = "rooms: %s" % len(game.room_defs)
	current_room_label.text = "room: %s" % current_room_def.room_path.get_file()
	neighbors_label.text = "ngbrs: %s" % Log.to_printable([current_room_def.build_neighbor_data().map(func(n): return n.room_path.get_file())])

	room_entities_label.text = "ents: %s" % Log.to_printable([current_room_def.entities])
	room_tiles_label.text = "tileset: %s" % current_room_def.get_primary_tilemap().get_file()
	room_constraints_label.text = "constraints: %s" % Log.to_printable([len(current_room_def.constraints)])

func update_edit_entities():
	if not current_room_def:
		return

	var items = []
	items.append_array(current_room_def.entities.map(func(ent):
		return {label="Remove '%s'" % ent, on_select=func(): current_room_def.entities.erase(ent)}))
	items.append_array(current_room_def.all_entities.map(func(ent):
		return {label="Add '%s'" % ent, on_select=func(): current_room_def.entities.append(ent)}))

	var popup = edit_entities_menu_button.get_popup()
	U.setup_popup_items(popup, items, func(item):
		item.on_select.call()
		game.generator.build_and_prep_scene(current_room_def)
		game.reload_current_room())

func update_edit_tilesets():
	if not current_room_def:
		return

	var items = []
	items.append_array(RoomInputs.all_tilemap_scenes.map(func(tm):
		return {label=tm.get_file(), on_select=func(): current_room_def.tilemap_scenes[0] = tm}))

	var popup = edit_tileset_menu_button.get_popup()
	U.setup_popup_items(popup, items, func(item):
		item.on_select.call()
		game.generator.build_and_prep_scene(current_room_def)
		game.reload_current_room())

func update_edit_constraints():
	if not current_room_def:
		return

	var items = []
	items.append_array(current_room_def.constraints.map(func(cons):
		return {label="Remove '%s'" % Log.to_printable([cons]), on_select=func(): current_room_def.constraints.erase(cons)}))
	items.append_array(RoomInputs.all_constraints.map(func(cons):
		return {label="Add '%s'" % Log.to_printable([cons]), on_select=func(): current_room_def.constraints.append(cons)}))

	var popup = edit_constraints_menu_button.get_popup()
	U.setup_popup_items(popup, items, func(item):
		item.on_select.call()

		current_room_def.reapply_constraints()

		game.generator.build_and_prep_scene(current_room_def)
		game.reload_current_room())

## buttons pressed ######################################################

func on_edit_room_def_pressed():
	pass

func on_regen_other_rooms_pressed():
	game.regenerate_other_rooms()

func on_reload_this_room_pressed():
	game.reload_current_room()

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
	var player = Dino.current_player_node()
	if player != null:
		if player.has_method("resurrect"):
			player.resurrect()
	Dino.respawn_active_player()
