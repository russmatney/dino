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
var game_node: Node2D

@export var _seed: int
@export var set_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			_seed = randi()

@export var room_count: int = Util.rand_of(range(1,4))

## ready ##################################################3

func _ready():
	_seed = randi()
	Debug.pr("Arcade ready with seed!", _seed)
	seed(_seed)

	var entity = current_game_entity
	if not entity:
		entity = select_game()

	if not entity:
		Debug.warn("Could not find game_entity!")
	else:
		Debug.pr("Launching", entity.get_display_name())
		launch_game(entity)

## select a game ##################################################3

func select_game():
	var eid = Util.rand_of(game_ids)
	var entity = Pandora.get_entity(eid)
	return entity

## launch game ##################################################3

func setup_game(node):
	node.ready.connect(_on_game_ready)

	if node.has_signal("level_complete"):
		node.level_complete.connect(_on_level_complete)
	else:
		Debug.warn("game node has no 'level_complete' signal!", node)

func launch_game(entity):
	current_game_entity = entity

	if game_node:
		game_node.queue_free()

	Game.launch_in_game_mode(self, entity)

	var scene = entity.get_first_level_scene()
	game_node = scene.instantiate()
	setup_game(game_node)

	add_child(game_node)

## game level signals ##################################################3

func _on_game_ready():
	var level_opts = {seed=_seed, room_count=room_count,}

	if game_node.has_method("regenerate"):
		game_node.regenerate(level_opts)
	else:
		Debug.warn("Game/Level missing expected regenerate function!", game_node)

func _on_level_complete():
	_seed = randi()
	await get_tree().create_timer(1.0).timeout
	Hood.notif("Loading next level....")
	_on_game_ready()
