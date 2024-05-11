@tool
extends Node2D

## vars ##################################################3

@export var player_entity: DinoPlayerEntity
var game_node: Node2D

@export var _seed: int
@export var set_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			_seed = randi()

var current_level_def: LevelDef

signal game_complete

@export var level_defs: Array[LevelDef]

## to_pretty #################################################

func to_pretty():
	return [_seed, current_level_def, level_defs]

## ready ##################################################3

func _ready():
	Dino.set_game_mode(Pandora.get_entity(ModeIds.CLASSICSS))
	Dino.notif({type="banner", text="Classic Mode",})

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
	reset_data()

	var level_def = next_level_def()

	if level_def:
		launch_level(level_def)
		return

	Log.warn("No level_def to launch in start_game")

# return null if there are no more level defs
func next_level_def():
	var idx = level_defs.find(current_level_def)
	idx += 1
	if idx < len(level_defs):
		return level_defs[idx]

# supports restarting from the beginning
func reset_data():
	current_level_def = null

## launch_game ##################################################3

func launch_level(level_def):
	current_level_def = level_def

	if game_node:
		remove_child.call_deferred(game_node)
		game_node.queue_free()
		await game_node.tree_exited

	game_node = DinoLevel.create_level(level_def, {seed=_seed, })
	add_child(game_node)

	Dino.spawn_player({level=game_node,
		deferred=false,
		genre_type=level_def.get_genre_type(),
		})

	game_node.level_complete.connect(_on_level_complete)

## game level signals ##################################################3

func _on_level_complete():
	Dino.notif({type="banner", text="Level Complete",})

	# TODO slow-mo, score screen with awards/progress/stats
	# (quest data, misc fun ideas ('fighter stance': 500 pts))

	var def = next_level_def()
	if def:
		launch_level(def)
	else:
		game_complete.emit()

func _on_game_complete():
	Dino.notif({type="banner", text="Game Complete",})

	# TODO win menu instead of forced nav
	# show high scores, stats, button for credits, main-menu, replay new seed
	Navi.nav_to_main_menu()
