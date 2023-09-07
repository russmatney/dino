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

class TestTwoPlayerInPlaceUndoBug:
	extends GutTest

	var level

	func before_each():
		level = FlowerEater.build_puzzle_node([
			"..oo",
			"txoo",
			"..oo",
			"txoo",
			])
		add_child(level)

	func after_all():
		level.free()

	func test_undo_obj_is_not_duplicated():
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
