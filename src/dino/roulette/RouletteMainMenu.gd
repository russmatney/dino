@tool
extends CanvasLayer

@onready var games_grid_container = $%GamesGridContainer
@onready var button_list = $%ButtonList

var game_button = preload("res://src/dino/menus/GameButton.tscn")
var game_entities = []
var selected_game_entities = []

## ready ##################################################

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	build_games_grid()
	reset_menu_buttons()

	DJ.resume_menu_song()
	set_focus()

## focus ##################################################

func set_focus():
	var chs = games_grid_container.get_children()
	if len(chs) > 0:
		chs[0].set_focus()

## games grid ##################################################

func select_game(game_entity):
	if game_entity in selected_game_entities:
		selected_game_entities.erase(game_entity)
	else:
		selected_game_entities.append(game_entity)

	reset_menu_buttons()

	for ch in games_grid_container.get_children():
		ch.is_selected = ch.game_entity in selected_game_entities

func build_games_grid():
	game_entities = Game.all_game_entities()
	selected_game_entities = game_entities
	U.free_children(games_grid_container)

	for gm in game_entities:
		var button = game_button.instantiate()
		button.set_game_entity(gm)
		button.icon_pressed.connect(func(): select_game(gm))
		games_grid_container.add_child(button)

## start game ##################################################

var roulette_scene = "res://src/dino/roulette/Roulette.tscn"
func start_with_games(ents):
	Navi.nav_to(roulette_scene, {setup=func(scene):
		scene.game_ids = ents.map(func(e): return e.get_entity_id())})

## menu buttons ##################################################

func get_menu_buttons():
	return [
		{
			label="Start with %d games!" % len(selected_game_entities),
			is_disabled=func(): return len(selected_game_entities) < 1,
			fn=func(): start_with_games(selected_game_entities),
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
