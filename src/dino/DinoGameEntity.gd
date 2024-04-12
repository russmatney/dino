@tool
class_name DinoGameEntity
extends PandoraEntity

## getters ##########################################################

func get_display_name() -> String:
	return get_string("display_name")

func get_icon_texture() -> Texture:
	return get_resource("icon_texture")

func is_enabled() -> bool:
	return get_bool("enabled")

func get_level_scene() -> PackedScene:
	return get_resource("level_scene")

func get_player_type() -> String:
	return get_string("player_type")

## data ##########################################################

func data():
	return {
		display_name=get_display_name(),
		icon_texture=get_icon_texture(),
		level_scene=get_level_scene(),
		}

## static helpers ##########################################################

static func basic_game_entities():
	return Pandora.get_all_entities(Pandora.get_category(PandoraCategories.DINOGAME))\
		.filter(func(e): return e.is_enabled())
