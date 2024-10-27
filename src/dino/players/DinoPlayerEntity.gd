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

func supports_genre(genre: DinoData.GenreType) -> bool:
	match genre:
		DinoData.GenreType.SideScroller:
			return get_sidescroller_scene() != null
		DinoData.GenreType.TopDown:
			return get_topdown_scene() != null
		DinoData.GenreType.BeatEmUp:
			return get_beatemup_scene() != null
	return false


func is_disabled() -> bool:
	return get_bool("is_disabled")

## data ##########################################################

func data():
	return {
		display_name=get_display_name(),
		is_disabled=is_disabled(),
		icon_texture=get_icon_texture(),
		sidescroller_scene=get_sidescroller_scene(),
		topdown_scene=get_topdown_scene(),
		beatemup_scene=get_beatemup_scene(),
		}

## static #################################################

static func all_entities():
	return Pandora.get_all_entities(Pandora.get_category(PandoraCategories.DINOPLAYER)).\
		filter(func(ent): return not ent.is_disabled())

static func get_random(opts: Dictionary={}):
	var entities = DinoPlayerEntity.all_entities()

	if opts.get("genre"):
		entities.filter(func(ent):
			return ent.supports_genre(opts.get("genre")))

	return U.rand_of(entities)

## instance #################################################

func get_player_scene(genre_type: DinoData.GenreType) -> PackedScene:
	match genre_type:
		DinoData.GenreType.SideScroller: return get_sidescroller_scene()
		DinoData.GenreType.TopDown: return get_topdown_scene()
		DinoData.GenreType.BeatEmUp: return get_beatemup_scene()
		_:
			Log.warn("no match in get_player_scene, returning fallback", self)
			return get_sidescroller_scene()

func get_genre_type_for_scene(path: String) -> DinoData.GenreType:
	var ss = get_sidescroller_scene().resource_path
	var td = get_topdown_scene().resource_path
	var beu = get_beatemup_scene().resource_path
	var matches = {
		ss: DinoData.GenreType.SideScroller,
		td: DinoData.GenreType.TopDown,
		beu: DinoData.GenreType.BeatEmUp,
		}
	if path in matches:
		return matches[path]
	else:
		Log.warn("no match in get_genre_type_for_scene, returning fallback", self)
		return DinoData.GenreType.SideScroller
