extends GdUnitTestSuite
class_name DotHopTest

func build_puzzle(puzzle):
	return DotHopPuzzle.build_puzzle_node({puzzle=puzzle, game_def_path="res://src/dotHop/dothop.txt"})

class TestBasicMovement:
	extends DotHopTest

	func test_level_one_win():
		var level = build_puzzle(["xoot"])
		add_child(level)

		assert_that(level.state.grid[0]).is_equal(
			[["Player", "Dotted"], ["Dot"], ["Dot"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)
		level.move(Vector2.RIGHT)
		assert_that(level.state.grid[0]).is_equal(
			[["Dotted", "Undo"], ["Player", "Dotted"], ["Dot"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)
		level.move(Vector2.RIGHT)
		assert_that(level.state.grid[0]).is_equal(
			[["Dotted"], ["Dotted", "Undo"], ["Player", "Dotted"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)
		level.move(Vector2.RIGHT)
		assert_that(level.state.grid[0]).is_equal(
			[["Dotted"], ["Dotted"], ["Dotted", "Undo"], ["Goal", "Player"]])
		assert_that(level.state.win).is_equal(true)

		level.free()

	func test_level_one_undo():

		var level = build_puzzle(["xoot"])
		add_child(level)

		assert_that(level.state.grid[0]).is_equal(
			[["Player", "Dotted"], ["Dot"], ["Dot"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)
		level.move(Vector2.RIGHT)
		assert_that(level.state.grid[0]).is_equal(
			[["Dotted", "Undo"], ["Player", "Dotted"], ["Dot"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)
		level.move(Vector2.RIGHT)
		assert_that(level.state.grid[0]).is_equal(
			[["Dotted"], ["Dotted", "Undo"], ["Player", "Dotted"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)
		level.move(Vector2.LEFT)
		assert_that(level.state.grid[0]).is_equal(
			[["Dotted", "Undo"], ["Dotted", "Player"], ["Dot"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)
		level.move(Vector2.LEFT)
		assert_that(level.state.grid[0]).is_equal(
			[["Dotted", "Player"], ["Dot"], ["Dot"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)

		level.free()


class TestBasicMovementTwoPlayers:
	extends DotHopTest

	func test_level_one_win():
		var level = build_puzzle(["xoot", "xoot"])
		add_child(level)

		assert_that(level.state.grid[0]).is_equal(
			[["Player", "Dotted"], ["Dot"], ["Dot"], ["Goal"]])
		assert_that(level.state.grid[1]).is_equal(
			[["Player", "Dotted"], ["Dot"], ["Dot"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)
		level.move(Vector2.RIGHT)
		assert_that(level.state.grid[0]).is_equal(
			[["Dotted", "Undo"], ["Player", "Dotted"], ["Dot"], ["Goal"]])
		assert_that(level.state.grid[1]).is_equal(
			[["Dotted", "Undo"], ["Player", "Dotted"], ["Dot"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)
		level.move(Vector2.RIGHT)
		assert_that(level.state.grid[0]).is_equal(
			[["Dotted"], ["Dotted", "Undo"], ["Player", "Dotted"], ["Goal"]])
		assert_that(level.state.grid[1]).is_equal(
			[["Dotted"], ["Dotted", "Undo"], ["Player", "Dotted"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)
		level.move(Vector2.RIGHT)
		assert_that(level.state.grid[0]).is_equal(
			[["Dotted"], ["Dotted"], ["Dotted", "Undo"], ["Goal", "Player"]])
		assert_that(level.state.grid[1]).is_equal(
			[["Dotted"], ["Dotted"], ["Dotted", "Undo"], ["Goal", "Player"]])
		assert_that(level.state.win).is_equal(true)
		level.free()

	func test_level_one_undo():
		var level = build_puzzle(["xoot", "xoot"])
		add_child(level)

		assert_that(level.state.grid[0]).is_equal(
			[["Player", "Dotted"], ["Dot"], ["Dot"], ["Goal"]])
		assert_that(level.state.grid[1]).is_equal(
			[["Player", "Dotted"], ["Dot"], ["Dot"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)
		level.move(Vector2.RIGHT)
		assert_that(level.state.grid[0]).is_equal(
			[["Dotted", "Undo"], ["Player", "Dotted"], ["Dot"], ["Goal"]])
		assert_that(level.state.grid[1]).is_equal(
			[["Dotted", "Undo"], ["Player", "Dotted"], ["Dot"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)
		level.move(Vector2.RIGHT)
		assert_that(level.state.grid[0]).is_equal(
			[["Dotted"], ["Dotted", "Undo"], ["Player", "Dotted"], ["Goal"]])
		assert_that(level.state.grid[1]).is_equal(
			[["Dotted"], ["Dotted", "Undo"], ["Player", "Dotted"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)
		level.move(Vector2.LEFT)
		assert_that(level.state.grid[0]).is_equal(
			[["Dotted", "Undo"], ["Dotted", "Player"], ["Dot"], ["Goal"]])
		assert_that(level.state.grid[1]).is_equal(
			[["Dotted", "Undo"], ["Dotted", "Player"], ["Dot"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)
		level.move(Vector2.LEFT)
		assert_that(level.state.grid[0]).is_equal(
			[["Dotted", "Player"], ["Dot"], ["Dot"], ["Goal"]])
		assert_that(level.state.grid[1]).is_equal(
			[["Dotted", "Player"], ["Dot"], ["Dot"], ["Goal"]])
		assert_that(level.state.win).is_equal(false)
		level.free()

class TestTwoPlayerInPlaceUndoBugs:
	extends DotHopTest

	func test_undo_obj_is_not_duplicated():
		var level = build_puzzle([
				"..oo",
				"txoo",
				"..oo",
				"txoo",
				])
		add_child(level)

		level.move(Vector2.RIGHT)
		level.move(Vector2.UP)
		level.move(Vector2.RIGHT)
		level.move(Vector2.UP)

		assert_that(level.state.grid[0]).is_equal(
			[null, null, ["Dotted", "Undo"], ["Player", "Dotted"]])
		assert_that(level.state.grid[2]).is_equal(
			[null, null, ["Dotted"], ["Dotted", "Undo"]])

		level.move(Vector2.DOWN)

		# This path was producing an extra "Undo" in the state grid,
		# when the second player didn't move during an undo
		assert_that(level.state.grid[0]).is_equal(
			[null, null, ["Dotted", "Undo"], ["Player", "Dotted"]])
		assert_that(level.state.grid[2]).is_equal(
			[null, null, ["Dotted", "Undo"], ["Dotted", "Player"]])

		level.free()

	func test_undo_obj_is_not_added_to_other_non_moving_player():
		var level = build_puzzle([
				"....o.o",
				"tx..o.o",
				"oo.o.x.",
				"t......",
				])
		add_child(level)

		level.move(Vector2.RIGHT)
		level.move(Vector2.LEFT)
		level.move(Vector2.LEFT)
		level.move(Vector2.LEFT)

		assert_that(level.state.grid[1]).is_equal(
			[["Goal"], ["Dotted", "Undo"], null, null, ["Player", "Dotted"], null, ["Dot"]])
		assert_that(level.state.grid[2]).is_equal(
			[["Player", "Dotted"], ["Dotted", "Undo"], null, ["Dotted"], null, ["Dotted"], null])

		level.move(Vector2.DOWN)

		assert_that(level.state.grid[1]).is_equal(
			[["Goal"], ["Dotted", "Undo"], null, null, ["Player", "Dotted"], null, ["Dot"]])

		level.move(Vector2.UP)

		# here we should have moved the top player's undo along
		assert_that(level.state.grid[1]).is_equal(
			[["Goal"], ["Dotted"], null, null, ["Dotted", "Undo"], null, ["Dot"]])

		level.move(Vector2.RIGHT)
		level.move(Vector2.DOWN)

		assert_that(level.state.grid[0]).is_equal(
			[null, null, null, null, ["Dotted"], null, ["Dotted", "Undo"]])
		assert_that(level.state.grid[1]).is_equal(
			[["Goal"], ["Dotted" # extra UNDO here?
				], null, null, ["Dotted"], null, ["Player", "Dotted"]])
		assert_that(level.state.grid[2]).is_equal(
			[["Dotted", "Undo"], ["Dotted"], null, ["Dotted"], null, ["Dotted"], null])
		assert_that(level.state.grid[3]).is_equal(
			[["Goal", "Player"], null, null, null, null, null, null])

		level.move(Vector2.LEFT)
		assert_that(level.state.win).is_equal(true)

		level.free()

		# assert_that(level.state.grid[2],
		# 	[null, null, ["Dotted"], ["Dotted", "Undo"]])

	func test_can_finish_level_10():
		var level = build_puzzle([
				"....o.o",
				"tx..o.o",
				"......t",
				"oo.o.x.",
				"oo.o..o",
				])
		add_child(level)

		level.move(Vector2.RIGHT)
		level.move(Vector2.LEFT)
		level.move(Vector2.LEFT)
		level.move(Vector2.LEFT)
		level.move(Vector2.DOWN)
		level.move(Vector2.UP)
		level.move(Vector2.RIGHT)
		level.move(Vector2.RIGHT)
		level.move(Vector2.RIGHT)
		level.move(Vector2.UP)
		level.move(Vector2.DOWN)
		level.move(Vector2.LEFT)

		assert_that(level.state.win).is_equal(true)

		level.free()

class TestUndoBugs:
	extends DotHopTest

	func test_can_undo_across_dotted_cells():
		var level = build_puzzle([
				"oooo.",
				"oxoot",
				"..oo.",
				])
		add_child(level)

		level.move(Vector2.RIGHT)
		level.move(Vector2.RIGHT)
		level.move(Vector2.UP)
		level.move(Vector2.LEFT)
		level.move(Vector2.LEFT)
		level.move(Vector2.LEFT)
		level.move(Vector2.DOWN)
		level.move(Vector2.RIGHT)

		assert_that(level.state.grid[1]).is_equal(
			[["Dotted", "Undo"], ["Dotted"], ["Dotted"], ["Dotted"], ["Goal", "Player"]])
		assert_that(level.state.players[0].stuck).is_equal(true)

		level.move(Vector2.LEFT)

		assert_that(level.state.players[0].stuck).is_equal(false)
		assert_that(level.state.grid[1]).is_equal(
			[["Dotted", "Player"], ["Dotted"], ["Dotted"], ["Dotted"], ["Goal"]])

		level.free()
