extends GdUnitTestSuite

func test_all_game_entities():
	var game_ents = Game.all_game_entities()

	assert_that(len(game_ents)).is_greater(0)
	for ent in game_ents:
		assert_that(ent).is_not_null()
		assert_that(ent.get_display_name()).is_not_equal("")
		assert_that(ent.is_enabled()).is_true()
		# assert_that(ent.get_singleton()).is_not_null()

# Makes sure each game can be registered
func test_register_every_game():
	var game_ents = Game.all_game_entities()

	for ent in game_ents:
		Game.set_current_game_for_ent(ent)
		await get_tree().create_timer(0.2).timeout
		assert_that(Game.current_game.game_entity).is_equal(ent)
		await get_tree().create_timer(0.2).timeout

# Makes sure each game starts without fatal crashes
# func test_start_every_game():
# 	var game_ents = Game.all_game_entities()

# 	for ent in game_ents:
# 		Game.set_current_game_for_ent(ent)
# 		# wait for clean up
# 		await get_tree().create_timer(0.2).timeout
# 		assert_that(Game.current_game.game_entity).is_equal(ent)
# 		Game.restart_game()

# 		# some kind of per-game still-alive no-errors assertion?
# 		await get_tree().create_timer(0.2).timeout
