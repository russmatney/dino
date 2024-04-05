extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name VaniaGame

# func to_printable():
# 	return {level_def=level_def.get_display_name()}

## vars #######################################################

var generator = VaniaGenerator.new()
var VaniaRoomTransitions = "res://src/dino/vania/VaniaRoomTransitions.gd"
var PassageAutomapper = "res://addons/MetroidvaniaSystem/Template/Scripts/Modules/PassageAutomapper.gd"

@onready var pcam: PhantomCamera2D = $%PCam
@onready var playground: Node2D = $%LoadPlayground

var room_defs: Array[VaniaRoomDef] = []

var generating: Thread

# capture in RoomInputs
var tile_size = 16

signal finished_initial_room_gen

## ready #######################################################

func _ready():
	add_custom_module.call_deferred(VaniaRoomTransitions)
	add_custom_module.call_deferred(PassageAutomapper)

	room_loaded.connect(on_room_loaded, CONNECT_DEFERRED)

	get_tree().physics_frame.connect(_set_player_position, CONNECT_DEFERRED)

	Dino.player_ready.connect(on_player_ready)

	finished_initial_room_gen.connect(on_finished_initial_room_gen, CONNECT_ONE_SHOT)

	# spawn player in the load playground
	setup_player()
	playground.ready.connect(func():
		Debug.notif({msg="[Generating vania rooms!]", rich=true}))

	set_process(false)

	thread_room_gen({room_inputs=U.repeat_fn(RoomInputs.random_room, 5)})

func on_finished_initial_room_gen():
	clear_load_playground()
	load_initial_room()
	setup_player()

func clear_load_playground():
	playground.queue_free()

## process #######################################################

func _process(_delta: float) -> void:
	# Join thread when it has finished.
	if not generating.is_alive():
		generating.wait_to_finish()
		generating = null
		set_process(false)

		finished_initial_room_gen.emit()

## on load/ready #######################################################

func on_room_loaded():
	Log.pr("room entered", MetSys.get_current_room_instance())
	# Log.pr("this room's neighbors", MetSys.get_current_room_instance().get_neighbor_rooms(false))

	if pcam != null and map.tilemap != null:
		pcam.set_limit_node(map.tilemap)

func on_player_ready(p):
	pcam.set_follow_target_node(p)
	# pcam.set_limit_margin(Vector4i(0, -50, 50, 0))

## room gen #######################################################

func thread_room_gen(opts):
	if generating:
		return

	# The thread that does map generation.
	generating = Thread.new()
	generating.start(func(): generate_rooms(opts))
	set_process(true)

func generate_rooms(opts={}):
	VaniaGenerator.remove_generated_cells()
	MetSys.reset_state()
	MetSys.set_save_data()

	var room_inputs = opts.get("room_inputs", [])
	if room_inputs.is_empty():
		room_inputs = [[RoomInputs.IN_SMALL_ROOM, RoomInputs.HAS_PLAYER]]

	room_defs = VaniaRoomDef.generate_defs(U.merge({
		tile_size=tile_size,
		room_inputs=room_inputs}, opts))
	room_defs = generator.add_rooms(room_defs)

	for rd in room_defs:
		for coord in rd.map_cells:
			MetSys.discover_cell(coord)

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

	var new_room_defs = VaniaRoomDef.generate_defs({
		tile_size=tile_size,
		})
	generator.remove_rooms(other_room_defs)
	room_defs = generator.add_rooms(new_room_defs)

	for rd in room_defs:
		for coord in rd.map_cells:
			MetSys.discover_cell(coord)

	# redo the current room's doors
	if map and map.is_node_ready():
		map.setup_walls_and_doors()

func add_new_room(count=1):
	var new_room_defs = VaniaRoomDef.generate_defs({tile_size=tile_size,
		room_inputs=U.repeat_fn(RoomInputs.random_room, count)})
	room_defs = generator.add_rooms(new_room_defs)
	Log.pr(len(new_room_defs), " rooms added")

	for rd in room_defs:
		for coord in rd.map_cells:
			MetSys.discover_cell(coord)

	# redo the current room's doors
	if map and map.is_node_ready():
		map.setup_walls_and_doors()

func remove_room(count=1):
	var other_room_defs: Array[VaniaRoomDef] = []
	for rd in room_defs:
		if MetSys.get_current_room_name() == rd.room_path:
			continue
		other_room_defs.append(rd)

	# TODO when removing, don't leave orphans.... unless they're fun to work with?
	var room_defs_to_remove: Array[VaniaRoomDef] = []
	other_room_defs.reverse() # prefer to remove the latest room for now
	for rd in other_room_defs:
		if len(room_defs_to_remove) >= count:
			break
		room_defs_to_remove.append(rd)

	room_defs = generator.remove_rooms(room_defs_to_remove)

	Log.pr(len(room_defs_to_remove), " rooms removed")

	# redo the current room's doors
	if map and map.is_node_ready():
		map.setup_walls_and_doors()

## load room #######################################################

func load_initial_room():
	if room_defs.is_empty():
		Log.warn("No room_defs returned, did the generator fail?")
		return
	else:
		var rooms = room_defs.filter(func(rd): return "Player" in rd.entities)
		if rooms.is_empty():
			Log.warn("No room with player entity! Picking random start room")
			rooms = room_defs
		var p = rooms.pick_random().room_path
		load_room(p, {setup=func(room):
			room.set_room_def(get_room_def(p))})

func reload_current_room():
	MetSys.room_changed.emit(MetSys.get_current_room_name(), false)

## player #######################################################

func setup_player():
	if not Dino.current_player_entity():
		Dino.create_new_player({
			room_type=DinoData.RoomType.SideScroller,
			entity=Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER),
			})
	if Dino.current_player_node():
		Dino.respawn_active_player({level_node=self, deferred=false})
	else:
		Dino.spawn_player({level_node=self, deferred=false})

func _set_player_position():
	var p = Dino.current_player_node()
	if p:
		MetSys.set_player_position(p.position)

## room defs #######################################################

func get_room_def(path):
	for rd in room_defs:
		if path == rd.room_path:
			return rd

func current_room_def():
	var path = MetSys.get_current_room_name()
	return get_room_def(path)

## metsys misc #######################################################

func add_custom_module(module_path: String):
	modules.append(load(module_path).new(self))
