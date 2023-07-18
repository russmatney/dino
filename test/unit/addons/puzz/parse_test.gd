extends GutTest

class TestSimpleBlockPushingGamePrelude:
	extends GutTest

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game(path)

	func test_prelude():
		assert_has(parsed, "prelude", "prelude not parsed")
		assert_eq(parsed.prelude.title, "Simple Block Pushing Game")
		assert_eq(parsed.prelude.author, "David Skinner")
		assert_eq(parsed.prelude.homepage, "www.puzzlescript.net")
		assert_eq(parsed.prelude.debug, true)


class TestSimpleBlockPushingGameObjects:
	extends GutTest

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game(path)


	func test_objects():
		assert_has(parsed, "objects", "objects not parsed")

	func test_objects_background():
		assert_has(parsed.objects, "Background", "Background object not parsed")
		assert_eq(parsed.objects.Background.name, "Background")
		assert_eq_deep(parsed.objects.Background.colors, ["lightgreen", "green"])
		assert_eq_deep(parsed.objects.Background.shape, [
			[1, 1, 1, 1, 1],
			[0, 1, 1, 1, 1],
			[1, 1, 1, 0, 1],
			[1, 1, 1, 1, 1],
			[1, 0, 1, 1, 1],
			])

	func test_objects_target():
		assert_has(parsed.objects, "Target", "Target object not parsed")
		assert_eq(parsed.objects.Target.name, "Target")
		assert_eq(parsed.objects.Target.colors, ["darkblue"])
		assert_eq(parsed.objects.Target.shape, [
			[null, null, null, null, null],
			[null, 0, 0, 0, null],
			[null, 0, null, 0, null],
			[null, 0, 0, 0, null],
			[null, null, null, null, null],
			])

	func test_objects_wall():
		assert_has(parsed.objects, "Wall", "Wall object not parsed")
		assert_eq(parsed.objects.Wall.name, "Wall")
		assert_eq(parsed.objects.Wall.colors, ["brown", "darkbrown"])
		assert_eq(parsed.objects.Wall.shape, [
			[0, 0, 0, 1, 0],
			[1, 1, 1, 1, 1],
			[0, 1, 0, 0, 0],
			[1, 1, 1, 1, 1],
			[0, 0, 0, 1, 0],
			])

	func test_objects_player():
		assert_has(parsed.objects, "Player", "Player object not parsed")
		assert_eq(parsed.objects.Player.name, "Player")
		assert_eq(parsed.objects.Player.symbol, "P")
		assert_eq(parsed.objects.Player.colors, ["black", "orange", "white", "blue"])
		assert_eq(parsed.objects.Player.shape, [
			[null, 0, 0, 0, null],
			[null, 1, 1, 1, null],
			[2, 2, 2, 2, 2],
			[null, 3, 3, 3, null],
			[null, 3, null, 3, null],
			])

	func test_objects_crate():
		assert_has(parsed.objects, "Crate", "Crate object not parsed")
		assert_eq(parsed.objects.Crate.name, "Crate")
		assert_eq(parsed.objects.Crate.colors, ["orange"])
		assert_eq(parsed.objects.Crate.shape, [
			[0, 0, 0, 0, 0],
			[0, null, null, null, 0],
			[0, null, null, null, 0],
			[0, null, null, null, 0],
			[0, 0, 0, 0, 0],
			])

class TestSimpleBlockPushingGameLegend:
	extends GutTest

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game(path)

	func test_legend():
		assert_has(parsed, "legend", "legend not parsed")

		# TODO may need to distinguish and/or here?
		assert_eq(parsed.legend["."], ["Background"])
		assert_eq(parsed.legend["#"], ["Wall"])
		assert_eq(parsed.legend["P"], ["Player"])
		assert_eq(parsed.legend["*"], ["Crate"])
		assert_eq(parsed.legend["@"], ["Crate", "Target"])
		assert_eq(parsed.legend["O"], ["Target"])
		assert_eq(parsed.legend["X"], ["Crate", "Player"])

class TestSimpleBlockPushingGameSounds:
	extends GutTest

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game(path)

	func test_sounds():
		assert_has(parsed, "sounds", "sounds not parsed")

		assert_eq_deep(parsed.sounds, [
			# TODO perhaps a map? and I'm sure there are lots of cases/other names
			["Crate", "move", "36772507"]
			])

class TestSimpleBlockPushingGameCollisionLayers:
	extends GutTest

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game(path)

	func test_collision_layers():
		assert_has(parsed, "collisionlayers", "collisionlayers not parsed")

		assert_eq_deep(parsed.collisionlayers, [
			["Background"],
			["Target"],
			["Player", "Wall", "Crate"],
			])

class TestSimpleBlockPushingGameRules:
	extends GutTest

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game(path)

	func test_rules():
		# TODO add more rule variants
		assert_has(parsed, "rules", "rules not parsed")
		assert_eq_deep(parsed.rules, [{
				pattern=[[">", "Player"], ["Crate"]],
				update=[[">", "Player"], [">", "Crate"]]
				}, {
				pattern=["DOWN", [">", "Player"], ["Crate"]],
				update=[[">", "Player"], [">", "Crate"]]
				}
			])

class TestSimpleBlockPushingGameWinConditions:
	extends GutTest

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game(path)

	func test_winconditions():
		# TODO add more win-cond variants
		assert_has(parsed, "winconditions", "winconditions not parsed")
		assert_eq_deep(parsed.winconditions, [["all", "Target", "on", "Crate"]])


class TestSimpleBlockPushingGameLevels:
	extends GutTest

	var parsed

	func before_all():
		var path = "res://test/unit/addons/puzz/simple_block_pushing_game.ps"
		parsed = Puzz.parse_game(path)

	func test_levels():
		# TODO add more win-cond variants
		assert_has(parsed, "levels", "levels not parsed")

	func test_level_first():
		assert_eq_deep(parsed.levels[0].shape, [
			["#", "#", "#", "#", null, null],
			["#", null, "O", "#", null, null],
			["#", null, null, "#", "#", "#"],
			["#", "@", "P", null, null, "#"],
			["#", null, null, "*", null, "#"],
			["#", null, null, "#", "#", "#"],
			["#", "#", "#", "#", null, null],
			])

	func test_level_second():
		assert_eq(parsed.levels[1].message, "level 2 begins")
		assert_eq_deep(parsed.levels[1].shape, [
			["#", "#", "#", "#", "#", "#"],
			["#", null, null, null, null, "#"],
			["#", null, "#", "P", null, "#"],
			["#", null, "*", "@", null, "#"],
			["#", null, "O", "@", null, "#"],
			["#", null, null, null, null, "#"],
			["#", "#", "#", "#", "#", "#"],
			])
