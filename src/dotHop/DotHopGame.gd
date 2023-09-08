extends Node2D

#####################################################################
## vars

@export_file var game_def_path: String
@export var puzzle_theme: PandoraEntity

var game_def
var puzzle_node
var puzzle_scene
@export var puzzle_num = 0

#####################################################################
## ready

func _ready():
	game_def = Puzz.parse_game_def(game_def_path)
	load_theme()
	rebuild_puzzle()

#####################################################################
## rebuild puzzle

func rebuild_puzzle():
	if puzzle_node != null:
		puzzle_node.queue_free()
		# TODO is this a race case? or is it impossible?
		await puzzle_node.tree_exited

	# load current level
	puzzle_node = DotHop.build_puzzle_node({
		game_def=game_def,
		puzzle_num=puzzle_num,
		puzzle_scene=puzzle_scene
		})

	puzzle_node.win.connect(on_puzzle_win)
	puzzle_node.ready.connect(on_puzzle_ready)

	# dispatch?
	add_child(puzzle_node)

func on_puzzle_ready():
	pass
	# if not Engine.is_editor_hint():
	# 	Cam.ensure_cam(self)
	# 	Hood.ensure_hud(self)
		# TODO music, initial game sounds

#####################################################################
## load theme

func load_theme():
	pass
	# puzzle_scene = puzzle_theme.get_puzzle_scene()

#####################################################################
## win

func on_puzzle_win():
	# TODO juicy win scene with button to advance
	# metrics like number of moves, time
	# leaderboard via that wolf thing?

	puzzle_num += 1

	if puzzle_num >= len(game_def.levels):
		Hood.notif("Win all")
	else:
		Hood.notif("Next level!")
		rebuild_puzzle()
