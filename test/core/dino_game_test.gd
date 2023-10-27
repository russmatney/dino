extends GdUnitTestSuite

func test_registered_games():
	var game_ents = Game.all_game_entities()

	assert_that(len(game_ents)).is_greater(0)
	for ent in game_ents:
		assert_that(ent).is_not_null()
		assert_that(ent.get_display_name()).is_not_equal("")
		# assert_not_null(ent.get_singleton(), "%s missing singleton" % ent.get_display_name())

func test_ensure_current_game_hatbot():
	# first level of hatbot
	var scene = load("res://src/hatbot/zones/LevelZero.tscn")
	var inst = scene.instantiate()

	# load/setup scene/inst
	get_tree().get_root().add_child(inst)
	get_tree().set_current_scene(inst)
	Game.reset_current_game()
	await get_tree().create_timer(0.3).timeout

	# probably want to drop this
	assert_that(Game.current_game.game_entity.get_singleton().resource_path).is_equal("res://src/hatbot/HatBot.gd")
	assert_that(Game.current_game.get_script().resource_path).is_equal("res://src/hatbot/HatBot.gd")

	inst.queue_free()

## per game launch tests
