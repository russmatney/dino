@tool
extends PandoraEntity
class_name LevelDef

## entity #######################################

func get_display_name() -> String:
	return get_string("display_name")

func get_icon_texture() -> Texture:
	return get_resource("icon_texture")

func get_def_path() -> String:
	return get_string("def_path")

func get_level_gen_script() -> Script:
	return get_resource("level_gen_script")

func get_tiles_scene() -> PackedScene:
	return get_resource("tiles_scene")

func get_base_square_size() -> int:
	return get_integer("base_square_size")

func data():
	return {
		display_name=get_display_name(),
		icon_texture=get_icon_texture(),
		def_path=get_def_path(),
		level_gen_script=get_level_gen_script(),
		tiles_scene=get_tiles_scene(),
		base_square_size=get_base_square_size(),
		}

## static helpers #######################################

static func all_defs():
	return Pandora.get_all_entities(Pandora.get_category(PandoraCategories.LEVELDEF))
