@tool
extends Node

func parse_game(path):
	# TODO make sure file exists
	var file = FileAccess.open(path, FileAccess.READ)
	var contents = file.get_as_text()
	var game = ParsedGame.new()
	var parsed = game.parse(contents)
	return parsed
