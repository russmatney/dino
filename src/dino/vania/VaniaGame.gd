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

@onready var quest_manager: QuestManager = $%QuestManager

var room_defs: Array[VaniaRoomDef] = []
@export var map_def: MapDef

var generating: Thread

signal room_gen_complete
signal level_complete

## room_states #################################################

func reset_room_states(opts={}):
	for rd in room_defs:
		if (opts.get("keep_current", false) and
			rd.room_path == MetSys.get_current_room_name()):
				continue
		rd.reset_visited()

func mark_room_visited(rd: VaniaRoomDef):
	rd.set_visited()

func all_rooms_visited():
	return room_defs.all(func(rd): return rd.visited)

## ready #######################################################

func _ready():
	modules.append(VaniaRoomTransitions.new(self))

	# MetSys.cell_changed.connect(on_cell_changed, CONNECT_DEFERRED)
	# Dino.player_ready.connect(on_player_ready)

	room_gen_complete.connect(on_room_gen_complete, CONNECT_ONE_SHOT)

	quest_manager.quest_complete.connect(on_quest_complete)
	quest_manager.all_quests_completed.connect(check_game_complete)

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

func on_room_gen_complete():
	setup_quests()
	show_ready_overlay()

## add_child_to_level ###################################################3

func add_child_to_level(_node, child):
	if current_room and is_instance_valid(current_room):
		current_room.add_child(child)
	else:
		add_child(child)

## quests ###################################################3

func setup_quests():
	var ents = []
	var d_ents = U.flat_map(room_defs, func(def): return def.entities())
	var d_enms = U.flat_map(room_defs, func(def): return def.enemies())
	ents.append_array(d_ents)
	ents.append_array(d_enms)

	quest_manager.add_quests_for_entities(ents)

func on_quest_complete(quest):
	Log.info("quest completed", quest.label)
	# TODO required vs optional quests (in the mapDef)

# TODO trigger after entering room if all quests are complete
var complete = false
func check_game_complete():
	# TODO confetti particles?
	# TODO update room on mini-map
	# TODO door open/close logic

	# TODO required vs optional room visits?
	if (all_rooms_visited() and
		quest_manager.all_quests_complete() and
		not complete):
		complete = true
		vania_game_complete()

## input #######################################################

var started_game = false
func _unhandled_input(event):
	if ready_to_play and Trolls.is_accept(event) and not started_game:
		started_game = true
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

	load_room(def)

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

		room_gen_complete.emit()

## room gen #######################################################

func thread_room_generation(opts):
	if generating:
		# thread already running
		return

	reset_room_states()
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
	reset_room_states({keep_current=true})
	for rd in room_defs:
		for coord in rd.map_cells:
			MetSys.discover_cell(coord)

	# redo the current room's doors
	if current_room and current_room.is_node_ready():
		current_room.setup_walls_and_doors()

func add_new_room(count=1):
	# TODO these inputs reading from map_def
	var new_room_defs = VaniaRoomDef.to_defs(MapDef.random_rooms({count=count}))
	room_defs = generator.add_rooms(new_room_defs)
	Log.info(len(new_room_defs), " rooms added")

	for rd in room_defs:
		for coord in rd.map_cells:
			MetSys.discover_cell(coord)

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

func load_room(def: VaniaRoomDef):
	# look for an existing room
	var next_room = get_vania_room(def)

	if not next_room:
		# load a new room
		next_room = load(def.room_path).instantiate()
		next_room.set_room_def(def)
		add_child(next_room)

		if MetSys.get_current_room_instance() != null:
			MetSys.current_layer = MetSys.get_current_room_instance().get_layer()
		else:
			Log.warn("No current room_instance, defaulting to layer 0")
			MetSys.current_layer = 0

		# store node for re-use if we re-enter
		store_vania_room(next_room)

		room_loaded.emit()

	# make sure metsys knows this is the 'current' room!!
	MetSys.current_room = next_room.room_instance

	mark_room_visited(def)
	current_room = next_room

	# if we're requiring all rooms to be visited....
	check_game_complete()

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

func store_vania_room(room):
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
