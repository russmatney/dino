@tool
extends PandoraEntity
class_name DotHopPuzzleSet

func get_puzzle_script_file() -> PackedScene:
	return get_resource("puzzle_script_file")

func get_display_name() -> String:
	return get_string("display_name")

func data():
	return {
		puzzle_script_file=get_puzzle_script_file(),
		name=get_display_name(),
		}
