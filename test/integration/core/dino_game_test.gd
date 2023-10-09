extends GutTest

func test_registered_games():
	var game_ents = Game.all_game_entities()

	assert_gt(len(game_ents), 0)
	for ent in game_ents:
		assert_not_null(ent)
		assert_ne(ent.get_display_name(), "")
		# assert_not_null(ent.get_singleton(), "%s missing singleton" % ent.get_display_name())

func test_ensure_current_game():
	assert_null(Game.current_game)
	Game.ensure_current_game()
	assert_null(Game.current_game)

	# first level of hatbot
	var scene = load("res://src/hatbot/zones/LevelZero.tscn")
	var inst = scene.instantiate()

	# load/setup scene/inst
	get_tree().get_root().add_child(inst)
	get_tree().set_current_scene(inst)

	assert_null(Game.current_game)
	Game.ensure_current_game()

	# probably want to drop this
	assert_eq(Game.current_game.game_entity.get_singleton().resource_path, "res://src/hatbot/HatBot.gd")
	assert_eq(Game.current_game.get_script().resource_path, "res://src/hatbot/HatBot.gd")

	inst.queue_free()
