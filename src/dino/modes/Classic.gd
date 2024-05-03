extends Node2D

## vars ##################################################3

@export var player_entity: DinoPlayerEntity
var game_node: Node2D

@export var _seed: int
@export var set_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			_seed = randi()

@export var round_num: int = 0
@export var stage_num: int = 0
var current_level_def: LevelDef

signal round_complete
signal game_complete

var round_defs = [[
		LevelDefIds.LEAFRUNNER,
		LevelDefIds.WILDCARD,
	], [
		LevelDefIds.BREAKTHETARGETS,
	# ], [
	# TODO polygon team! beat up a car! giant hario!
	], [
		LevelDefIds.BOSSBATTLE
	],
	]

## ready ##################################################3

func _ready():
	Dino.set_game_mode(Pandora.get_entity(ModeIds.CLASSIC))
	Dino.notif({type="banner", text="Classic",})

	round_complete.connect(_on_round_complete)
	game_complete.connect(_on_game_complete)

	if player_entity == null:
		player_entity = Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER)

	start_game()

## start_game ##################################################3

func start_game():
	_seed = randi()
	seed(_seed)
	reset_data()

	var level_def = next_level_def()

	if level_def:
		launch_level(level_def)
		return

	Log.warn("No level_def to launch in start_game")

func next_level_def():
	var level_id
	if round_num <= len(round_defs) - 1:
		var stages = round_defs[round_num]
		if stage_num <= len(stages) - 1:
			level_id = stages[stage_num]
		else:
			# right place?
			round_complete.emit()

			round_num += 1
			stage_num = 0
			return next_level_def()

	if level_id:
		return Pandora.get_entity(level_id)

func reset_data():
	stage_num = 0
	round_num = 0

## set_player_entity #################################333

# presumably from a menu somewhere
func set_player_entity(ent: DinoPlayerEntity):
	player_entity = ent

## launch_game ##################################################3

func launch_level(level_def):
	current_level_def = level_def

	if game_node:
		remove_child.call_deferred(game_node)
		game_node.queue_free()
		await game_node.tree_exited

	if not Dino.current_player_entity():
		Dino.create_new_player({entity=player_entity})

	game_node = DinoLevel.create_level(level_def, {seed=_seed, })
	add_child(game_node)

	Dino.spawn_player({level=game_node, deferred=false,
		genre_type=level_def.get_genre_type(),
		})

	game_node.level_complete.connect(_on_level_complete)

## game level signals ##################################################3

func _on_level_complete():
	Dino.notif({type="banner", text="Level Complete",})
	stage_num += 1

	var def = next_level_def()
	if def:
		launch_level(def)
	else:
		game_complete.emit()

func _on_round_complete():
	Dino.notif({type="banner", text="Round Complete",})
	await Jumbotron.jumbo_notif({
		header="Round complete!",
		body="Wowie zowie!",
		})

func _on_game_complete():
	Dino.notif({type="banner", text="Game Complete",})

	# TODO nav to high scores / credits
	Navi.nav_to_main_menu()
