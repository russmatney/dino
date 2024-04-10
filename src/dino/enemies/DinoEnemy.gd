@tool
extends PandoraEntity
class_name DinoEnemy

## entity #######################################

func get_display_name() -> String:
	return get_string("display_name")

func get_label() -> String:
	return get_string("label")

func get_icon_texture() -> Texture:
	return get_resource("icon_texture")

func get_scene() -> PackedScene:
	return get_resource("scene")

func is_boss() -> bool:
	return get_bool("is_boss")

func data():
	return {
		display_name=get_display_name(),
		label=get_label(),
		icon_texture=get_icon_texture(),
		scene=get_scene(),
		is_boss=is_boss(),
		}

## static helpers #######################################

static func all_enemies():
	return Pandora.get_all_entities(Pandora.get_category(PandoraCategories.DINOENEMY))
