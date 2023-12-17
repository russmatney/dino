extends Node2D

## vars ##################################################3

# TODO more games, and pull these from pandora
var game_ids = [
	DinoGameEntityIds.SUPERELEVATORLEVEL,
	DinoGameEntityIds.SHIRT,
	DinoGameEntityIds.GUNNER,
	DinoGameEntityIds.TOWERJET,
	DinoGameEntityIds.THEWOODS,
	DinoGameEntityIds.PLUGGS,
	]

@export var current_game_entity: DinoGameEntity
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
	_seed = randi()
	Log.pr("Arcade ready with seed!", _seed)
	seed(_seed)

	var game_entity = current_game_entity
	if not game_entity:
		game_entity = random_game()

	if player_entity == null:
		player_entity = Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER)

	if not game_entity:
		Log.warn("Could not find game_entity!")
	else:
		Log.pr("Launching", game_entity.get_display_name())
		launch_game(game_entity)

## select a game ##################################################3

func random_game():
	var eid = U.rand_of(game_ids)
	var game_entity = Pandora.get_entity(eid)
	return game_entity

## launch game ##################################################3

func setup_game(node):
	node.ready.connect(_on_game_ready)

	if node.has_signal("level_complete"):
		node.level_complete.connect(_on_level_complete)
	else:
		Log.warn("game node has no 'level_complete' signal!", node)

func launch_game(game_entity=null):
	if game_entity == null:
		game_entity = current_game_entity
	current_game_entity = game_entity

	if game_node:
		remove_child.call_deferred(game_node)
		game_node.queue_free()

	Dino.setup_player({
		type=DinoData.to_game_type(game_entity.get_player_type()),
		entity=player_entity,
		})

	var scene = game_entity.get_first_level_scene()
	game_node = scene.instantiate()
	setup_game(game_node)

	add_child.call_deferred(game_node)

## game level signals ##################################################3

func _on_game_ready():
	var level_opts = {seed=_seed, room_count=room_count,}

	if game_node.has_method("regenerate"):
		game_node.regenerate(level_opts)
	else:
		Log.warn("Game/Level missing expected regenerate function!", game_node)

func _on_level_complete():
	_seed = randi()
	await get_tree().create_timer(1.0).timeout
	Hood.notif("Loading next level....")
	launch_game()
