extends Node2D

# TODO support bag-shuffle (tetris)
# TODO queue a list and show next-games in hud (like mario ko arenas)

## vars ##################################################3

var game_ids = [
	# TODO more games, and pull this into pandora
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
	Debug.pr("Roulette ready with seed!", _seed)
	seed(_seed)

	var entity = current_game_entity
	if not entity:
		# TODO popup pause menu when no current game to let player select one
		entity = next_random_game()

	if not entity:
		Debug.warn("Could not find game_entity!")
	else:
		Debug.pr("Launching", entity.get_display_name())
		launch_game(entity)

## next random game ##################################################3

func next_random_game():
	var id
	if current_game_entity:
		id = current_game_entity.get_entity_id()

	var gs
	if id:
		gs = game_ids.filter(func(g): return g != id)
	else:
		gs = game_ids

	var eid = Util.rand_of(gs)
	var entity = Pandora.get_entity(eid)
	return entity

## launch game ##################################################3

func launch_game(entity):
	current_game_entity = entity

	if game_node:
		# TODO games/levels should transition OUT smoothly
		# TODO save any stats/metrics?
		remove_child(game_node)

	Game.launch_in_game_mode(self, entity, )

	var scene = entity.get_first_level_scene()
	game_node = scene.instantiate()

	game_node.ready.connect(_on_game_ready)


	if game_node.has_signal("level_complete"):
		game_node.level_complete.connect(_on_level_complete)
	else:
		Debug.warn("game node has no 'level_complete' signal!", game_node)

	# TODO games/levels should transition IN smoothly
	add_child(game_node)

## game level signals ##################################################3

func _on_game_ready():
	var level_opts = {seed=_seed, room_count=room_count,}

	if game_node.has_method("regenerate"):
		game_node.regenerate(level_opts)
		Debug.pr("awaiting regeneration")
		await game_node.regeneration_complete
		Debug.pr("regeneration complete")

	# what player opts to pass? hud/cam/misc other state?
	Game.respawn_player({player_scene=current_game_entity.get_player_scene()})


func _on_level_complete():
	var entity = next_random_game()
	launch_game(entity)
