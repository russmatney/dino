extends GdUnitTestSuite

class TestSimpleBlockPushingGamePrelude:
	extends GdUnitTestSuite

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game_def(path)

	func test_prelude():
		assert_that(parsed).contains_keys(["prelude"])
		assert_that(parsed.prelude.title).is_equal("Simple Block Pushing Game")
		assert_that(parsed.prelude.author).is_equal("David Skinner")
		assert_that(parsed.prelude.homepage).is_equal("www.puzzlescript.net")
		assert_that(parsed.prelude.debug).is_equal(true)


class TestSimpleBlockPushingGameObjects:
	extends GdUnitTestSuite

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game_def(path)


	func test_objects():
		assert_that(parsed).contains_keys(["objects"])

	func test_objects_background():
		assert_that(parsed.objects).contains_keys("Background")
		assert_that(parsed.objects.Background.name).is_equal("Background")
		assert_that(parsed.objects.Background.colors).is_equal(["lightgreen", "green"])
		assert_that(parsed.objects.Background.shape).is_equal([
			[1, 1, 1, 1, 1],
			[0, 1, 1, 1, 1],
			[1, 1, 1, 0, 1],
			[1, 1, 1, 1, 1],
			[1, 0, 1, 1, 1],
			])

	func test_objects_target():
		assert_that(parsed.objects).contains_keys("Target")
		assert_that(parsed.objects.Target.name).is_equal("Target")
		assert_that(parsed.objects.Target.colors).is_equal(["darkblue"])
		assert_that(parsed.objects.Target.shape).is_equal([
			[null, null, null, null, null],
			[null, 0, 0, 0, null],
			[null, 0, null, 0, null],
			[null, 0, 0, 0, null],
			[null, null, null, null, null],
			])

	func test_objects_wall():
		assert_that(parsed.objects).contains_keys(["Wall"])
		assert_that(parsed.objects.Wall.name).is_equal("Wall")
		assert_that(parsed.objects.Wall.colors).is_equal(["brown", "darkbrown"])
		assert_that(parsed.objects.Wall.shape).is_equal([
			[0, 0, 0, 1, 0],
			[1, 1, 1, 1, 1],
			[0, 1, 0, 0, 0],
			[1, 1, 1, 1, 1],
			[0, 0, 0, 1, 0],
			])

	func test_objects_player():
		assert_that(parsed.objects).contains_keys(["Player"])
		assert_that(parsed.objects.Player.name).is_equal("Player")
		assert_that(parsed.objects.Player.symbol).is_equal("P")
		assert_that(parsed.objects.Player.colors).is_equal(["black", "orange", "white", "blue"])
		assert_that(parsed.objects.Player.shape).is_equal([
			[null, 0, 0, 0, null],
			[null, 1, 1, 1, null],
			[2, 2, 2, 2, 2],
			[null, 3, 3, 3, null],
			[null, 3, null, 3, null],
			])

	func test_objects_crate():
		assert_that(parsed.objects).contains_keys(["Crate"])
		assert_that(parsed.objects.Crate.name).is_equal("Crate")
		assert_that(parsed.objects.Crate.colors).is_equal(["orange"])
		assert_that(parsed.objects.Crate.shape).is_equal([
			[0, 0, 0, 0, 0],
			[0, null, null, null, 0],
			[0, null, null, null, 0],
			[0, null, null, null, 0],
			[0, 0, 0, 0, 0],
			])

class TestSimpleBlockPushingGameLegend:
	extends GdUnitTestSuite

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game_def(path)

	func test_legend():
		assert_that(parsed).contains_keys(["legend"])

		# add coverage for 'and' vs 'or'
		assert_that(parsed.legend["."]).is_equal(["Background"])
		assert_that(parsed.legend["#"]).is_equal(["Wall"])
		assert_that(parsed.legend["P"]).is_equal(["Player"])
		assert_that(parsed.legend["*"]).is_equal(["Crate"])
		assert_that(parsed.legend["@"]).is_equal(["Crate", "Target"])
		assert_that(parsed.legend["O"]).is_equal(["Target"])
		assert_that(parsed.legend["X"]).is_equal(["Crate", "Player"])

class TestSimpleBlockPushingGameSounds:
	extends GdUnitTestSuite

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game_def(path)

	func test_sounds():
		assert_that(parsed).contains_keys(["sounds"])
		assert_that(parsed.sounds).is_equal([
			# perhaps a map? I'm sure there are lots of cases/other names
			["Crate", "move", "36772507"]
			])

class TestSimpleBlockPushingGameCollisionLayers:
	extends GdUnitTestSuite

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game_def(path)

	func test_collision_layers():
		assert_that(parsed).contains_keys(["collisionlayers"])
		assert_that(parsed.collisionlayers).is_equal([
			["Background"],
			["Target"],
			["Player", "Wall", "Crate"],
			])

class TestSimpleBlockPushingGameRules:
	extends GdUnitTestSuite

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game_def(path)

	func test_rules():
		assert_that(parsed).contains_keys(["rules"])
		assert_that(parsed.rules).is_equal([{
				pattern=[[">", "Player"], ["Crate"]],
				update=[[">", "Player"], [">", "Crate"]]
				}, {
				pattern=["DOWN", [">", "Player"], ["Crate"]],
				update=[[">", "Player"], [">", "Crate"]]
				}
			])

class TestSimpleBlockPushingGameWinConditions:
	extends GdUnitTestSuite

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game_def(path)

	func test_winconditions():
		assert_that(parsed).contains_keys(["winconditions"])
		assert_that(parsed.winconditions).is_equal([["all", "Target", "on", "Crate"]])


class TestSimpleBlockPushingGameLevels:
	extends GdUnitTestSuite

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game_def(path)

	func test_levels():
		assert_that(parsed).contains_keys(["levels"])
		assert_that(len(parsed.levels)).is_equal(3)

	func test_level_first():
		assert_that(parsed.levels[0].shape).is_equal([
			["#", "#", "#", "#", null, null],
			["#", null, "O", "#", null, null],
			["#", null, null, "#", "#", "#"],
			["#", "@", "P", null, null, "#"],
			["#", null, null, "*", null, "#"],
			["#", null, null, "#", "#", "#"],
			["#", "#", "#", "#", null, null],
			])

	func test_level_second():
		assert_that(parsed.levels[1].message).is_equal("level 2 begins")
		assert_that(parsed.levels[1].shape).is_equal([
			["#", "#", "#", "#", "#", "#"],
			["#", null, null, null, null, "#"],
			["#", null, "#", "P", null, "#"],
			["#", null, "*", "@", null, "#"],
			["#", null, "O", "@", null, "#"],
			["#", null, null, null, null, "#"],
			["#", "#", "#", "#", "#", "#"],
			])

	func test_level_final():
		assert_that(parsed.levels[2].message).is_equal("game complete!")
		assert_that(parsed.levels[2].shape).is_null()
