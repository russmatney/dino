@tool
class_name DinoGame
extends Node

var game_entity: DinoGameEntity

func _enter_tree():
	# find and assign the game entity
	var ent = Pandora.get_entity(DinoGameEntityIds.DOTHOP)
	var ents = Pandora.get_all_entities(Pandora.get_category(ent._category_id))
	for e in ents:
		var s = e.get_singleton()
		if s == null:
			continue
		if get_script().resource_path == s.resource_path:
			# NOTE this breaks when entities share a singleton...?
			game_entity = e
			break

func on_player_spawned(_player):
	pass

func register_menus():
	if game_entity != null:
		Navi.set_pause_menu(game_entity.get_pause_menu())
		Navi.set_win_menu(game_entity.get_win_menu())
		Navi.set_death_menu(game_entity.get_death_menu())

func _clear_menus():
	Navi.clear_menus()

# register menus and static zones/scenes you may need in Hotel
func register():
	register_menus()

func cleanup():
	_clear_menus()

# consider handling/passing opts here
func start(_opts={}):
	var first_level

	if game_entity != null:
		first_level = game_entity.get_first_level_scene()
	else:
		Debug.warn("DinoGame.start() missing 'game_entity'")

	if first_level:
		Navi.nav_to(first_level)
		return

	Debug.warn("DinoGame.start() missing 'first_level'")

func update_world():
	# trigger any world update based on the player's position
	# (e.g. pausing/unpausing adjacent rooms)
	# Debug.warn("update_world not implemented")
	pass

# func get_spawn_coords():
# 	Debug.warn("get_spawn_coords not implemented")
