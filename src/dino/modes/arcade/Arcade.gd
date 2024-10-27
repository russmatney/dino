extends Node2D

## vars ##################################################3

@export var current_def: LevelDef

var game_node: Node2D

@export var _seed: int
@export var set_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			_seed = randi()

@export var room_count: int = U.rand_of(range(1,4))

## ready ##################################################3

func _ready():
	Dino.set_game_mode(Pandora.get_entity(ModeIds.ARCADE))
	Dino.notif({
		type="banner",
		text="Arcade",
		})

	_seed = randi()
	seed(_seed)

	var def = current_def
	if not def:
		def = LevelDef.random_def()
		Log.pr("no current LevelDef, getting random game", def)

	if not def:
		Log.warn("Could not find def!")
	else:
		launch_game(def)

## launch game ##################################################3

func launch_game(def=null):
	if def == null:
		def = current_def
	current_def = def

	if game_node:
		remove_child.call_deferred(game_node)
		game_node.queue_free()
		await game_node.tree_exited

	var level_opts = {seed=_seed, room_count=room_count,}

	game_node = DinoLevel.create_level(def, level_opts)

	add_child(game_node)

	if game_node.has_signal("level_complete"):
		game_node.level_complete.connect(_on_level_complete)
	else:
		Log.warn("game node has no 'level_complete' signal!", game_node)

## game level signals ##################################################3

func _on_level_complete():
	_seed = randi()
	await get_tree().create_timer(1.0).timeout
	Debug.notif("Loading next level....")
	launch_game()
