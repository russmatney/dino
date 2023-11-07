extends Node2D

## vars ##################################################3

var games = [
	# TODO more games, and pull this into pandora
	DinoGameEntityIds.SUPERELEVATORLEVEL,
	DinoGameEntityIds.SHIRT,
	DinoGameEntityIds.GUNNER,
	DinoGameEntityIds.TOWERJET,
	DinoGameEntityIds.THEWOODS,
	DinoGameEntityIds.PLUGGS,
	]

@export var current_game_entity: DinoGameEntity
# var current_game: DinoGame
var current_game_node: Node2D

@export var _seed: int
@export var set_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			_seed = randi()

## ready ##################################################3

func _ready():
	Debug.pr("Roulette ready with seed!", _seed)
	seed(_seed)

	if not current_game_entity:
		# TODO offer menu to pick one
		var eid = Util.rand_of(games)
		current_game_entity = Pandora.get_entity(eid)

	if not current_game_entity:
		Debug.warn("Could not find current_game_entity!")

	Debug.pr("would start", current_game_entity.get_display_name())

	# TODO transition plan!
	current_game_node = Game.launch_in_game_mode(self, current_game_entity, {seed=_seed})
	current_game_node.ready.connect(_on_game_ready)
	# TODO levels should transition in/out smoothly
	add_child(current_game_node)

## on game ready ##################################################3

func _on_game_ready():
	Game.maybe_spawn_player()
