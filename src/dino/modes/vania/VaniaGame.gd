extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name VaniaGame

# func to_printable():
# 	return {level_def=level_def.get_display_name()}

## vars #######################################################

var generator = VaniaGenerator.new()
var VaniaRoomTransitions = "res://src/dino/modes/vania/VaniaRoomTransitions.gd"
var PassageAutomapper = "res://addons/MetroidvaniaSystem/Template/Scripts/Modules/PassageAutomapper.gd"

var room_defs: Array[VaniaRoomDef] = []

# capture in RoomInputs
var tile_size = 16

func increment_room_count():
	add_new_room(1)

func decrement_room_count():
	remove_room(1)

## ready #######################################################

func _ready():
	add_custom_module.call_deferred(VaniaRoomTransitions)
	add_custom_module.call_deferred(PassageAutomapper)

	room_loaded.connect(on_room_loaded, CONNECT_DEFERRED)

	get_tree().physics_frame.connect(_set_player_position, CONNECT_DEFERRED)

	init_rooms()

func init_rooms(opts={}):
	generator.remove_generated_cells()
	MetSys.reset_state()
	MetSys.set_save_data()

	room_defs = VaniaRoomDef.generate_defs(U.merge({
		tile_size=tile_size,
		room_inputs=[
			{
				RoomInputs.CUSTOM_ROOM: {
					shape=[Vector3i(0, 0, 0), Vector3i(0, 1, 0), Vector3i(1, 0, 0),]
				},
				RoomInputs.HAS_PLAYER: {}
			},
			[RoomInputs.IN_SMALL_ROOM],
			]
		}, opts))
	room_defs = generator.add_rooms(room_defs)

	for rd in room_defs:
		for coord in rd.map_cells:
			MetSys.discover_cell(coord)

	load_initial_room()
	setup_player()

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
	if map.is_node_ready():
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
	if map.is_node_ready():
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
	if map.is_node_ready():
		map.setup_walls_and_doors()

func on_room_loaded():
	Log.pr("room entered", MetSys.get_current_room_instance())
	# Log.pr("this room's neighbors", MetSys.get_current_room_instance().get_neighbor_rooms(false))

	# var p = Dino.current_player_node()
	# if p != null:
	# 	var cam = p.get_node("Cam2D")
	# 	if cam != null:
	# 		MetSys.get_current_room_instance().adjust_camera_limits(cam)

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
