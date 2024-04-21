extends Node2D

## vars ##################################################3

var vania_game_scene = preload("res://src/dino/vania/VaniaGame.tscn")

var player_entity: DinoPlayerEntity
var enemy_entities
var room_count = 3
var game_node: Node2D

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

	if player_entity == null:
		player_entity = Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER)

	start_game()

## start_game ##################################################3

func start_game():
	Log.pr("Vania game starting:", self)

	# establish current player stack
	if not Dino.current_player_entity():
		Dino.create_new_player({
			genre_type=DinoData.GenreType.SideScroller,
			entity=player_entity,
			})

	# clear current game if there is one
	if game_node:
		remove_child.call_deferred(game_node)
		game_node.queue_free()

	game_node = vania_game_scene.instantiate()

	game_node.room_inputs = initial_room_inputs()

	add_child.call_deferred(game_node)

## room_inputs #################################333

@onready var rain_eff = RoomEffect.new({scene=load("res://src/effects/RainFallParticles.tscn")})
@onready var snow_eff = RoomEffect.new({scene=load("res://src/effects/SnowFallParticles.tscn")})

func initial_room_inputs():
	var inputs = [{
			RoomInputs.HAS_PLAYER: {},
			RoomInputs.HAS_CANDLE: {},
			RoomInputs.HAS_CHECKPOINT: {},
			RoomInputs.IN_SMALL_ROOM: {},
			RoomInputs.HAS_EFFECTS: {effects=[
				snow_eff,
				rain_eff,
				]},
		},
		RoomInputs.random_room().merge_constraint({
			RoomInputs.HAS_EFFECTS: {effects=[
				snow_eff,
				]}
			}),
		RoomInputs.random_room().merge_constraint({
			RoomInputs.HAS_EFFECTS: {effects=[
				rain_eff,
				]}
			})
		]

	inputs.append_array(U.repeat_fn(func():
		var opts = {}
		if enemy_entities != null:
			opts["enemy_entities"] = enemy_entities
		return RoomInputs.random_room(opts)
		, room_count - 1))
	return inputs

## set_player_entity #################################333

func set_player_entity(ent: DinoPlayerEntity):
	player_entity = ent

## set_enemies #################################333

func set_enemy_entities(ents):
	enemy_entities = ents

## set_room_count #################################333

func set_room_count(count: int):
	room_count = count
