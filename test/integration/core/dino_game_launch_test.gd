extends GutTest

func test_all_game_entities():
	var game_ents = Game.all_game_entities()

	assert_gt(len(game_ents), 0)
	for ent in game_ents:
		assert_not_null(ent)
		assert_ne(ent.get_display_name(), "")
		assert_true(ent.is_enabled())
		assert_not_null(ent.get_singleton(), "%s missing singleton" % ent.get_display_name())

# Makes sure each game can be registered
func test_register_every_game():
	var game_ents = Game.all_game_entities()

	for ent in game_ents:
		Game.set_current_game_for_ent(ent)
		await get_tree().create_timer(0.2).timeout
		assert_eq(Game.current_game.game_entity, ent)
		await get_tree().create_timer(0.2).timeout

# Makes sure each game starts without fatal crashes
func test_start_every_game():
	var game_ents = Game.all_game_entities()

	for ent in game_ents:
		Game.set_current_game_for_ent(ent)
		# wait for clean up
		await get_tree().create_timer(0.2).timeout
		assert_eq(Game.current_game.game_entity, ent)
		Game.restart_game()

		# TODO some kind of per-game assertion?
		await get_tree().create_timer(0.2).timeout
