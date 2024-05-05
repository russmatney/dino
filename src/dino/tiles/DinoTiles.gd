@tool
extends PandoraEntity
class_name DinoTiles

## entity #######################################

func get_display_name() -> String:
	return get_string("display_name")

func get_scene() -> PackedScene:
	var sc = get_resource("scene")
	# is this a thing?
	# should overwrite the grid defs specified in the scene
	# maybe better done via DinoTileMap.gd, or in vania room
	# sc.chunks_path = get_string("grid_defs_path")
	return sc

func get_grid_defs():
	# TODO cache/don't reparse for the same defs_path
	return GridParser.parse({defs_path=get_string("grid_defs_path")})

func data():
	return {
		display_name=get_display_name(),
		scene=get_scene(),
		}

## static helpers #######################################

static func all_tiles():
	return Pandora.get_all_entities(Pandora.get_category(PandoraCategories.DINOTILES))

static func get_entity_scene(ent_id):
	return Pandora.get_entity(ent_id).get_scene()

