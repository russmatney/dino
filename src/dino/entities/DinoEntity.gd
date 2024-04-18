@tool
extends PandoraEntity
class_name DinoEntity

## entity #######################################

func get_display_name() -> String:
	return get_string("display_name")

func get_label() -> String:
	return get_string("label")

func get_icon_texture() -> Texture:
	return get_resource("icon_texture")

func has_scene() -> bool:
	return has_entity_property("scene")

func get_scene() -> PackedScene:
	return get_resource("scene")

func data():
	return {
		display_name=get_display_name(),
		label=get_label(),
		# icon_texture=get_icon_texture(),
		# scene=get_scene(),
		}

## static helpers #######################################

static func all_entities():
	return Pandora.get_all_entities(Pandora.get_category(PandoraCategories.DINOENTITY))\
		.filter(func(ent): return ent.has_scene())

static func get_entity_scene(ent_id):
	return Pandora.get_entity(ent_id).get_scene()
