@tool
class_name DinoGameEntity
extends PandoraEntity

## getters ##########################################################

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

func get_scene_path_prefix() -> String:
	return get_string("scene_path_prefix")

func get_player_scene() -> PackedScene:
	return get_resource("player_scene")

func is_enabled() -> bool:
	return get_bool("enabled")

func get_first_level_scene() -> PackedScene:
	return get_resource("first_level")

func is_game_mode() -> bool:
	if (is_instance() and _instance_properties.has("is_game_mode")) or has_entity_property("is_game_mode"):
		return get_bool("is_game_mode")
	return false

func get_player_type() -> String:
	return get_string("player_type")

## data ##########################################################

func data():
	return {
		display_name=get_display_name(),
		icon_texture=get_icon_texture(),
		main_menu=get_main_menu(),
		pause_menu=get_pause_menu(),
		win_menu=get_win_menu(),
		death_menu=get_death_menu(),
		scene_path_prefix=get_scene_path_prefix(),
		player_scene=get_player_scene(),
		first_level_scene=get_first_level_scene(),
		is_game_mode=is_game_mode(),
		}

## helpers ##########################################################

func manages_scene(scene_file_path):
	var prefix = get_scene_path_prefix()
	if prefix in [null, ""]:
		return false
	return scene_file_path.begins_with(prefix)

## static helpers ##########################################################

static func all_game_entities():
	var ent = Pandora.get_entity(DinoGameEntityIds.SHIRT)
	return Pandora.get_all_entities(Pandora.get_category(ent._category_id))\
		.filter(func(e): return e.is_enabled())

static func basic_game_entities():
	return DinoGameEntity.all_game_entities().filter(func(e): return not e.is_game_mode())
