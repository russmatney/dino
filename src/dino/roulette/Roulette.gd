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
var current_game: DinoGame

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

	Debug.pr("would start", current_game_entity)

	# TODO load and launch first level (via Game/DinoGame api?)
