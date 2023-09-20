@tool
class_name DinoGame
extends Node

var game_entity: DinoGameEntity

# TODO delete all these (and pull from game_entity)
var icon_texture
var main_menu_scene
var pause_menu_scene
var win_menu_scene
var death_menu_scene

func _enter_tree():
	Game.register_game(self)
	# Debug.error("_entry_tree() should assign game_entity", self)

func _ready():
	Debug.pr("dino game ready", self, game_entity)
	if game_entity != null:
		main_menu_scene = game_entity.get_main_menu_scene()
		icon_texture = game_entity.get_icon_texture()


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
		Navi.set_pause_menu(game_entity.get_pause_menu_scene())
		Navi.set_win_menu(game_entity.get_win_menu_scene())
		Navi.set_death_menu(game_entity.get_death_menu_scene())

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

func manages_scene(_scene):
	# return true if the passed scene is managed by this game
	Debug.warn("manages_scene not implemented")

	# TODO impl fallback based on current game
	# return scene.scene_file_path.begins_with("res://src/hatbot")

func should_spawn_player(_scene):
	return true
