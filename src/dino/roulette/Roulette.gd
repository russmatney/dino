extends Node2D

# TODO support bag-shuffle (tetris)
# TODO queue a list and show next-games in hud (like mario ko arenas)

## vars ##################################################3

# TODO edit via some jumbo-style popup/checklist
# @export var game_ids: Array[DinoGameEntity] = []
@export var game_ids: Array = []
var fb_game_ids = [
	# DinoGameEntityIds.SHIRT,
	DinoGameEntityIds.GUNNER,
	# DinoGameEntityIds.TOWERJET,

	# DinoGameEntityIds.SUPERELEVATORLEVEL,
	# DinoGameEntityIds.THEWOODS,
	# DinoGameEntityIds.PLUGGS,
	]

@export var current_game_entity: DinoGameEntity
var played_game_records = []
var game_node: Node2D

@export var _seed: int
@export var set_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			_seed = randi()

@export var room_count: int = 1

signal round_complete

## ready ##################################################3

func _ready():
	if game_ids.filter(func(x): return x).is_empty():
		game_ids = fb_game_ids

	round_complete.connect(_on_round_complete)

	_seed = randi()
	Debug.pr("Roulette ready with seed!", _seed)
	seed(_seed)

	var entity = current_game_entity
	if not entity:
		entity = next_random_game()
	played_game_records.append({entity=entity})

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
		var played_ids = played_game_records.map(func(x): return x.entity.get_entity_id())
		gs = game_ids.filter(func(g_id): return not g_id in played_ids)
	else:
		gs = game_ids

	if current_game_entity:
		Debug.pr("selecting game from gids", gs, "excluding current", current_game_entity.get_entity_id())
	else:
		Debug.pr("selecting game from gids", gs)

	var eid = Util.rand_of(gs)
	if eid:
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
		remove_child(game_node)
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
	var record = played_game_records[len(played_game_records) - 1]

	record["completed_at"] = Time.get_datetime_dict_from_system()
	Debug.pr("Roulette Level Complete!")

	var entity = next_random_game()
	if entity:
		launch_game(entity)

	round_complete.emit()

func _on_round_complete():
	await Q.jumbo_notif({
		header="Round complete!",
		body="Try a different seed!",
		})

	await Q.jumbo_notif({
		header="Did you know?",
		body=Util.rand_of([
			"You can change the number of rooms in the Pause menu!",
			"You can change the tileset in the Pause menu! (TODO lol)",
			"You can change the tile_size in the Pause menu! I like 16x16!",
			])
		})
	_seed = randi()
