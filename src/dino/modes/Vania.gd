extends Node2D

## vars ##################################################3

var vania_game_scene = preload("res://src/dino/vania/VaniaGame.tscn")

@export var player_entity: DinoPlayerEntity
var game_node: Node2D

@export var set_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			Dino.reseed()

func to_printable():
	if player_entity != null:
		return {
			egg=Dino.egg,
			player=player_entity.get_display_name(),}
	return {egg=Dino.egg}

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
			room_type=DinoData.RoomType.SideScroller,
			entity=player_entity,
			})

	# clear current game if there is one
	if game_node:
		remove_child.call_deferred(game_node)
		game_node.queue_free()

	game_node = vania_game_scene.instantiate()

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
