extends GutTest

class TestLevelOne:
	extends GutTest

	var level

	func before_each():
		level = FlowerEater.build_puzzle_node(0)
		add_child(level)

	func after_all():
		level.queue_free()

	func test_level_one_win():
		assert_eq_deep(level.state.grid[1],
			[null, ["Player", "FlowerEaten"], ["Flower"], ["Flower"], ["Flower"], ["Target"], null])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[1],
			[null, ["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Flower"], ["Flower"], ["Target"], null])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[1],
			[null, ["FlowerEaten"], ["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Flower"], ["Target"], null])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[1],
			[null, ["FlowerEaten"], ["FlowerEaten"], ["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Target"], null])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[1],
			[null, ["FlowerEaten"], ["FlowerEaten"], ["FlowerEaten"], ["FlowerEaten", "Undo"], ["Target", "Player"], null])
		assert_eq(level.state.win, true)

	func test_level_one_undo():
		assert_eq_deep(level.state.grid[1],
			[null, ["Player", "FlowerEaten"], ["Flower"], ["Flower"], ["Flower"], ["Target"], null])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[1],
			[null, ["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Flower"], ["Flower"], ["Target"], null])
		assert_eq(level.state.win, false)
		level.move(Vector2.RIGHT)
		assert_eq_deep(level.state.grid[1],
			[null, ["FlowerEaten"], ["FlowerEaten", "Undo"], ["Player", "FlowerEaten"], ["Flower"], ["Target"], null])
		assert_eq(level.state.win, false)
		level.move(Vector2.LEFT)
		assert_eq_deep(level.state.grid[1],
			[null, ["FlowerEaten", "Undo"], ["FlowerEaten", "Player"], ["Flower"], ["Flower"], ["Target"], null])
		assert_eq(level.state.win, false)
		level.move(Vector2.LEFT)
		assert_eq_deep(level.state.grid[1],
			[null, ["FlowerEaten", "Player"], ["Flower"], ["Flower"], ["Flower"], ["Target"], null])
		assert_eq(level.state.win, false)
