@tool
extends PandoraEntity
class_name DotHopTheme

func get_puzzle_scene() -> PackedScene:
	return get_resource("puzzle_scene")

func get_display_name() -> String:
	return get_string("display_name")

func is_unlocked() -> bool:
	return get_bool("is_unlocked")

func data():
	return {
		puzzle_scene=get_puzzle_scene(),
		name=get_display_name(),
		is_unlocked=is_unlocked(),
		}
