@tool
extends Node

func parse_game(path):
	# TODO make sure file exists
	var file = FileAccess.open(path, FileAccess.READ)
	var contents = file.get_as_text()
	var game = ParsedGame.new()
	var parsed = game.parse(contents)
	return parsed

func get_cell_objects(parsed, cell):
	if cell == null:
		return

	var objs = parsed.legend.get(cell)
	# TODO if or/and in objs, lookup again
	return objs
