extends Node2D

## vars ##################################################3

var vania_game_scene = preload("res://src/dino/modes/vania/VaniaGame.tscn")

@export var player_entity: DinoPlayerEntity
var game_node: Node2D

@export var _seed: int
@export var set_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			_seed = randi()

func to_printable():
	if player_entity != null:
		return {
			seed=_seed,
			player=player_entity.get_display_name(),}
	return {seed=_seed}

## ready ##################################################3

func _ready():
	Dino.set_game_mode(Pandora.get_entity(ModeIds.VANIA))

	if player_entity == null:
		player_entity = Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER)

	start_game()

## start_game ##################################################3

func start_game():
	_seed = randi()
	seed(_seed)
	Log.pr("Vania game starting with seed:", self)

	# establish current player stack
	if not Dino.current_player_entity():
		Dino.create_new_player({
			game_type=DinoData.GameType.SideScroller,
			entity=player_entity,
			})

	# clear current game if there is one
	if game_node:
		remove_child.call_deferred(game_node)
		game_node.queue_free()

	# setup level
	var level_def = Pandora.get_entity(LevelDefIds.BOSSBATTLE)
	var level_opts = {seed=_seed, skip_splash_intro=true}
	var level_node = DinoLevel.create_level(level_def, level_opts)

	Log.pr("level node", level_node)
	Log.pr("level node get spawn point", U.first_node_in_group(level_node, "player_spawn_points"))

	Dino.spawn_player({level_node=level_node, deferred=false})

	level_node.level_complete.connect(_on_level_complete)

	game_node = vania_game_scene.instantiate()
	game_node.add_level(level_node, level_def, level_opts)

	add_child.call_deferred(game_node)


## setup_player_entity #################################333

# presumably from a menu somewhere
func setup_player_entity(ent: DinoPlayerEntity):
	player_entity = ent

## game level signals ##################################################3

func _on_level_complete():
	Log.pr("Level Complete!")
	await Jumbotron.jumbo_notif({
		header="Level complete!",
		body="Wowie zowie!",
		})

	Navi.nav_to_main_menu()
