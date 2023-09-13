extends GutTest
class_name DotHopTest

func build_puzzle(puzzle):
	return DotHop.build_puzzle_node({puzzle=puzzle, game_def_path="res://src/dotHop/dothop.txt"})

class TestBasicMovement:
	extends DotHopTest

	var level

	func before_each():
		level = build_puzzle(["xoot"])
		add_child(level)

	func after_all():
		level.free()

	func test_level_one_win():
		assert_eq_deep(level.state.grid[0],
			[["Player", "Dotted"], ["Dot"], ["Dot"], ["Goal"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["Dotted", "Undo"], ["Player", "Dotted"], ["Dot"], ["Goal"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["Dotted"], ["Dotted", "Undo"], ["Player", "Dotted"], ["Goal"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["Dotted"], ["Dotted"], ["Dotted", "Undo"], ["Goal", "Player"]])
		assert_eq(level.state.win, true)

	func test_level_one_undo():
		assert_eq_deep(level.state.grid[0],
			[["Player", "Dotted"], ["Dot"], ["Dot"], ["Goal"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["Dotted", "Undo"], ["Player", "Dotted"], ["Dot"], ["Goal"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["Dotted"], ["Dotted", "Undo"], ["Player", "Dotted"], ["Goal"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.LEFT)
		assert_eq_deep(level.state.grid[0],
			[["Dotted", "Undo"], ["Dotted", "Player"], ["Dot"], ["Goal"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.LEFT)
		assert_eq_deep(level.state.grid[0],
			[["Dotted", "Player"], ["Dot"], ["Dot"], ["Goal"]])
		assert_eq(level.state.win, false)


class TestBasicMovementTwoPlayers:
	extends DotHopTest

	var level

	func before_each():
		level = build_puzzle(["xoot", "xoot"])
		add_child(level)

	func after_all():
		level.free()

	func test_level_one_win():
		assert_eq_deep(level.state.grid[0],
			[["Player", "Dotted"], ["Dot"], ["Dot"], ["Goal"]])
		assert_eq_deep(level.state.grid[1],
			[["Player", "Dotted"], ["Dot"], ["Dot"], ["Goal"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["Dotted", "Undo"], ["Player", "Dotted"], ["Dot"], ["Goal"]])
		assert_eq_deep(level.state.grid[1],
			[["Dotted", "Undo"], ["Player", "Dotted"], ["Dot"], ["Goal"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["Dotted"], ["Dotted", "Undo"], ["Player", "Dotted"], ["Goal"]])
		assert_eq_deep(level.state.grid[1],
			[["Dotted"], ["Dotted", "Undo"], ["Player", "Dotted"], ["Goal"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["Dotted"], ["Dotted"], ["Dotted", "Undo"], ["Goal", "Player"]])
		assert_eq_deep(level.state.grid[1],
			[["Dotted"], ["Dotted"], ["Dotted", "Undo"], ["Goal", "Player"]])
		assert_eq(level.state.win, true)

	func test_level_one_undo():
		assert_eq_deep(level.state.grid[0],
			[["Player", "Dotted"], ["Dot"], ["Dot"], ["Goal"]])
		assert_eq_deep(level.state.grid[1],
			[["Player", "Dotted"], ["Dot"], ["Dot"], ["Goal"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["Dotted", "Undo"], ["Player", "Dotted"], ["Dot"], ["Goal"]])
		assert_eq_deep(level.state.grid[1],
			[["Dotted", "Undo"], ["Player", "Dotted"], ["Dot"], ["Goal"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["Dotted"], ["Dotted", "Undo"], ["Player", "Dotted"], ["Goal"]])
		assert_eq_deep(level.state.grid[1],
			[["Dotted"], ["Dotted", "Undo"], ["Player", "Dotted"], ["Goal"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.LEFT)
		assert_eq_deep(level.state.grid[0],
			[["Dotted", "Undo"], ["Dotted", "Player"], ["Dot"], ["Goal"]])
		assert_eq_deep(level.state.grid[1],
			[["Dotted", "Undo"], ["Dotted", "Player"], ["Dot"], ["Goal"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.LEFT)
		assert_eq_deep(level.state.grid[0],
			[["Dotted", "Player"], ["Dot"], ["Dot"], ["Goal"]])
		assert_eq_deep(level.state.grid[1],
			[["Dotted", "Player"], ["Dot"], ["Dot"], ["Goal"]])
		assert_eq(level.state.win, false)

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

		assert_eq_deep(level.state.grid[0],
			[null, null, ["Dotted", "Undo"], ["Player", "Dotted"]])
		assert_eq_deep(level.state.grid[2],
			[null, null, ["Dotted"], ["Dotted", "Undo"]])

		level.move(Vector2.DOWN)

		# This path was producing an extra "Undo" in the state grid,
		# when the second player didn't move during an undo
		assert_eq_deep(level.state.grid[0],
			[null, null, ["Dotted", "Undo"], ["Player", "Dotted"]])
		assert_eq_deep(level.state.grid[2],
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

		assert_eq_deep(level.state.grid[1],
			[["Goal"], ["Dotted", "Undo"], null, null, ["Player", "Dotted"], null, ["Dot"]])
		assert_eq_deep(level.state.grid[2],
			[["Player", "Dotted"], ["Dotted", "Undo"], null, ["Dotted"], null, ["Dotted"], null])

		level.move(Vector2.DOWN)

		assert_eq_deep(level.state.grid[1],
			[["Goal"], ["Dotted", "Undo"], null, null, ["Player", "Dotted"], null, ["Dot"]])

		level.move(Vector2.UP)

		# here we should have moved the top player's undo along
		assert_eq_deep(level.state.grid[1],
			[["Goal"], ["Dotted"], null, null, ["Dotted", "Undo"], null, ["Dot"]])

		level.move(Vector2.RIGHT)
		level.move(Vector2.DOWN)

		assert_eq_deep(level.state.grid[0],
			[null, null, null, null, ["Dotted"], null, ["Dotted", "Undo"]])
		assert_eq_deep(level.state.grid[1],
			[["Goal"], ["Dotted" # extra UNDO here?
				], null, null, ["Dotted"], null, ["Player", "Dotted"]])
		assert_eq_deep(level.state.grid[2],
			[["Dotted", "Undo"], ["Dotted"], null, ["Dotted"], null, ["Dotted"], null])
		assert_eq_deep(level.state.grid[3],
			[["Goal", "Player"], null, null, null, null, null, null])

		level.move(Vector2.LEFT)
		assert_eq(level.state.win, true)

		level.free()

		# assert_eq_deep(level.state.grid[2],
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

		assert_eq(level.state.win, true)

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

		assert_eq_deep(level.state.grid[1],
			[["Dotted", "Undo"], ["Dotted"], ["Dotted"], ["Dotted"], ["Goal", "Player"]])
		assert_eq(level.state.players[0].stuck, true)

		level.move(Vector2.LEFT)

		assert_eq(level.state.players[0].stuck, false)
		assert_eq_deep(level.state.grid[1],
			[["Dotted", "Player"], ["Dotted"], ["Dotted"], ["Dotted"], ["Goal"]])

		level.free()
