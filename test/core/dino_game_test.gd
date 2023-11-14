extends GdUnitTestSuite

func test_all_game_entities():
	var game_ents = Game.all_game_entities()

	assert_that(len(game_ents)).is_greater(0)
	for ent in game_ents:
		assert_that(ent).is_not_null()
		assert_that(ent.get_display_name()).is_not_equal("")

func test_all_game_modes():
	var game_ents = Game.all_game_modes()

	assert_that(len(game_ents)).is_greater(0)
	for ent in game_ents:
		assert_that(ent).is_not_null()
		assert_that(ent.get_display_name()).is_not_equal("")
