extends GutTest

class TestBasicMovement:
	extends GutTest

	var level

	func before_each():
		level = FlowerEater.build_puzzle_node(["xoot"])
		add_child(level)

	func after_all():
		level.free()

	func test_level_one_win():
		assert_eq_deep(level.state.grid[0],
			[["Player", "FlowerEaten"], ["Flower"], ["Flower"], ["Target"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Flower"], ["Target"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["FlowerEaten"], ["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Target"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["FlowerEaten"], ["FlowerEaten"], ["FlowerEaten", "Undo"], ["Target", "Player"]])
		assert_eq(level.state.win, true)

	func test_level_one_undo():
		assert_eq_deep(level.state.grid[0],
			[["Player", "FlowerEaten"], ["Flower"], ["Flower"], ["Target"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Flower"], ["Target"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["FlowerEaten"], ["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Target"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.LEFT)
		assert_eq_deep(level.state.grid[0],
			[["FlowerEaten", "Undo"], ["FlowerEaten", "Player"], ["Flower"], ["Target"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.LEFT)
		assert_eq_deep(level.state.grid[0],
			[["FlowerEaten", "Player"], ["Flower"], ["Flower"], ["Target"]])
		assert_eq(level.state.win, false)


class TestBasicMovementTwoPlayers:
	extends GutTest

	var level

	func before_each():
		level = FlowerEater.build_puzzle_node(["xoot", "xoot"])
		add_child(level)

	func after_all():
		level.free()

	func test_level_one_win():
		assert_eq_deep(level.state.grid[0],
			[["Player", "FlowerEaten"], ["Flower"], ["Flower"], ["Target"]])
		assert_eq_deep(level.state.grid[1],
			[["Player", "FlowerEaten"], ["Flower"], ["Flower"], ["Target"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Flower"], ["Target"]])
		assert_eq_deep(level.state.grid[1],
			[["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Flower"], ["Target"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["FlowerEaten"], ["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Target"]])
		assert_eq_deep(level.state.grid[1],
			[["FlowerEaten"], ["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Target"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["FlowerEaten"], ["FlowerEaten"], ["FlowerEaten", "Undo"], ["Target", "Player"]])
		assert_eq_deep(level.state.grid[1],
			[["FlowerEaten"], ["FlowerEaten"], ["FlowerEaten", "Undo"], ["Target", "Player"]])
		assert_eq(level.state.win, true)

	func test_level_one_undo():
		assert_eq_deep(level.state.grid[0],
			[["Player", "FlowerEaten"], ["Flower"], ["Flower"], ["Target"]])
		assert_eq_deep(level.state.grid[1],
			[["Player", "FlowerEaten"], ["Flower"], ["Flower"], ["Target"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Flower"], ["Target"]])
		assert_eq_deep(level.state.grid[1],
			[["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Flower"], ["Target"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[0],
			[["FlowerEaten"], ["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Target"]])
		assert_eq_deep(level.state.grid[1],
			[["FlowerEaten"], ["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Target"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.LEFT)
		assert_eq_deep(level.state.grid[0],
			[["FlowerEaten", "Undo"], ["FlowerEaten", "Player"], ["Flower"], ["Target"]])
		assert_eq_deep(level.state.grid[1],
			[["FlowerEaten", "Undo"], ["FlowerEaten", "Player"], ["Flower"], ["Target"]])
		assert_eq(level.state.win, false)
		level.move(Vector2.LEFT)
		assert_eq_deep(level.state.grid[0],
			[["FlowerEaten", "Player"], ["Flower"], ["Flower"], ["Target"]])
		assert_eq_deep(level.state.grid[1],
			[["FlowerEaten", "Player"], ["Flower"], ["Flower"], ["Target"]])
		assert_eq(level.state.win, false)

class TestTwoPlayerInPlaceUndoBugs:
	extends GutTest

	func test_undo_obj_is_not_duplicated():
		var level = FlowerEater.build_puzzle_node([
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
			[null, null, ["FlowerEaten", "Undo"], ["Player", "FlowerEaten"]])
		assert_eq_deep(level.state.grid[2],
			[null, null, ["FlowerEaten"], ["FlowerEaten", "Undo"]])

		level.move(Vector2.DOWN)

		# This path was producing an extra "Undo" in the state grid,
		# when the second player didn't move during an undo
		assert_eq_deep(level.state.grid[0],
			[null, null, ["FlowerEaten", "Undo"], ["Player", "FlowerEaten"]])
		assert_eq_deep(level.state.grid[2],
			[null, null, ["FlowerEaten", "Undo"], ["FlowerEaten", "Player"]])

		level.free()

	func test_undo_obj_is_not_added_to_other_non_moving_player():
		var level = FlowerEater.build_puzzle_node([
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
			[["Target"], ["FlowerEaten", "Undo"], null, null, ["Player", "FlowerEaten"], null, ["Flower"]])
		assert_eq_deep(level.state.grid[2],
			[["Player", "FlowerEaten"], ["FlowerEaten", "Undo"], null, ["FlowerEaten"], null, ["FlowerEaten"], null])

		level.move(Vector2.DOWN)

		assert_eq_deep(level.state.grid[1],
			[["Target"], ["FlowerEaten", "Undo"], null, null, ["Player", "FlowerEaten"], null, ["Flower"]])

		level.move(Vector2.UP)

		# here we should have moved the top player's undo along
		assert_eq_deep(level.state.grid[1],
			[["Target"], ["FlowerEaten"], null, null, ["FlowerEaten", "Undo"], null, ["Flower"]])

		level.move(Vector2.RIGHT)
		level.move(Vector2.DOWN)

		assert_eq_deep(level.state.grid[0],
			[null, null, null, null, ["FlowerEaten"], null, ["FlowerEaten", "Undo"]])
		assert_eq_deep(level.state.grid[1],
			[["Target"], ["FlowerEaten" # extra UNDO here?
				], null, null, ["FlowerEaten"], null, ["Player", "FlowerEaten"]])
		assert_eq_deep(level.state.grid[2],
			[["FlowerEaten", "Undo"], ["FlowerEaten"], null, ["FlowerEaten"], null, ["FlowerEaten"], null])
		assert_eq_deep(level.state.grid[3],
			[["Target", "Player"], null, null, null, null, null, null])

		level.move(Vector2.LEFT)
		assert_eq(level.state.win, true)

		level.free()

		# assert_eq_deep(level.state.grid[2],
		# 	[null, null, ["FlowerEaten"], ["FlowerEaten", "Undo"]])

	func test_can_finish_level_10():
		var level = FlowerEater.build_puzzle_node([
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
