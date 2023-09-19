@tool
class_name DinoGame
extends Node

var game_entity: DinoGameEntity

## Register self with Games list
func _enter_tree():
	Game.register_game(self)

var icon_texture = preload("res://addons/core/assets/icons/dino_sheet.png")

func get_player_scene():
	# defaults to returning a 'player_scene' var
	if get("player_scene") == null:
		Debug.err("no player_scene set")
		# TODO try looking relative to current game (in player/Player.tscn)
		return
	return get("player_scene")

func on_player_spawned(_player):
	pass

var main_menu_scene
@onready var pause_menu_scene = Navi.pause_menu_scene
@onready var win_menu_scene = Navi.win_menu_scene
@onready var death_menu_scene = Navi.death_menu_scene

func register_menus():
	Navi.set_pause_menu(pause_menu_scene)
	Navi.set_win_menu(win_menu_scene)
	Navi.set_death_menu(death_menu_scene)

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
