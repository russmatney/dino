@tool
extends DinoGame

#####################################################################
## vars

var game_def
var level_script = preload("res://src/dotHop/DotHopLevel.gd")
var fe_text = "res://src/dotHop/dothop.txt"

func parse_game_def(force_reparse=false):
	if game_def == null or force_reparse:
		game_def = Puzz.parse_game_def(fe_text)
	return game_def

# Accepts a level number (which will fetch for the current game_def)
# or a list of strings representing the level (using the current game_def's legend)
# e.g. build_puzzle_node(["xoot"], "tutorial")
func build_puzzle_node(puzzle: Variant):
	if game_def == null:
		parse_game_def()

	var level_def
	if puzzle is int:
		if puzzle >= len(game_def.levels):
			Debug.warn("no puzzle at puzzle_num", puzzle)
			return
		level_def = game_def.levels[puzzle]
	elif puzzle is Array:
		level_def = Puzz.parse_level_def(puzzle)

	if level_def.shape == null:
		Debug.warn("no shape for puzzle - maybe it's just a message?", level_def)
		return

	var node = Node2D.new()

	node.set_script(level_script)
	node.game_def = game_def
	node.level_def = level_def
	return node

#####################################################################
## Dino game spec

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/dotHop")

func should_spawn_player(_scene):
	return false
