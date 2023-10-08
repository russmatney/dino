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

func get_player_scene():
	# defaults to returning a 'player_scene' var
	if get("player_scene") == null:
		Debug.err("no player_scene set")
		# TODO try looking relative to current game (in player/Player.tscn)
		return
	return get("player_scene")

func on_player_spawned(_player):
	pass

func register_menus():
	if game_entity != null:
		Navi.set_pause_menu(game_entity.get_pause_menu())
		Navi.set_win_menu(game_entity.get_win_menu())
		Navi.set_death_menu(game_entity.get_death_menu())

# register menus and static zones/scenes you may need in Hotel
func register():
	register_menus()

func start(opts={}):
	# load the first level, maybe pull from a saved game
	# could accept params for which level to start
	Debug.warn("start() not implemented")

func update_world():
	# trigger any world update based on the player's position
	# (e.g. pausing/unpausing adjacent rooms)
	# Debug.warn("update_world not implemented")
	pass

# func get_spawn_coords():
# 	Debug.warn("get_spawn_coords not implemented")
