@tool
extends CanvasLayer

@onready var games_grid_container = $%GamesGridContainer
@onready var players_grid_container = $%PlayersGridContainer
@onready var button_list = $%ButtonList

var game_button = preload("res://src/dino/menus/GameButton.tscn")
var game_entities = []
var selected_game_entities = []

var player_button = preload("res://src/dino/menus/PlayerButton.tscn")
var player_entities = []
var selected_player_entity

## ready ##################################################

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	build_games_grid()
	build_players_grid()
	reset_ui()

	DJ.resume_menu_song()
	set_focus()

## focus ##################################################

func set_focus():
	var chs = games_grid_container.get_children()
	if len(chs) > 0:
		chs[0].set_focus()

## reset ui ##################################################

func reset_ui():
	reset_menu_buttons()

	for ch in games_grid_container.get_children():
		ch.is_selected = ch.game_entity in selected_game_entities

	for pl in players_grid_container.get_children():
		pl.is_selected = pl.player_entity == selected_player_entity

## games grid ##################################################

func select_game(game_entity):
	if game_entity in selected_game_entities:
		selected_game_entities.erase(game_entity)
	else:
		selected_game_entities.append(game_entity)

	reset_ui()

func build_games_grid():
	game_entities = Game.all_game_entities()
	selected_game_entities = game_entities
	U.free_children(games_grid_container)

	for gm in game_entities:
		var button = game_button.instantiate()
		button.set_game_entity(gm)
		button.icon_pressed.connect(func(): select_game(gm))
		games_grid_container.add_child(button)

## players grid ##################################################

func select_player(player_entity):
	selected_player_entity = player_entity
	reset_ui()

func build_players_grid():
	player_entities = P.all_player_entities()
	selected_player_entity = player_entities[0]
	U.free_children(players_grid_container)

	for pl in player_entities:
		var button = player_button.instantiate()
		button.set_player_entity(pl)
		button.icon_pressed.connect(func(): select_player(pl))
		players_grid_container.add_child(button)

## start game ##################################################

var roulette_scene = preload("res://src/dino/modes/Roulette.tscn")
func start():
	Navi.nav_to(roulette_scene, {setup=func(scene):
		scene.update_game_ids(selected_game_entities)
		scene.update_player_entity(selected_player_entity)
		})

## menu buttons ##################################################

func get_menu_buttons():
	return [
		{
			label="Start with %d games!" % len(selected_game_entities),
			is_disabled=func(): return len(selected_game_entities) < 1,
			fn=start,
		},
		{
			label="Deselect all",
			fn=func():
			selected_game_entities = []
			reset_ui.call_deferred(),
			is_disabled=func(): return len(selected_game_entities) == 0,
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