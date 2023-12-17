@tool
class_name DinoPlayerEntity
extends PandoraEntity

## getters ##########################################################

func get_display_name() -> String:
	return get_string("display_name")

func get_icon_texture() -> Texture:
	return get_resource("icon_texture")

func get_sidescroller_scene() -> PackedScene:
	return get_resource("sidescroller_scene")

func get_topdown_scene() -> PackedScene:
	return get_resource("topdown_scene")

func get_beatemup_scene() -> PackedScene:
	return get_resource("beatemup_scene")

## data ##########################################################

func data():
	return {
		display_name=get_display_name(),
		icon_texture=get_icon_texture(),
		sidescroller_scene=get_sidescroller_scene(),
		topdown_scene=get_topdown_scene(),
		beatemup_scene=get_beatemup_scene(),
		}

## static #################################################

static func all_entities():
	var ent = Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER)
	return Pandora.get_all_entities(Pandora.get_category(ent._category_id))

## instance #################################################

func get_player_scene(type: DinoData.GameType) -> PackedScene:
	match type:
		DinoData.GameType.SideScroller: return get_sidescroller_scene()
		DinoData.GameType.TopDown: return get_topdown_scene()
		DinoData.GameType.BeatEmUp: return get_beatemup_scene()
		_:
			Log.warn("no match in get_player_scene, returning fallback", self)
			return get_sidescroller_scene()
