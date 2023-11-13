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

func get_singleton() -> Texture:
	return get_resource("game_singleton")

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

## data ##########################################################

func data():
	return {
		display_name=get_display_name(),
		icon_texture=get_icon_texture(),
		main_menu=get_main_menu(),
		pause_menu=get_pause_menu(),
		win_menu=get_win_menu(),
		death_menu=get_death_menu(),
		singleton=get_singleton(),
		scene_path_prefix=get_scene_path_prefix(),
		player_scene=get_player_scene(),
		first_level_scene=get_first_level_scene(),
		is_game_mode=is_game_mode(),
		}

## helpers ##########################################################

func manages_scene(scene):
	var prefix = get_scene_path_prefix()
	if prefix in [null, ""]:
		return false
	return scene.scene_file_path.begins_with(prefix)

func should_spawn_player(scene):
	# probably need an opt-in/out/option re: this default
	return not scene.scene_file_path.contains("menu")

## menus ##########################################################

func register_menus():
	Navi.set_pause_menu(get_pause_menu())
	Navi.set_win_menu(get_win_menu())
	Navi.set_death_menu(get_death_menu())

func _clear_menus():
	Navi.clear_menus()

## register/clean up ##########################################################

# register menus and static zones/scenes you may need in Hotel
func register():
	register_menus()

func cleanup():
	_clear_menus()

## start ##########################################################

# consider handling/passing opts here
func start(_opts={}):
	var	first_level = get_first_level_scene()

	if first_level:
		Navi.nav_to(first_level)
		return

	Log.warn("DinoGameEntity missing 'first_level'", self)

func update_world():
	# trigger any world update based on the player's position
	# (e.g. pausing/unpausing adjacent rooms)
	# Log.warn("update_world not implemented")
	pass

# func get_spawn_coords():
# 	Log.warn("get_spawn_coords not implemented")
