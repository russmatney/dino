extends PanelContainer

## vars ######################################################

var game: VaniaGame
var current_room_def: VaniaRoomDef

@onready var seed_label = $%SeedLabel
@onready var current_room_label = $%CurrentRoomLabel
@onready var room_count_label = $%RoomCountLabel
@onready var neighbors_label = $%NeighborsLabel

@onready var room_entities_label = $%RoomEntitiesLabel
@onready var edit_entities_menu_button = $%EditEntitiesMenuButton

@onready var room_enemies_label = $%RoomEnemiesLabel
@onready var edit_enemies_menu_button = $%EditEnemiesMenuButton

@onready var room_tiles_label = $%RoomTilesLabel
@onready var edit_tileset_menu_button = $%EditTilesetMenuButton

@onready var edit_room_def_button = $%EditRoomDefButton
@onready var respawn_player_button = $%RespawnPlayerButton

@onready var regen_other_rooms_button = $%RegenOtherRoomsButton
@onready var reload_this_room_button = $%ReloadThisRoomButton
@onready var inc_room_count_button = $%IncRoomCountButton
@onready var dec_room_count_button = $%DecRoomCountButton
@onready var rerender_background_button = $%RerenderBackgroundButton

## enter tree ######################################################

func _enter_tree():
	get_tree().node_added.connect(on_node_added)

func on_node_added(node: Node):
	if node.is_in_group("vania_game"):
		setup(node)

## ready ######################################################

func _ready():
	if Engine.is_editor_hint():
		return
	if not game:
		game = get_tree().get_first_node_in_group("vania_game")
	if game:
		setup(game)

	edit_room_def_button.pressed.connect(on_edit_room_def_pressed)
	respawn_player_button.pressed.connect(on_respawn_player_pressed)

	regen_other_rooms_button.pressed.connect(on_regen_other_rooms_pressed)
	reload_this_room_button.pressed.connect(on_reload_this_room_pressed)
	inc_room_count_button.pressed.connect(on_inc_room_count_pressed)
	dec_room_count_button.pressed.connect(on_dec_room_count_pressed)
	rerender_background_button.pressed.connect(on_rerender_background_pressed)

func setup(node: VaniaGame):
	game = node
	game.room_loaded.connect(on_room_loaded, CONNECT_DEFERRED)

func on_room_loaded():
	current_room_def = game.current_room_def()
	update_room_def()
	update_edit_entities()
	update_edit_enemies()
	update_edit_tilesets()


## rerender ######################################################

func update_room_def():
	if not current_room_def:
		return
	seed_label.text = "seed: %s" % Dino._seed
	room_count_label.text = "rooms: %s" % len(game.room_defs)
	current_room_label.text = "room: %s" % current_room_def.room_path.get_file()
	# neighbors_label.text = "ngbrs: %s" % Log.to_pretty(current_room_def.build_neighbor_data().map(func(n): return n.room_path.get_file()))

	room_entities_label.text = "ents: %s" % Log.to_pretty(current_room_def.entities().map(func(x): return x.get_display_name()))
	room_enemies_label.text = "ents: %s" % Log.to_pretty(current_room_def.enemies().map(func(x): return x.get_display_name()))
	room_tiles_label.text = "tileset: %s" % current_room_def.get_primary_tiles().get_display_name()

func update_edit_entities():
	if not current_room_def:
		return

	var items = []
	items.append_array(current_room_def.entities().map(func(ent):
		return {
			label="Remove '%s'" % ent.get_display_name(),
			on_select=func(): current_room_def.input.entities.erase(ent)
			}))
	items.append_array(DinoEntity.all_entities().map(func(ent):
		return {
			label="Add '%s'" % ent.get_display_name(),
			on_select=func(): current_room_def.input.entities.append(ent)
			}))

	var popup = edit_entities_menu_button.get_popup()
	U.setup_popup_items(popup, items, func(item):
		item.on_select.call()
		game.generator.build_and_prep_scene(current_room_def)
		game.reload_current_room())

func update_edit_enemies():
	if not current_room_def:
		return

	var items = []
	items.append_array(current_room_def.enemies().map(func(en):
		return {
			label="Remove '%s'" % en.get_display_name(),
			on_select=func(): current_room_def.input.enemies.erase(en)
			}))
	items.append_array(DinoEnemy.all_enemies().map(func(en):
		return {
			label="Add '%s'" % en.get_display_name(),
			on_select=func(): current_room_def.input.enemies.append(en)}))

	var popup = edit_enemies_menu_button.get_popup()
	U.setup_popup_items(popup, items, func(item):
		item.on_select.call()
		game.generator.build_and_prep_scene(current_room_def)
		game.reload_current_room())

func update_edit_tilesets():
	if not current_room_def:
		return

	var items = []
	items.append_array(DinoTiles.all_tiles().map(func(tile):
		return {
			label=tile.get_display_name(),
			on_select=func(): current_room_def.input.tiles[0] = tile
			}))

	var popup = edit_tileset_menu_button.get_popup()
	U.setup_popup_items(popup, items, func(item):
		item.on_select.call()
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
	if player:
		if player.has_method("resurrect"):
			player.resurrect()
	Dino.respawn_active_player()
