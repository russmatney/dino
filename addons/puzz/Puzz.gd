@tool
extends Node

func parse_game_def(path):
	# TODO make sure file exists
	var file = FileAccess.open(path, FileAccess.READ)
	var contents = file.get_as_text()
	var game = ParsedGame.new()
	var parsed = game.parse(contents)
	return parsed

func parse_level_def(lines, msg=null):
	return ParsedGame.new().parse_level(lines, msg)

func get_cell_objects(parsed, cell):
	if cell == null:
		return

	# note the duplicate here, so the returned array doesn't share state with every other cell
	var objs = parsed.legend.get(cell).duplicate()
	# TODO if or/and in objs, lookup again
	return objs
