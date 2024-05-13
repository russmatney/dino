extends Node2D

## vars ##################################################3

# TODO more games, and pull these from pandora
var game_ids = [
	LevelDefIds.SUPERELEVATORLEVEL,
	LevelDefIds.SHIRT,
	LevelDefIds.TOWER,
	LevelDefIds.WOODS,
	]

@export var current_def: LevelDef
@export var player_entity: DinoPlayerEntity
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
		def = random_game()

	if player_entity == null:
		player_entity = Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER)

	if not def:
		Log.warn("Could not find def!")
	else:
		launch_game(def)

## select a game ##################################################3

func random_game():
	var eid = U.rand_of(game_ids)
	var level_def = Pandora.get_entity(eid)
	return level_def

## launch game ##################################################3

func launch_game(def=null):
	if def == null:
		def = current_def
	current_def = def

	if game_node:
		remove_child.call_deferred(game_node)
		game_node.queue_free()
		await game_node.tree_exited

	if not Dino.current_player_entity():
		Dino.create_new_player({entity=player_entity})

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
