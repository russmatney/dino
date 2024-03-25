@tool
extends PandoraEntity
class_name DinoModeEntity

## entity #######################################

func get_display_name() -> String:
	return get_string("display_name")

func get_icon_texture() -> Texture:
	return get_resource("icon_texture")

func get_menu() -> PackedScene:
	return get_resource("menu")

func get_root_scene() -> PackedScene:
	return get_resource("root_scene")

func is_debug() -> bool:
	return get_bool("is_debug")

func data():
	return {
		display_name=get_display_name(),
		icon_texture=get_icon_texture(),
		menu=get_menu(),
		root_scene=get_root_scene(),
		is_debug=is_debug(),
		}

## static helpers #######################################

static func all_modes():
	return Pandora.get_all_entities(Pandora.get_category(PandoraCategories.DINOMODE))

static func get_fallback_mode():
	return all_modes().filter(func(m): return m.is_debug())[0]

## instance helpers #######################################

func nav_to_menu(opts={}):
	Navi.nav_to(get_menu(), opts)

func start(opts={}):
	Log.pr("Starting game", get_display_name())

	var	scene = get_root_scene()
	if scene:
		Navi.nav_to(scene, opts)
		return

	Log.warn("GameMode missing 'root_scene'", self)
