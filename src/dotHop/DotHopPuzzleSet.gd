@tool
extends PandoraEntity
class_name DotHopPuzzleSet

var fallback_puzzle_set = "res://src/dotHop/dothop.txt"

func get_puzzle_script_path() -> String:
	var res = get_string("puzzle_script_path")
	if res == null or res == "":
		return fallback_puzzle_set
	return res

func get_display_name() -> String:
	return get_string("display_name")

func get_theme() -> DotHopTheme:
	return get_resource("theme")

func data():
	return {
		puzzle_script_path=get_puzzle_script_path(),
		name=get_display_name(),
		theme=get_theme(),
		}
