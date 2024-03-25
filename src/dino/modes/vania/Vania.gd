extends Node2D

## vars ##################################################3

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

	if not Dino.current_player_entity():
		Dino.create_new_player({
			game_type=DinoData.GameType.SideScroller,
			entity=player_entity,
			})

	if game_node:
		remove_child.call_deferred(game_node)
		game_node.queue_free()

	var level_def = Pandora.get_entity(LevelDefIds.BOSSBATTLE)
	game_node = DinoLevel.create_level(level_def)
	game_node.ready.connect(_on_game_ready)
	game_node.level_complete.connect(_on_level_complete)

	add_child.call_deferred(game_node)


## setup_player_entity #################################333

# presumably from a menu somewhere
func setup_player_entity(ent: DinoPlayerEntity):
	player_entity = ent

## game level signals ##################################################3

func _on_game_ready():
	# increase difficulty with `round_num`
	var level_opts = {seed=_seed, }

	if game_node.has_method("regenerate"):
		game_node.regenerate(level_opts)
	else:
		Log.warn("Game/Level missing expected regenerate function!", game_node)

func _on_level_complete():
	Log.pr("Level Complete!")
	await Jumbotron.jumbo_notif({
		header="Level complete!",
		body="Wowie zowie!",
		})

	Navi.nav_to_main_menu()
