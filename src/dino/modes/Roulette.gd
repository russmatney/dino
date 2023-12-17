extends Node2D

# TODO support bag-shuffle (tetris)
# TODO queue a list and show next-games in hud (like mario ko arenas)

## vars ##################################################3

# TODO edit via some jumbo-style popup/checklist
# @export var game_ids: Array[DinoGameEntity] = []
@export var game_ids: Array = []
var fb_game_ids = [
	DinoGameEntityIds.SHIRT,
	DinoGameEntityIds.GUNNER,
	DinoGameEntityIds.TOWERJET,
	# DinoGameEntityIds.SUPERELEVATORLEVEL,
	DinoGameEntityIds.THEWOODS,
	DinoGameEntityIds.PLUGGS,
	]

@export var player_entity: DinoPlayerEntity
@export var current_game_entity: DinoGameEntity
var played_game_records = []
var game_node: Node2D

@export var _seed: int
@export var set_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			_seed = randi()

@export var room_count: int = 1
@export var round_num: int = 1

signal round_complete

## ready ##################################################3

func _ready():
	round_complete.connect(_on_round_complete)

	_seed = randi()
	Log.pr("Roulette ready with seed!", _seed)
	seed(_seed)

	if player_entity == null:
		player_entity = Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER)

	start_round(current_game_entity)

## start_round ##################################################3

func next_random_game():
	# PlayedGameRecords maybe a collection that manages this index+filter (and game selection?)
	var played_ids = played_game_records.map(func(x): return x.game_entity.get_entity_id())
	var gs = game_ids.filter(func(g_id): return not g_id in played_ids)
	var eid = U.rand_of(gs)
	if eid:
		var entity = Pandora.get_entity(eid)
		return entity

func start_round(entity=null):
	_seed = randi()
	seed(_seed)
	Log.pr("Roulette starting round with seed:", _seed)
	reset_game_ids()

	if not entity:
		entity = next_random_game()

	if entity:
		launch_game(entity)
		return

	Log.pr("No entity to launch in start_round")

func reset_game_ids():
	if game_ids.filter(func(x): return x).is_empty():
		game_ids = fb_game_ids
	played_game_records = []

func update_game_ids(games):
	current_game_entity = null
	game_ids = games.map(func(e): return e.get_entity_id())

func update_player_entity(ent: DinoPlayerEntity):
	player_entity = ent

## launch_game ##################################################3

func setup_game(node):
	node.ready.connect(_on_game_ready)

	if node.has_signal("level_complete"):
		node.level_complete.connect(_on_level_complete)
	else:
		Log.warn("game node has no 'level_complete' signal!", node)

func launch_game(game_entity):
	current_game_entity = game_entity
	played_game_records.append({game_entity=game_entity})

	Records.start_game({game_entity=game_entity})

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
	# increase difficulty with `round_num`
	var level_opts = {seed=_seed, room_count=room_count,}

	if game_node.has_method("regenerate"):
		game_node.regenerate(level_opts)
	else:
		Log.warn("Game/Level missing expected regenerate function!", game_node)

func _on_level_complete():
	Log.pr("Roulette Level Complete!")

	Records.complete_game({})

	var entity = next_random_game()
	if entity:
		launch_game(entity)
		return # don't emit if we launched a new game

	round_complete.emit()

func _on_round_complete():
	round_num += 1
	Log.pr("Roulette Round Complete!")

	await Jumbotron.jumbo_notif({
		header="Round complete!",
		body="Try a different seed!",
		})

	await Jumbotron.jumbo_notif({
		header="Did you know?",
		body=U.rand_of([
			"You can change the number of rooms in the Pause menu!",
			"You can change the tileset in the Pause menu! (TODO lol)",
			"You can change the tile_size in the Pause menu! I like 16x16!",
			])
		})

	start_round()
