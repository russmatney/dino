extends Node2D

## vars #####################################################################

@export_file var game_def_path: String
@export var puzzle_theme: DotHopTheme
@export var puzzle_set: DotHopPuzzleSet

var game_def
var puzzle_node
var puzzle_scene
@export var puzzle_num = 0

var dismiss_jumbo_signal


## ready #####################################################################

func _ready():
	if Engine.has_singleton("DotHop"):
		var dh = Engine.get_singleton("DotHop")
		dh.register_game(self)
	else:
		Debug.warn("No dothop singleton found, some feats may not work")

	if puzzle_set != null:
		game_def_path = puzzle_set.get_puzzle_script_path()
		puzzle_theme = puzzle_set.get_theme()
	game_def = Puzz.parse_game_def(game_def_path)
	load_theme()
	rebuild_puzzle()

## input #####################################################################

func _unhandled_input(event):
	if dismiss_jumbo_signal != null:
		# jumbo already listens to Trolley "close", but here we add more
		if Trolley.is_event(event, "ui_accept"):
			dismiss_jumbo_signal.emit()

## rebuild puzzle #####################################################################

func rebuild_puzzle():
	if puzzle_node != null:
		puzzle_node.queue_free()
		# is this a race case? or is it impossible?
		await puzzle_node.tree_exited

	# load current level
	puzzle_node = DotHopPuzzle.build_puzzle_node({
		game_def=game_def,
		puzzle_num=puzzle_num,
		puzzle_scene=puzzle_scene
		})

	puzzle_node.win.connect(on_puzzle_win)
	puzzle_node.ready.connect(on_puzzle_ready)

	# defer?
	add_child(puzzle_node)

func on_puzzle_ready():
	pass

## load theme #####################################################################

func load_theme():
	puzzle_scene = puzzle_theme.get_puzzle_scene()

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

	dismiss_jumbo_signal = Quest.jumbo_notif({
		header=header, body=body,
		on_close=func():
		if game_complete:
			Hood.notif("Win all")
			Navi.show_win_menu()
		else:
			if puzzle_node.has_method("animate_exit"):
				Debug.pr("animating exit")
				await puzzle_node.animate_exit()
			Debug.pr("done awaiting")
			Hood.notif("Building next level!")
			rebuild_puzzle()})
