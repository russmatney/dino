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

	finished_initial_room_gen.connect(on_finished_initial_room_gen, CONNECT_ONE_SHOT)

	# spawn player in the load playground
	setup_player()
	playground.ready.connect(func():
		Dino.notif({type="banner", text="Loading...."})
		Debug.notif({msg="[Generating vania rooms!]", rich=true}))

	set_process(false)

	thread_room_generation({map_def=map_def})

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

func on_finished_initial_room_gen():
	var p = Dino.current_player_node()
	if p != null and is_instance_valid(p):
		p.queue_free()
		clear_playground()
		await get_tree().create_timer(0.4).timeout
		# TODO fun transition!
		# new room/game banner/notif, camera transition, etc
	(func():
		# we don't care for this until we load the first proper level
		get_tree().physics_frame.connect(_set_player_position, CONNECT_DEFERRED)

		load_initial_room()
		setup_player()
		).call_deferred()

func clear_playground():
	playground.queue_free()

## process #######################################################

func _process(_delta: float) -> void:
	# Join thread when it has finished.
	if not generating.is_alive():
		Log.pr("thread not alive, waiting....")
		generating.wait_to_finish()
		generating = null
		set_process(false)
		Log.pr("thread finished")

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

func load_initial_room():
	if room_defs.is_empty():
		Log.warn("No room_defs returned, did the generator fail?")
		return
	else:
		var rooms = room_defs.filter(func(rd): return rd.entities().any(func(ent): return ent.get_entity_id() == DinoEntityIds.PLAYERSPAWNPOINT))
		if rooms.is_empty():
			Log.warn("No room with player spawn point! Picking random start room")
			rooms = room_defs
		var rpath = rooms.pick_random().room_path
		_load_room(rpath, {setup=func(room):
			room.set_room_def(get_room_def(rpath))})

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
