@tool
class_name DinoGameEntity
extends PandoraEntity

func get_display_name() -> String:
	return get_string("display_name")

func get_icon_texture() -> Texture:
	return get_resource("icon_texture")

func get_main_menu() -> PackedScene:
	return get_resource("main_menu")

func get_pause_menu() -> PackedScene:
	return get_resource("pause_menu")

func get_win_menu() -> PackedScene:
	return get_resource("win_menu")

func get_death_menu() -> PackedScene:
	return get_resource("death_menu")

func get_singleton() -> Texture:
	return get_resource("game_singleton")

func data():
	return {
		display_name=get_display_name(),
		icon_texture=get_icon_texture(),
		main_menu=get_main_menu(),
		pause_menu=get_pause_menu(),
		win_menu=get_win_menu(),
		death_menu=get_death_menu(),
		singleton=get_singleton(),
		}
