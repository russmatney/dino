@tool
extends CanvasLayer

@onready var games_grid_container = $%GamesGridContainer
@onready var players_grid_container = $%PlayersGridContainer
@onready var button_list = $%ButtonList

# TODO convert games grid to list of map_defs
# TODO built menus into pause menu?

var game_entities = []
var selected_game_entities = []
var player_entities = []
var selected_player_entity

## ready ##################################################

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	build_games_grid()
	build_players_grid()
	reset_ui()

	Music.resume_menu_song()
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
		ch.is_selected = ch.entity in selected_game_entities

	for pl in players_grid_container.get_children():
		pl.is_selected = pl.entity == selected_player_entity

## games grid ##################################################

func select_game(game_entity):
	if game_entity in selected_game_entities:
		selected_game_entities.erase(game_entity)
	else:
		selected_game_entities.append(game_entity)

	reset_ui()

func build_games_grid():
	game_entities = DinoGameEntity.basic_game_entities()
	selected_game_entities = game_entities
	U.free_children(games_grid_container)

	for gm in game_entities:
		var button = EntityButton.newButton(gm, select_game)
		games_grid_container.add_child(button)

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

## start game ##################################################

func start():
	if selected_player_entity:
		# TODO probably clear/reset existing player ents
		Dino.create_new_player({entity=selected_player_entity})
		# maybe overlaps with select player/player setup stuff?

	var mode = Dino.get_game_mode()
	var scene
	if mode:
		scene = mode.get_root_scene()
	if not scene:
		Log.warn("Classic menu start found no game mode/scene, using fall back")
		scene = load("res://src/dino/modes/classic/Classic.tscn")
	Navi.nav_to(scene)

## menu buttons ##################################################

func get_menu_buttons():
	return [
		{
			label="Start Classic mode!",
			# is_disabled=func(): return len(selected_game_entities) < 1,
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
