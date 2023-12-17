extends GdUnitTestSuite

func test_basic_game_entities():
	var game_ents = Game.basic_game_entities()

	assert_that(len(game_ents)).is_greater(0)
	for ent in game_ents:
		assert_that(ent).is_not_null()
		assert_that(ent.get_display_name()).is_not_equal("")

func test_game_modes():
	var modes = DinoModeEntity.all_modes()

	assert_that(len(modes)).is_greater(0)
	for ent in modes:
		assert_that(ent).is_not_null()
		assert_that(ent.get_display_name()).is_not_equal("")
		assert_that(ent.get_icon_texture()).is_not_null()
