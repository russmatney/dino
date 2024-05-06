@tool
extends CanvasLayer

@onready var map_defs_container = $%MapDefGridContainer
@onready var players_grid_container = $%PlayersGridContainer

@onready var button_list = $%ButtonList

var map_defs = []
var selected_map_def
var player_entities = []
var selected_player_entity

## ready ##################################################

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	build_players_grid()
	build_map_def_grid()
	reset_ui()

	Music.resume_menu_song()
	set_focus()

## focus ##################################################

func set_focus():
	var chs = players_grid_container.get_children()
	if len(chs) > 0:
		chs[0].set_focus()

## reset ui ##################################################

func reset_ui():
	reset_menu_buttons()

	for butt in players_grid_container.get_children():
		butt.is_selected = butt.entity == selected_player_entity

	for butt in map_defs_container.get_children():
		butt.button_pressed = butt.text == selected_map_def.name

## players grid ##################################################

func select_player(player_entity):
	selected_player_entity = player_entity
	reset_ui()

func build_players_grid():
	player_entities = DinoPlayerEntity.all_entities()
	selected_player_entity = player_entities[0]
	U.free_children(players_grid_container)

	for pl in player_entities:
		var button = EntityButton.newButton(pl, select_player)
		players_grid_container.add_child(button)

## map_def grid ##################################################

func select_map_def(map_def):
	selected_map_def = map_def
	reset_ui()

func build_map_def_grid():
	map_defs = MapDef.all_map_defs()
	selected_map_def = map_defs[0]
	U.free_children(map_defs_container)

	for def in map_defs:
		var button = Button.new()
		button.toggle_mode = true
		button.text = def.name
		button.pressed.connect(func(): select_map_def(def))
		map_defs_container.add_child(button)

## start game ##################################################

var vania_scene = preload("res://src/dino/modes/Vania.tscn")
func start():
	Navi.nav_to(vania_scene, {setup=func(scene):
		scene.set_player_entity(selected_player_entity)
		if selected_map_def:
			scene.set_map_def(selected_map_def)
		})

## menu buttons ##################################################

func get_menu_buttons():
	return [
		{
			label="Start DinoVania!",
			fn=start,
		},
		{
			label="Back to Dino Menu",
			fn=Navi.nav_to_main_menu,
			hide_fn=func(): return not (OS.has_feature("dino") or OS.has_feature("editor")),
		},
	]

func reset_menu_buttons():
	var items = get_menu_buttons()
	button_list.set_menu_items(items)
