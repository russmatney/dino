extends GdUnitTestSuite

# TODO restore/rewrite dothop tests

var game

func before_all():
	game = load("res://src/dotHop/DotHopGame.tscn").instantiate()
	add_child(game)
	if not Hood.hud.is_node_ready():
		await Hood.hud_ready

func after_all():
	game.free()

# func test_hud_loads_initial_state():
# 	assert_that(Hood.hud.last_puzzle_update.dots_remaining).is_equal(4)
# 	assert_that(Hood.hud.last_puzzle_update.dots_total).is_equal(5)

# func test_hud_receives_updates():
# 	# assumes this is valid for the first puzzle in the game
# 	game.puzzle_node.move(Vector2.RIGHT)

# 	assert_that(Hood.hud.last_puzzle_update.dots_remaining).is_equal(3)
# 	assert_that(Hood.hud.last_puzzle_update.dots_total).is_equal(5)
