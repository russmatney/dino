extends GdUnitTestSuite
class_name GunnerTest

func test_gunner_game_entity():
	var ent = Pandora.get_entity(DinoGameEntityIds.GUNNER)

	assert_that(ent).is_not_null()
	assert_that(ent.get_level_scene()).is_not_null()
