@tool
class_name DinoGameEntity
extends PandoraEntity

func get_display_name() -> String:
	return get_string("display_name")

func get_icon_texture() -> Texture:
	return get_resource("icon_texture")

func get_main_menu_scene() -> PackedScene:
	return get_resource("main_menu_scene")

func get_pause_menu_scene() -> PackedScene:
	return get_resource("pause_menu_scene")

func get_win_menu_scene() -> PackedScene:
	return get_resource("win_menu_scene")

func get_death_menu_scene() -> PackedScene:
	return get_resource("death_menu_scene")

func data():
	return {
		display_name=get_display_name(),
		icon_texture=get_icon_texture(),
		main_menu_scene=get_main_menu_scene(),
		pause_menu_scene=get_pause_menu_scene(),
		win_menu_scene=get_win_menu_scene(),
		death_menu_scene=get_death_menu_scene(),
		}
