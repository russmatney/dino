extends GutTest

var parsed

func before_all():
	var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
	parsed = Puzz.parse_game(path)

func test_assert_all_sections():
	assert_true("prelude" in parsed)
	assert_true("objects" in parsed)
	assert_true("legend" in parsed)
	assert_true("sounds" in parsed)
	assert_true("collisionLayers" in parsed)
	assert_true("rules" in parsed)
	assert_true("winConditions" in parsed)
	assert_true("levels" in parsed)
