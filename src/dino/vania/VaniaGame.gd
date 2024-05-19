extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name VaniaGame

## static #######################################################

static func create_game_node(def: MapDef, _opts={}):
	var vania_game_scene = load("res://src/dino/vania/VaniaGame.tscn")
	var game_node = vania_game_scene.instantiate()
	game_node.map_def = def
	return game_node

# func to_pretty():
# 	return {level_def=level_def.get_display_name()}

## vars #######################################################

var generator = VaniaGenerator.new()
var VaniaRoomTransitions = "res://src/dino/vania/VaniaRoomTransitions.gd"
var PassageAutomapper = "res://addons/MetroidvaniaSystem/Template/Scripts/Modules/PassageAutomapper.gd"

@onready var pcam: PhantomCamera2D = $PhantomCamera2D
@onready var playground: Node2D = $%LoadingPlayground

@onready var screen_blur: Control = $%ScreenBlur

@onready var ready_overlay: Control = $%ReadyToPlay
var ready_to_play: bool = false
@onready var start_game_action_icon: ActionInputIcon = $%StartGameAction

@onready var level_start_overlay: Control = $%LevelStart


var room_defs: Array[VaniaRoomDef] = []
@export var map_def: MapDef

var generating: Thread

signal finished_initial_room_gen
signal level_complete

## room_states #################################################

var room_states = {}
var initial_room_state = {visited=false, quests_complete=false}

func clear_room_states(opts={}):
	if opts.get("keep_current", false):
		room_states = {MetSys.get_current_room_name(): room_states[MetSys.get_current_room_name()]}
	else:
		room_states = {}

func init_room_state(room_path):
	room_states[room_path] = initial_room_state.duplicate()

func existing_room_state(room_path):
	return room_path in room_states

func is_room_visited(room_path=null):
	if room_path == null:
		room_path = MetSys.get_current_room_name()
	return room_states[room_path].visited

func mark_room_visited(room_path=null):
	if room_path == null:
		room_path = MetSys.get_current_room_name()
	room_states[room_path].visited = true

func are_room_quests_complete(room_path=null):
	if room_path == null:
		room_path = MetSys.get_current_room_name()
	return room_states[room_path].quests_complete

func all_room_quests_complete():
	return room_states.values().all(func(st): return st.quests_complete)

func mark_room_quests_complete(room_path=null):
	if room_path == null:
		room_path = MetSys.get_current_room_name()
	room_states[room_path].quests_complete = true

## ready #######################################################

func _ready():
	add_custom_module.call_deferred(VaniaRoomTransitions)
	add_custom_module.call_deferred(PassageAutomapper)

	room_loaded.connect(on_room_loaded, CONNECT_DEFERRED)
	# MetSys.cell_changed.connect(on_cell_changed, CONNECT_DEFERRED)
	# Dino.player_ready.connect(on_player_ready)

	finished_initial_room_gen.connect(show_ready_overlay, CONNECT_ONE_SHOT)

	# spawn player in the load playground
	setup_player()
	playground.ready.connect(func():
		Dino.notif({type="banner", text="Loading...."})
		Debug.notif({msg="[Generating vania rooms!]", rich=true}))

	show_playground()
	ready_overlay.modulate.a = 0.0

	level_start_overlay.modulate.a = 0.0

	start_game_action_icon.set_icon_for_action("ui_accept")

	set_process(false)

	thread_room_generation({map_def=map_def})

## room loaded #######################################################

func on_room_loaded():
	if not is_room_visited():
		Dino.notif({type="banner",
			text="%s" % map.name,
			id="room-name"
			})
	mark_room_visited()

	var qm = map.quest_manager

	qm.quest_complete.connect(func(quest):
		Log.pr("quest complete", quest))

	qm.all_quests_complete.connect(func():
		mark_room_quests_complete()

		# TODO confetti particles?
		# TODO update room on mini-map
		# TODO door open/close logic

		# all quests in all rooms complete?
		if all_room_quests_complete():
			level_complete.emit()

		, CONNECT_ONE_SHOT)

## input #######################################################

func _unhandled_input(event):
	if ready_to_play and Trolls.is_accept(event):
		start_vania_game()

## transition #######################################################

func show_ready_overlay():
	Anim.fade_in(ready_overlay, 1.0)

	screen_blur.anim_blur({duration=1.0, target=0.6})
	screen_blur.anim_gray({duration=1.0, target=1.0})

	# maybe wait a second before flipping this?
	ready_to_play = true

func hide_ready_overlay():
	Anim.fade_out(ready_overlay, 0.7)
	ready_to_play = false

func load_initial_room():
	if room_defs.is_empty():
		Log.warn("No room_defs returned, did the generator fail?")
		return

	var rooms = room_defs.filter(func(rd): return rd.entities().any(func(ent): return ent.get_entity_id() == DinoEntityIds.PLAYERSPAWNPOINT))
	if rooms.is_empty():
		Log.warn("No room with player spawn point! Isn't this 'guaranteed' elsewhere?")
		rooms = room_defs
	# prefer first room def, but consider opts/mode from mapDef
	var rpath = rooms[0].room_path
	_load_room(rpath, {setup=func(room):
		room.set_room_def(get_room_def(rpath))})

func show_playground():
	var anim_nodes = []

	var p = Dino.current_player_node()
	if p != null and is_instance_valid(p):
		anim_nodes.append(p)

	for ch in playground.get_children():
		anim_nodes.append(ch)

	var time = 0.6

	screen_blur.anim_blur({duration=1.0, target=0.0})
	screen_blur.anim_gray({duration=1.0, target=0.0})

	await Anim.animate_intro_from_point({
		node=playground, nodes=anim_nodes, position=Vector2(), t=time,
		})

func clear_playground():
	var anim_nodes = []

	var p = Dino.current_player_node()
	if p != null and is_instance_valid(p):
		anim_nodes.append(p)

	for ch in playground.get_children():
		anim_nodes.append(ch)

	var time = 0.6

	screen_blur.fade_in({duration=time})
	screen_blur.anim_gray({duration=time, target=1.0})

	await Anim.animate_outro_to_point({
		node=playground, nodes=anim_nodes, position=Vector2(), t=time,
		})

	if p != null and is_instance_valid(p):
		p.queue_free()

	playground.queue_free()

	# give the player time to free
	await get_tree().create_timer(0.1).timeout

func toggle_pause_game_nodes(should_pause=null):
	var nodes = [map]
	var p = Dino.current_player_node()
	if p != null and is_instance_valid(p):
		nodes.append(p)

	U.toggle_pause_nodes(should_pause, nodes)

# clears the playground, hides the ready-overlay, loads the initial room, and sets up the player
# can be fired if ready_to_play is true
func start_vania_game():
	await clear_playground()

	hide_ready_overlay()

	get_tree().physics_frame.connect(_set_player_position, CONNECT_DEFERRED)

	load_initial_room()
	setup_player()
	toggle_pause_game_nodes(true)

	var t1 = 0.7
	screen_blur.anim_blur({duration=t1, target=1.0})
	screen_blur.anim_gray({duration=t1, target=1.0})
	Anim.fade_in(level_start_overlay, t1)
	await get_tree().create_timer(2.0).timeout

	var t2 = 0.7
	screen_blur.anim_blur({duration=t2, target=0.0})
	screen_blur.anim_gray({duration=t2, target=0.0})
	Anim.fade_out(level_start_overlay, t2)
	await get_tree().create_timer(t2).timeout

	toggle_pause_game_nodes(false)


## process #######################################################

func _process(_delta: float) -> void:
	# Join thread when it has finished.
	if not generating.is_alive():
		Log.pr("thread not alive, waiting....")
		generating.wait_to_finish()
		generating = null
		set_process(false)
		Log.pr("thread finished and joined")

		finished_initial_room_gen.emit()

## room gen #######################################################

func thread_room_generation(opts):
	if generating:
		# thread already running
		return

	clear_room_states()
	VaniaGenerator.remove_generated_cells()

	# The thread that does map generation.
	generating = Thread.new()
	var res = generating.start(generate_rooms.bind(opts))
	if res != OK:
		Log.error("Error starting generation thread", res)
	set_process(true)

func generate_rooms(opts={}):
	MetSys.reset_state()
	MetSys.set_save_data()

	var m_def = opts.get("map_def", map_def)
	if not m_def:
		Log.warn("Using fallback map_def in VaniaGame")
		m_def = MapDef.default_game()

	room_defs = generator.generate_map(m_def)

	for rd in room_defs:
		for coord in rd.map_cells:
			MetSys.discover_cell(coord)
		init_room_state(rd.room_path)

## public regen funcs #######################################################

func increment_room_count():
	add_new_room(1)

func decrement_room_count():
	remove_room(1)

# regenerate rooms besides the current one
func regenerate_other_rooms():
	var other_room_defs = []
	for rd in room_defs:
		if MetSys.get_current_room_name() == rd.room_path:
			continue
		other_room_defs.append(rd)

	var new_room_defs = VaniaRoomDef.to_defs(MapDef.random_room())
	generator.remove_rooms(other_room_defs)
	room_defs = generator.add_rooms(new_room_defs)

	# maintain room state across other room regen
	clear_room_states({keep_current=true})
	for rd in room_defs:
		for coord in rd.map_cells:
			MetSys.discover_cell(coord)
		if MetSys.get_current_room_name() != rd.room_path:
			init_room_state(rd.room_path)

	# redo the current room's doors
	if map and map.is_node_ready():
		map.setup_walls_and_doors()

func add_new_room(count=1):
	# TODO these inputs reading from vania-menu configged constraints
	var new_room_defs = VaniaRoomDef.to_defs(MapDef.random_rooms({count=count}))
	room_defs = generator.add_rooms(new_room_defs)
	Log.info(len(new_room_defs), " rooms added")

	for rd in room_defs:
		for coord in rd.map_cells:
			MetSys.discover_cell(coord)
		if not existing_room_state(rd.room_path):
			init_room_state(rd.room_path)

	# redo the current room's doors
	if map and map.is_node_ready():
		map.setup_walls_and_doors()

func remove_room(count=1):
	var other_room_defs: Array[VaniaRoomDef] = []
	for rd in room_defs:
		if MetSys.get_current_room_name() == rd.room_path:
			continue
		other_room_defs.append(rd)

	var room_defs_to_remove: Array[VaniaRoomDef] = []
	other_room_defs.reverse() # prefer to remove the latest room for now
	for rd in other_room_defs:
		if len(room_defs_to_remove) >= count:
			break
		room_defs_to_remove.append(rd)

	room_defs = generator.remove_rooms(room_defs_to_remove)

	Log.info(len(room_defs_to_remove), " rooms removed")

	# redo the current room's doors
	if map and map.is_node_ready():
		map.setup_walls_and_doors()

## load room #######################################################

# overwriting metsys's Game.load_room to support 'setup' and setting a default layer
func _load_room(path: String, opts={}):
	if not path.is_absolute_path():
		path = MetSys.get_full_room_path(path)

	if map:
		map.queue_free()
		await map.tree_exited
		map = null

	map = load(path).instantiate()
	if opts.get("setup"):
		opts.get("setup").call(map)
	add_child(map)

	if MetSys.get_current_room_instance() != null:
		MetSys.current_layer = MetSys.get_current_room_instance().get_layer()
	else:
		Log.warn("No current room_instance, defaulting to layer 0")
		MetSys.current_layer = 0

	room_loaded.emit()

func reload_current_room():
	MetSys.room_changed.emit(MetSys.get_current_room_name(), false)

## player #######################################################

func setup_player():
	if not Dino.current_player_entity():
		Dino.create_new_player({
			entity=Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER),
			})

	var def = current_room_def()
	if Dino.current_player_node():
		Dino.respawn_active_player({level_node=self, deferred=false,
			genre_type=def.genre_type() if def else null
			})
	else:
		Dino.spawn_player({level_node=self, deferred=false,
			genre_type=def.genre_type() if def else null
			})

func _set_player_position():
	var p = Dino.current_player_node()
	if p and is_instance_valid(p):
		MetSys.set_player_position(p.position)

## room defs #######################################################

func get_room_def(path):
	for rd in room_defs:
		if path == rd.room_path:
			return rd

func current_room_def():
	var path = MetSys.get_current_room_name()
	return get_room_def(path)

# i wonder if these ever get out sync
func current_room_def_alt():
	if map:
		return map.room_def

## metsys misc #######################################################

func add_custom_module(module_path: String):
	modules.append(load(module_path).new(self))
