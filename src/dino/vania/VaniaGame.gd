extends Node
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

var player: Node2D
var current_room: Node2D

var modules: Array
signal room_loaded

var generator = VaniaGenerator.new()

@onready var pcam: PhantomCamera2D = $PhantomCamera2D
@onready var playground: Node2D = $%LoadingPlayground

@onready var screen_blur: Control = $%ScreenBlur

var ready_to_play: bool = false
@onready var ready_overlay: Control = $%ReadyToPlay
@onready var start_game_action_icon: ActionInputIcon = $%StartGameAction

@onready var level_start_overlay: Control = $%LevelStart
@onready var level_start_header: RichTextLabel = $%LevelStartHeader
@onready var level_start_subhead: RichTextLabel = $%LevelStartSubhead
@onready var level_start_countdown: RichTextLabel = $%LevelStartCountdown

var ready_for_next: bool = false
@onready var level_complete_overlay: Control = $%LevelComplete
@onready var level_complete_header: RichTextLabel = $%LevelCompleteHeader
@onready var level_complete_subhead: RichTextLabel = $%LevelCompleteSubhead
@onready var level_complete_action: Control = $%LevelCompleteAction
@onready var level_complete_action_icon: ActionInputIcon = $%LevelCompleteActionIcon

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
	if room_path not in room_states:
		Log.warn("Current room_path not in room_states?!?")
		return
	return room_states[room_path].visited

func mark_room_visited(room_path=null):
	if room_path == null:
		room_path = MetSys.get_current_room_name()
	if room_path not in room_states:
		Log.warn("Current room_path not in room_states?!?")
		return
	room_states[room_path].visited = true

func are_room_quests_complete(room_path=null):
	if room_path == null:
		room_path = MetSys.get_current_room_name()
	if room_path not in room_states:
		Log.warn("Current room_path not in room_states?!?")
		return
	return room_states[room_path].quests_complete

func all_room_quests_complete():
	return room_states.values().all(func(st): return st.quests_complete)

func mark_room_quests_complete(room_path=null):
	if room_path == null:
		room_path = MetSys.get_current_room_name()
	if room_path not in room_states:
		Log.warn("Current room_path not in room_states?!?")
		return
	room_states[room_path].quests_complete = true

## ready #######################################################

func _ready():
	modules.append(VaniaRoomTransitions.new(self))

	# MetSys.cell_changed.connect(on_cell_changed, CONNECT_DEFERRED)
	# Dino.player_ready.connect(on_player_ready)

	finished_initial_room_gen.connect(show_ready_overlay, CONNECT_ONE_SHOT)

	# playground setup and notifs
	setup_player()
	Dino.notif({type="banner", text="Loading...."})
	Debug.notif({msg="[Generating vania rooms!]", rich=true})

	show_playground()

	hide_overlays()

	start_game_action_icon.set_icon_for_action("ui_accept")
	level_complete_action_icon.set_icon_for_action("ui_accept")

	set_process(false)

	thread_room_generation({map_def=map_def})

## add_child_to_level ###################################################3

func add_child_to_level(_node, child):
	if current_room and is_instance_valid(current_room):
		Log.pr("adding child to current room", child, "current room position: ", current_room.position)
		current_room.add_child(child)
	else:
		add_child(child)

func on_room_quest_complete(_quest):
	pass
	# Log.pr("quest complete", quest)

func on_room_quests_complete():
	mark_room_quests_complete()

	# TODO confetti particles?
	# TODO update room on mini-map
	# TODO door open/close logic

	if all_room_quests_complete():
		vania_game_complete()

## input #######################################################

func _unhandled_input(event):
	if ready_to_play and Trolls.is_accept(event):
		start_vania_game()
	if ready_for_next and Trolls.is_accept(event):
		level_complete.emit()

## transitions #######################################################

func hide_overlays():
	ready_overlay.modulate.a = 0.0
	level_start_overlay.modulate.a = 0.0
	level_complete_overlay.modulate.a = 0.0
	screen_blur.reset()

func toggle_pause_game_nodes(should_pause=null):
	var nodes = [current_room]
	var p = Dino.current_player_node()
	if p:
		nodes.append(p)

	U.toggle_pause_nodes(should_pause, nodes)

## ready overlay

func show_ready_overlay():
	Anim.fade_in(ready_overlay, 1.0)

	screen_blur.anim_blur({duration=1.0, target=0.6})
	screen_blur.anim_gray({duration=1.0, target=0.8})

	# maybe wait a second before flipping this?
	ready_to_play = true

func hide_ready_overlay():
	Anim.fade_out(ready_overlay, 0.7)
	ready_to_play = false

## playground

func show_playground():
	var anim_nodes = []

	var p = Dino.current_player_node()
	if p:
		anim_nodes.append(p)

	for ch in playground.get_children():
		if ch and is_instance_valid(ch):
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
	if p:
		anim_nodes.append(p)

	for ch in playground.get_children():
		anim_nodes.append(ch)

	var time = 0.6

	screen_blur.fade_in({duration=time})
	screen_blur.anim_gray({duration=time, target=0.8})

	await Anim.animate_outro_to_point({
		node=playground, nodes=anim_nodes, position=Vector2(), t=time,
		})

	if p != null and is_instance_valid(p):
		p.queue_free()

	playground.queue_free()

	# give the player time to free
	await get_tree().create_timer(0.1).timeout

## level_start overlay

func setup_level_start_overlay():
	if not current_room:
		return
	var n = current_room.room_def.map_def.name
	if not n:
		n = current_room.name
	level_start_header.text = "[center]%s[/center]" % n
	level_start_subhead.text = "[center]%s[/center]" % ""

## level_complete overlay

func setup_level_complete_overlay():
	if not current_room:
		return
	var n = current_room.room_def.map_def.name
	if not n:
		n = current_room.name
	level_complete_header.text = "[center]%s[/center]" % n
	level_complete_subhead.text = "[center]%s[/center]" % "COMPLETE!"

## initial room

func load_initial_room():
	if room_defs.is_empty():
		Log.warn("No room_defs returned, did the generator fail?")
		return

	# TODO filter/sort by is_start or some such metadata
	var rooms = room_defs.filter(func(rd):
		return rd.entities().any(func(ent):
			return ent.get_entity_id() == DinoEntityIds.PLAYERSPAWNPOINT))

	if rooms.is_empty():
		Log.warn("No room with player spawn point! Isn't this 'guaranteed' elsewhere?")
		rooms = room_defs

	var def = rooms[0]

	_load_room(def)

## start_vania_game

# clears the playground, hides the ready-overlay, loads the initial room, and sets up the player
# can be fired if ready_to_play is true
func start_vania_game():
	await clear_playground()

	hide_ready_overlay()

	get_tree().physics_frame.connect(_set_player_position, CONNECT_DEFERRED)

	load_initial_room()
	setup_player()
	toggle_pause_game_nodes(true)

	setup_level_start_overlay()

	var t1 = 0.7
	screen_blur.anim_blur({duration=t1, target=1.0})
	screen_blur.anim_gray({duration=t1, target=0.8})
	Anim.fade_in(level_start_overlay, t1)
	await get_tree().create_timer(2.0).timeout

	var t2 = 0.7
	screen_blur.anim_blur({duration=t2, target=0.0})
	screen_blur.anim_gray({duration=t2, target=0.0})
	Anim.fade_out(level_start_overlay, t2)
	await get_tree().create_timer(t2).timeout

	toggle_pause_game_nodes(false)

## vania_game_complete

func vania_game_complete():
	setup_level_complete_overlay()
	level_complete_action.modulate.a = 0.0

	var t = 2.3
	Anim.fade_in(level_complete_overlay, t/2.0)
	screen_blur.anim_blur({duration=t, target=1.0})
	screen_blur.anim_gray({duration=t, target=0.8})
	await get_tree().create_timer(t).timeout

	Anim.fade_in(level_complete_action, 0.4)

	# allow input to move to next
	ready_for_next = true

## exit_tree #######################################################

func _exit_tree():
	if generating:
		generating.wait_to_finish()

## process #######################################################

func _process(_delta: float):
	if not generating.is_alive():
		generating.wait_to_finish()
		generating = null
		set_process(false)
		Log.info("level gen thread finished and joined!")

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
			safe_discover_cell(coord)
		init_room_state(rd.room_path)

var abort_presumed = false
func safe_discover_cell(coord: Vector3i):
	if coord in MetSys.map_data.cells:
		MetSys.discover_cell(coord)
	else:
		if not abort_presumed:
			Log.warn("skipping discover cell, presuming game was aborted")
			abort_presumed = true

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
	if current_room and current_room.is_node_ready():
		current_room.setup_walls_and_doors()

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
	if current_room and current_room.is_node_ready():
		current_room.setup_walls_and_doors()

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
	if current_room and current_room.is_node_ready():
		current_room.setup_walls_and_doors()

## load room #######################################################

# overwriting metsys's Game.load_room to support 'setup' and setting a default layer
func _load_room(def: VaniaRoomDef, opts={}):
	var next_room = get_vania_room(def)

	if not next_room:
		next_room = load(def.room_path).instantiate()
		next_room.set_room_def(def)
		add_child(next_room)

		if MetSys.get_current_room_instance() != null:
			MetSys.current_layer = MetSys.get_current_room_instance().get_layer()
		else:
			Log.warn("No current room_instance, defaulting to layer 0")
			MetSys.current_layer = 0

		# not quite right, maybe gets eaten by run/quest manager?
		mark_room_visited(def.room_path)

		# make sure metsys knows this is the 'current' room
		MetSys.current_room = next_room.room_instance
		add_vania_room(next_room)
		room_loaded.emit()

	if not next_room:
		Log.warn("no next_room? wut?", next_room)

	current_room = next_room

func reload_current_room():
	MetSys.room_changed.emit(MetSys.get_current_room_name(), false)

## player #######################################################

func setup_player():
	if not Dino.current_player_entity():
		# should have been set by the game mode, this is for debug help
		Log.warn("Fallback player entity hard-coding, better be debugging!")
		Dino.create_new_player({
			entity=Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER),
			})

	var def = current_room_def()
	var opts = {
		level_node=self, deferred=false,
		# sidescroller default set for playground (no `room_def`)
		genre_type=def.genre_type() if def else Dino.GenreType.SideScroller,
		}
	if Dino.current_player_node():
		Dino.respawn_active_player(opts)
	else:
		Dino.spawn_player(opts)

func _set_player_position():
	var p = Dino.current_player_node()
	if p:
		MetSys.set_player_position(p.position)

## rooms #######################################################

var loaded_rooms: Dictionary = {}

func get_vania_rooms():
	return loaded_rooms.values()

func get_vania_room(def_or_path) -> VaniaRoom:
	var path: String
	if def_or_path is String:
		path = def_or_path
	elif def_or_path is VaniaRoomDef:
		path = def_or_path.room_path
	else:
		Log.warn("Unexpected get_vania_room input", def_or_path)

	return loaded_rooms.get(path)

func add_vania_room(room):
	var path = room.room_def.room_path
	loaded_rooms[path] = room

func erase_vania_room(room):
	var path = room.room_def.room_path
	loaded_rooms.erase(path)

## room_defs #######################################################

func get_room_def(path):
	for rd in room_defs:
		if path == rd.room_path:
			return rd

func current_room_def():
	var path = MetSys.get_current_room_name()
	return get_room_def(path)

## player reactions ##################################################3

# connected via player ready and `add_child_to_level` / Util level_root api :/
func _on_player_death(_p):
	# TODO show player lifespan/stats/progress? (hopefully not per player-type! should be in game-mode/dino-level)
	# inspiration: Spelunky, Ape Out
	# ideas: framing the dead player, splashy letters in sync with drums

	# possibly we could share/re-use this, but meh, it'll probably need specific text
	Jumbotron.jumbo_notif({header="You died", body="Sorry about that!",
		action="close", action_label_text="Respawn",
		on_close=func():
		# resurrect player, respawn in room?
		var p = Dino.current_player_node()
		if p:
			if p.has_method("resurrect"):
				p.resurrect()
		Dino.respawn_active_player()
		})
