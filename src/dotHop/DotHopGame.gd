extends Node2D

## vars #####################################################################

@export_file var game_def_path: String
@export var puzzle_theme: DotHopTheme
@export var puzzle_set: DotHopPuzzleSet

var game_def
var puzzle_node
var puzzle_scene
@export var puzzle_num = 0

## ready #####################################################################

func _ready():
	if puzzle_set == null:
		puzzle_set = Pandora.get_entity(DhPuzzleSet.ONE)

	if puzzle_set != null:
		game_def_path = puzzle_set.get_puzzle_script_path()
		puzzle_theme = puzzle_set.get_theme()
	game_def = Puzz.parse_game_def(game_def_path)
	load_theme()
	rebuild_puzzle()

## rebuild puzzle #####################################################################

func rebuild_puzzle():
	if puzzle_node != null:
		remove_child.call_deferred(puzzle_node)
		puzzle_node.queue_free()
		# is this a race case? or is it impossible?
		await puzzle_node.tree_exited

	# load current level
	puzzle_node = DotHopPuzzle.build_puzzle_node({
		game_def=game_def,
		puzzle_num=puzzle_num,
		puzzle_scene=puzzle_scene
		})

	if puzzle_node == null:
		Log.pr("Failed to create puzzle_node, probably a win?")
		Navi.show_win_menu()
		return

	puzzle_node.win.connect(on_puzzle_win)
	puzzle_node.ready.connect(on_puzzle_ready)

	add_child.call_deferred(puzzle_node)

func on_puzzle_ready():
	pass

## load theme #####################################################################

func load_theme():
	puzzle_scene = puzzle_theme.get_puzzle_scene()

func change_theme(theme):
	if puzzle_theme != theme:
		puzzle_theme = theme
		load_theme()
		rebuild_puzzle()

## win #####################################################################

func on_puzzle_win():
	# juicy win scene with button to advance
	# metrics like number of moves, time
	# leaderboard via that wolf thing?

	puzzle_num += 1

	var game_complete = puzzle_num >= len(game_def.levels)

	var header
	var body
	if game_complete:
		header = "[jump]All %s Puzzles Complete![/jump]" % puzzle_num
		body = "Your friends must think you're\npretty nerdy"
	else:
		header = "[jump]Puzzle %s Complete![/jump]" % puzzle_num
		body = "....but how?"

	Jumbotron.jumbo_notif({
		header=header, body=body, pause=false,
		on_close=func():
		if game_complete:
			Hood.notif("Win all")
			Navi.show_win_menu()
		else:
			if puzzle_node.has_method("animate_exit"):
				await puzzle_node.animate_exit()
			Hood.notif("Building next level!")
			rebuild_puzzle()})
