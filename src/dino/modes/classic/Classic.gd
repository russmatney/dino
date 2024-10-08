@tool
extends Node2D

## vars ##################################################3

@export var player_entity: DinoPlayerEntity
var game_node: Node2D

@export var _seed: int
@export var set_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			_seed = randi()

var current_map_def: MapDef

signal game_complete

@export var map_def: MapDef

@onready var game_complete_scene = preload("res://src/dino/menus/GameModeCompleteOverlay.tscn")

var quick_select_scene = preload("res://src/components/quick_select/QuickSelect.tscn")
var quick_select_menu

## to_pretty #################################################

func to_pretty():
	if Engine.is_editor_hint():
		# TODO log.gd ignoring to_pretty nulls
		return null
	return [_seed, current_map_def, map_def]

## ready ##################################################3

func _ready():
	Dino.set_game_mode(Pandora.get_entity(ModeIds.CLASSICSS))
	Dino.notif({type="banner", text="Classic Mode",})

	game_complete.connect(_on_game_complete)

	if not Engine.is_editor_hint():
		if quick_select_menu == null:
			quick_select_menu = quick_select_scene.instantiate()
			add_child(quick_select_menu)
		quick_select_menu.hide_menu()

		if not Dino.current_player_entity():
			if player_entity == null:
				await quick_select_menu.show_menu({
					# TODO only-unlocked/random-subset selection
					entities=DinoPlayerEntity.all_entities(),
					on_select=func(ent): player_entity = ent,
					})

				Dino.create_new_player({entity=player_entity})

		start_game()

## start_game ##################################################3

func start_game():
	reset_data()

	var def = next_map_def()

	if def:
		launch_level(def)
		return

	Log.warn("No map_def to launch in start_game")

# return null if there are no more map defs
func next_map_def():
	var idx = map_def.sub_map_defs.find(current_map_def)
	idx += 1
	if idx < len(map_def.sub_map_defs):
		var def = map_def.sub_map_defs[idx]
		if map_def.input and def.input and not def.input.skip_merge:
			# the root mapdef's input is the base for all sub_map_def inputs
			def.input = map_def.input.merge(def.input)
		return def

# supports restarting from the beginning
func reset_data():
	current_map_def = null

## launch_game ##################################################3

func launch_level(def):
	current_map_def = def

	if game_node:
		remove_child.call_deferred(game_node)
		game_node.queue_free()
		await game_node.tree_exited

	game_node = current_map_def.new_game_node({seed=_seed, })
	add_child.call_deferred(game_node)

	game_node.level_complete.connect(_on_level_complete, CONNECT_DEFERRED)

## game level signals ##################################################3

func _on_level_complete():
	Dino.notif({type="banner", text="Level Complete",})

	# Should the vania level complete transitions live here? (instead of in vaniaGame.gd)
	# slow-mo, zoom in on player
	# popup score screen with awards/progress/stats
	# (quest data, misc fun ideas ('fighter stance': 500 pts))

	var def = next_map_def()
	if def:
		launch_level(def)
	else:
		game_complete.emit()

var complete_overlay

func toggle_pause_game_nodes(should_pause=null):
	var nodes = []
	var p = Dino.current_player_node()
	if p:
		nodes.append(p)

	U.toggle_pause_nodes(should_pause, nodes)

func _on_game_complete():
	# Dino.notif({type="banner", text="Game Complete",})
	toggle_pause_game_nodes(true)

	game_node.hide_overlays()

	# show score/high scores, stats, button for credits, main-menu, replay new seed
	if complete_overlay == null:
		complete_overlay = game_complete_scene.instantiate()

		complete_overlay.ready.connect(func():
			complete_overlay.anim_show({
				header="Classic game complete!!",
				subhead="Way to go!",
				}))
		add_child(complete_overlay)
