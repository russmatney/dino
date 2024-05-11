extends Node2D

## vars ##################################################3

@export var player_entity: DinoPlayerEntity
@export var map_def: MapDef

var game_node: Node2D

@export var set_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			Dino.reseed()

signal game_complete

## to_pretty ##################################################3

func to_pretty():
	return [player_entity, map_def]

## ready ##################################################3

func _ready():
	Dino.set_game_mode(Pandora.get_entity(ModeIds.VANIA))
	Dino.notif({type="banner", text="Vania",})

	game_complete.connect(_on_game_complete)

	# TODO the menus should create the player entity themselves
	# instead of relying on some api to pass it in

	# this supports running classic directly (not from the setup menu)
	# TODO pop up the select-character menu directly
	if not Engine.is_editor_hint():
		if not Dino.current_player_entity():
			if player_entity == null:
				player_entity = Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER)
			Dino.create_new_player({entity=player_entity})

		start_game()

## start_game ##################################################3

func start_game():
	# establish current player stack
	if not Dino.current_player_entity():
		Dino.create_new_player({entity=player_entity})

	# clear current game if there is one
	if game_node:
		remove_child.call_deferred(game_node)
		game_node.queue_free()

	if not map_def:
		map_def = MapDef.mixed_genre_game()
		# map_def = MapDef.arcade_game()
		# map_def = MapDef.topdown_game()
		# map_def = MapDef.default_game()
		# map_def = MapDef.village()

	game_node = VaniaGame.create_game_node(map_def)

	add_child.call_deferred(game_node)

	game_node.level_complete.connect(_on_level_complete)

## set #################################333

func set_map_def(def: MapDef):
	map_def = def

func _on_level_complete():
	Dino.notif({type="banner", text="Level Complete",})

	# TODO slow-mo, score screen with awards/progress/stats
	# (quest data, misc fun ideas ('fighter stance': 500 pts))

	# var def = next_level_def()
	# if def:
	# 	launch_level(def)
	# else:

	game_complete.emit()

func _on_game_complete():
	Dino.notif({type="banner", text="Game Complete",})

	# TODO win menu instead of forced nav
	# show high scores, stats, button for credits, main-menu, replay new seed
	Navi.nav_to_main_menu()
