extends GutTest

func test_hotel_loads_puzzle():
	var game = load("res://src/dotHop/DotHopGame.tscn").instantiate()
	add_child(game)
	await Hood.hud_ready

	var puzzle = Hotel.first({group=DotHop.puzzle_group})

	assert_not_null(puzzle)
	assert_has(puzzle.groups, DotHop.puzzle_group)

	game.free()
