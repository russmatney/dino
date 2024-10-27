@tool
extends CanvasLayer

@onready var games_grid_container = $%GamesGridContainer
@onready var button_list = $%ButtonList

var game_entities = []
var selected_game_entity

## ready ##################################################

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	build_games_grid()
	reset_menu_buttons()

	Music.resume_menu_song()
	set_focus()

## focus ##################################################

func set_focus():
	var chs = games_grid_container.get_children()
	if len(chs) > 0:
		chs[0].set_focus()

## games grid ##################################################

func select_game(game_entity):
	Log.pr("selecting game", game_entity)
	selected_game_entity = game_entity
	reset_menu_buttons()

	for ch in games_grid_container.get_children():
		ch.is_selected = ch.entity == selected_game_entity

func build_games_grid():
	game_entities = DinoGameEntity.basic_game_entities()
	U.free_children(games_grid_container)

	for gm in game_entities:
		var button = EntityButton.newButton(gm, select_game)
		games_grid_container.add_child(button)

## start game ##################################################

var arcade_scene = preload("res://src/dino/modes/arcade/Arcade.tscn")
func start_arcade_with_game(ent):
	Log.pr("Starting arcade w/ game", ent)

	Dino.set_game_mode(Pandora.get_entity(ModeIds.ARCADE))
	Dino.ensure_player_setup({genre=ent.get_genre_type()})

	if ent is DinoGameEntity:
		Navi.nav_to(ent.get_level_scene(), {
			on_ready=func(node):
			# TODO bake-in this level_node knowledge to Dino somehow? track a current_root_node?
			Dino.spawn_player({level_node=node})
			})
	elif ent is LevelDef:
		Navi.nav_to(arcade_scene, {setup=func(scene):
			if "current_game_entity" in scene:
				scene.current_game_entity = ent
			else:
				Log.warn("skipping current_game_entity assignment", ent)
			})
	else:
		Log.warn("unhandled game entity", ent)

## menu buttons ##################################################

func get_menu_buttons():
	return [
		{
			label="Start %s!" % selected_game_entity.get_display_name() if selected_game_entity else "Select a game",
			is_disabled=func(): return selected_game_entity == null,
			fn=func(): start_arcade_with_game(selected_game_entity),
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
