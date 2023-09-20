@tool
extends DinoGame

#####################################################################
## vars/enums

var game_scene = "res://src/dotHop/DotHopGame.tscn"
var fallback_puzzle_scene = "res://src/dotHop/puzzle/DotHopPuzzle.tscn"
var hud_scene = "res://src/dotHop/hud/DotHopHUD.tscn"
var puzzle_group = "dothop_puzzle"

enum dotType { Dot, Dotted, Goal}

var reset_hold_t = 0.4

## build puzzle node #####################################################################

# Builds and returns a "puzzle_scene" node, with a game_def and level_def set
# Accepts several input options, but only 'game_def' or 'game_def_path' are required.
#
# A raw puzzle or puzzle_num can be specified to load/pick a level for a particular game_def.
# `puzzle_scene` should be set according to the current theme.
#
# This func could live on the DotHopGame script, but a function like this is useful
# for testing just the game logic (without loading a full DotHopGame)
func build_puzzle_node(opts:Variant) -> Node2D:
	# parse the puzzle script game, set game_def
	var game_def_path = opts.get("game_def_path")
	var game_def = opts.get("game_def")
	if not game_def and game_def_path:
		game_def = Puzz.parse_game_def(game_def_path)

	if game_def == null:
		Debug.warn("No gamedef passed, cannot build_puzzle_node()", opts)
		return

	# parse/pick the puzzle to load
	var puzzle = opts.get("puzzle")
	# default to loading the first level
	var puzzle_num = opts.get("puzzle_num", 0)
	var level_def

	if puzzle != null:
		level_def = Puzz.parse_level_def(puzzle, opts.get("puzzle_message"))
	elif puzzle_num != null:
		level_def = game_def.levels[puzzle_num]
	else:
		pass

	if level_def == null or level_def.shape == null:
		Debug.warn("Could not determine level_def, cannot build_puzzle_node()", opts)
		return

	# PackedScene, string, or use fallback
	var scene = opts.get("puzzle_scene")
	if scene is String:
		scene = load(scene)
	elif scene == null:
		scene = load(fallback_puzzle_scene)

	var node = scene.instantiate()
	node.game_def = game_def
	node.level_def = level_def
	return node

#####################################################################
## Dino game spec

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/dotHop")

func should_spawn_player(_scene):
	return false

func start(opts={}):
	var g = load(game_scene).instantiate()
	g.puzzle_set = opts.get("puzzle_set")
	Navi.nav_to(g)

var game
func register_game(g):
	game = g

var current_theme
func change_theme(theme):
	if current_theme != theme:
		current_theme = theme
		if game != null:
			game.puzzle_theme = theme
			game.load_theme()
			# TODO maintain current puzzle state?
			game.rebuild_puzzle()
