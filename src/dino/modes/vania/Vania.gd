extends Node2D
class_name Vania

## static #############################################

static func reset_metsys_context(game, metsys_settings):
	# only run if the settings actually change
	if MetSys.settings == metsys_settings:
		Log.info("skipping MetSys reset, in same context", game)
		return
	Log.info("resetting MetSys context", game)
	MetSys.settings = metsys_settings

	# this is typically already connected
	U._connect(MetSys.settings.theme_changed, MetSys._update_theme)
	MetSys._update_theme()

	if Engine.is_editor_hint() and MetSys.plugin != null:
		var db_main = MetSys.plugin.main
		if db_main:
			# calls Database/Main.tscn.reload_map()
			db_main.reload_map()
		else:
			Log.warn("Metsys/Database/Main node not found, could not reset metsys context", db_main)
	else:
		# non-editor map data reload
		# TODO be sure the minimap updates as expected

		# this bit from Database/Manage.tscn.force_reload()
		MetSys.map_data = MetSys.MapData.new()
		MetSys.map_data.load_data()
		for group in MetSys.map_data.cell_groups.values():
			var i: int = 0
			while i < group.size():
				if MetSys.map_data.get_cell_at(group[i]):
					i += 1
				else:
					group.remove_at(i)

## vars ##################################################3

@export var player_entity: DinoPlayerEntity
@export var map_def: MapDef

var game_node: Node2D

@export var set_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			Dino.reseed()

signal game_complete

var quick_select_scene = preload("res://src/components/quick_select/QuickSelect.tscn")
var quick_select_menu

## to_pretty ##################################################3

func to_pretty():
	return [player_entity, map_def]

## ready ##################################################3

func _ready():
	Dino.set_game_mode(Pandora.get_entity(ModeIds.VANIA))
	Dino.notif({type="banner", text="Vania",})

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
	# establish current player stack
	if not Dino.current_player_entity():
		Dino.create_new_player({entity=player_entity})

	# clear current game if there is one
	if game_node:
		remove_child.call_deferred(game_node)
		game_node.queue_free()

	if not map_def:
		Log.warn("No vania map_def set, picking a fallback")
		map_def = MapDef.mixed_genre_game()
		# map_def = MapDef.arcade_game()
		# map_def = MapDef.topdown_game()
		# map_def = MapDef.default_game()
		# map_def = MapDef.village()

	game_node = VaniaGame.create_game_node(map_def)

	add_child.call_deferred(game_node)

	game_node.level_complete.connect(_on_level_complete)

## set #################################333

func set_map_def(def: MapDef):
	map_def = def

func _on_level_complete():
	Dino.notif({type="banner", text="Level Complete",})

	# TODO slow-mo, score screen with awards/progress/stats
	# (quest data, misc fun ideas ('fighter stance': 500 pts))

	# var def = next_level_def()
	# if def:
	# 	launch_level(def)
	# else:

	game_complete.emit()

func _on_game_complete():
	Dino.notif({type="banner", text="Game Complete",})

	# toss the game node!
	# TODO clear metsys maps?
	if game_node:
		remove_child.call_deferred(game_node)
		game_node.queue_free()

	# TODO win menu instead of forced nav
	# show high scores, stats, button for credits, main-menu, replay new seed
	Navi.nav_to_main_menu()
