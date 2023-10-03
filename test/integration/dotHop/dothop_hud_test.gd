extends GutTest

var game

func before_all():
	game = load("res://src/dotHop/DotHopGame.tscn").instantiate()
	add_child(game)
	if not Hood.hud.is_node_ready():
		await Hood.hud_ready

func test_hud_loads_initial_state():
	assert_eq(Hood.hud.last_puzzle_update.dots_remaining, 4)
	assert_eq(Hood.hud.last_puzzle_update.dots_total, 5)

func test_hud_receives_updates():
	watch_signals(Hotel)
	# assumes this is valid for the first puzzle in the game
	game.puzzle_node.move(Vector2.RIGHT)

	assert_eq(Hood.hud.last_puzzle_update.dots_remaining, 3)
	assert_eq(Hood.hud.last_puzzle_update.dots_total, 5)
