@tool
extends DinoGame

#####################################################################
## vars

var game_def
var level_script = preload("res://src/flowerEater/levels/Level.gd")
var fe_text = "res://src/flowerEater/flowereater.txt"

func parse_game_def(force_reparse=false):
	if game_def == null or force_reparse:
		game_def = Puzz.parse_game_def(fe_text)
	return game_def

func build_puzzle_node(puzzle_num):
	if game_def == null:
		parse_game_def()

	if puzzle_num >= len(game_def.levels):
		Debug.warn("no puzzle at puzzle_num", puzzle_num)
		return

	var node = Node2D.new()
	node.set_script(level_script)
	node.game_def = game_def
	node.level_def = game_def.levels[puzzle_num]
	return node

#####################################################################
## Dino game spec

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/flowerEater")

func should_spawn_player(_scene):
	return false
