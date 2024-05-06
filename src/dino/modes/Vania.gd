extends Node2D

## data ##################################################3


## vars ##################################################3

var vania_game_scene = preload("res://src/dino/vania/VaniaGame.tscn")

var player_entity: DinoPlayerEntity
var game_node: Node2D
var map_def: MapDef

@export var set_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			Dino.reseed()

func to_printable():
	if player_entity != null:
		return {
			_seed=Dino._seed,
			player=player_entity.get_display_name(),}
	return {_seed=Dino._seed}

## ready ##################################################3

func _ready():
	Dino.set_game_mode(Pandora.get_entity(ModeIds.VANIA))
	Dino.notif({type="banner", text="Vania",})

	if player_entity == null:
		player_entity = Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER)

	start_game()

## start_game ##################################################3

func start_game():
	# establish current player stack
	if not Dino.current_player_entity():
		Dino.create_new_player({entity=player_entity})

	# clear current game if there is one
	if game_node:
		remove_child.call_deferred(game_node)
		game_node.queue_free()

	game_node = vania_game_scene.instantiate()

	if not map_def:
		map_def = MapDef.mixed_genre_game()
		# map_def = MapDef.arcade_game()
		# map_def = MapDef.topdown_game()
		# map_def = MapDef.default_game()
		# map_def = MapDef.village()

	game_node.map_def = map_def

	add_child.call_deferred(game_node)

## set_player_entity #################################333

func set_player_entity(ent: DinoPlayerEntity):
	player_entity = ent
