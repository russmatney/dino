extends Node2D

## data ##################################################3

@onready var topdown_game = MapDef.new({
	name="TopDown Game",
	inputs=(func():
	var inputs = [
		RoomInput.merge_many([
			RoomInput.topdown(),
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.PLAYERSPAWNPOINT,
			]}),
			RoomInput.small_room_shape(),
			RoomInput.has_effects({effects=[
				RoomEffect.dust(),
			]}),
		]),
		MapDef.harvey_room(),
	]
	inputs.append_array(U.repeat_fn(func():
		return RoomInput.random_room().merge(RoomInput.topdown()),
		3))
	return inputs
	).call()})

@onready var mixed_genre_game = MapDef.new({
	name="Mixed Genre Game",
	inputs=(func():
	var inputs = [
		RoomInput.merge_many([
			RoomInput.topdown(),
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.PLAYERSPAWNPOINT,
			]}),
			RoomInput.small_room_shape(),
			RoomInput.has_effects({effects=[
				RoomEffect.dust(),
			]}),
		]),
		RoomInput.merge_many([
			RoomInput.sidescroller(),
			RoomInput.small_room_shape(),
		]),
	]
	return inputs
	).call()})

@onready var default_game = MapDef.new({
	name="Vania",
	inputs=(func():
	var inputs = [
		RoomInput.merge_many([
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.PLAYERSPAWNPOINT,
				DinoEntityIds.CANDLE,
				DinoEntityIds.HANGINGLIGHT,
				DinoEntityIds.BUSH2,
			]}),
			RoomInput.small_room_shape(),
			RoomInput.has_effects({effects=[
				RoomEffect.snow_fall(),
				RoomEffect.rain_fall(),
			]}),
		]),
		RoomInput.merge_many([
			RoomInput.random_room(),
			RoomInput.has_effects({effects=[
				RoomEffect.snow_fall(),
			]}),
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.HANGINGLIGHT,
				DinoEntityIds.BUSH1,
			]}),
		]),
		RoomInput.merge_many([
			RoomInput.random_room(),
			RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.HANGINGLIGHT,
				DinoEntityIds.BUSH1,
				DinoEntityIds.BUSH2,
			]}),
		]),
		MapDef.cooking_room(),
	]
	inputs.append_array(U.repeat_fn(RoomInput.random_room, 3))
	return inputs
	).call()})

@onready var tower_game = MapDef.new({
	name="Tower",
	inputs=[
		RoomInput.merge_many([
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.PLAYERSPAWNPOINT,
				DinoEntityIds.TARGET,
				DinoEntityIds.TARGET,
				DinoEntityIds.TARGET,
			]}),
			RoomInput.wide_room_shape(),
			RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
		]),
		RoomInput.merge_many([
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.TARGET,
				DinoEntityIds.TARGET,
				DinoEntityIds.TARGET,
			]}),
			RoomInput.large_room_shape(),
			RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
		]),
		RoomInput.merge_many([
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.TARGET,
				DinoEntityIds.TARGET,
				DinoEntityIds.TARGET,
			]}),
			RoomInput.tall_room_shape(),
			RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
		]),
	]})

@onready var woods_game = MapDef.new({
	name="Woods",
	inputs=[
		RoomInput.merge_many([
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.PLAYERSPAWNPOINT,
				DinoEntityIds.LEAF,
				DinoEntityIds.LEAF,
				DinoEntityIds.LEAF,
			]}),
			RoomInput.wide_room_shape(),
			RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
		]),
		RoomInput.merge_many([
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.LEAF,
				DinoEntityIds.LEAF,
				DinoEntityIds.LEAF,
			]}),
			RoomInput.large_room_shape(),
			RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
		]),
		RoomInput.merge_many([
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.LEAF,
				DinoEntityIds.LEAF,
				DinoEntityIds.LEAF,
				DinoEntityIds.LEAFGOD,
			]}),
			RoomInput.tall_room_shape(),
			RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
		]),
	]})

@onready var arcade_game = MapDef.new({
	name="Arcade",
	inputs=[
		RoomInput.merge_many([
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.PLAYERSPAWNPOINT,
				DinoEntityIds.COIN,
				DinoEntityIds.COIN,
				DinoEntityIds.COIN,
				DinoEntityIds.ARCADEMACHINE,
			]}),
			RoomInput.wide_room_shape(),
			RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
		]),
		RoomInput.merge_many([
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.COIN,
				DinoEntityIds.COIN,
				DinoEntityIds.COIN,
				DinoEntityIds.ARCADEMACHINE,
			]}),
			RoomInput.large_room_shape(),
			RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
		]),
		RoomInput.merge_many([
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.COIN,
				DinoEntityIds.COIN,
				DinoEntityIds.COIN,
				DinoEntityIds.ARCADEMACHINE,
			]}),
			RoomInput.tall_room_shape(),
			RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
		]),
	]})

## vars ##################################################3

var vania_game_scene = preload("res://src/dino/vania/VaniaGame.tscn")

var player_entity: DinoPlayerEntity
var game_node: Node2D
var selected_map_def: MapDef

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

	if not selected_map_def:
		# selected_map_def = arcade_game
		# selected_map_def = topdown_game
		# selected_map_def = default_game
		selected_map_def = mixed_genre_game

	game_node.map_def = selected_map_def

	add_child.call_deferred(game_node)

## set_player_entity #################################333

func set_player_entity(ent: DinoPlayerEntity):
	player_entity = ent
