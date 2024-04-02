extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name VaniaGame

# func to_printable():
# 	return {level_def=level_def.get_display_name()}

## vars #######################################################

var generator = VaniaGenerator.new()
var VaniaRoomTransitions = "res://src/dino/modes/vania/VaniaRoomTransitions.gd"
var PassageAutomapper = "res://addons/MetroidvaniaSystem/Template/Scripts/Modules/PassageAutomapper.gd"

var room_defs = []

# capture as RoomGenInputs
var tile_size = 16 # TODO fixed? dynamic?
var desired_room_count = 3

func increment_room_count():
	desired_room_count += 1
	add_new_room(1)

func decrement_room_count():
	desired_room_count -= 1
	desired_room_count = maxi(1, desired_room_count)
	remove_room(1)

## ready #######################################################

func _ready():
	MetSys.reset_state()
	MetSys.set_save_data()

	add_custom_module.call_deferred(VaniaRoomTransitions)
	add_custom_module.call_deferred(PassageAutomapper)

	room_loaded.connect(on_room_loaded, CONNECT_DEFERRED)

	get_tree().physics_frame.connect(_set_player_position, CONNECT_DEFERRED)

	init_rooms()

func init_rooms():
	room_defs = VaniaRoomDef.generate_defs({tile_size=tile_size, count=desired_room_count})

	room_defs = generator.add_rooms_to_map(room_defs)

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
		tile_size=tile_size, count=desired_room_count - 1,
		})
	generator.remove_rooms_from_map(other_room_defs)
	new_room_defs = generator.add_rooms_to_map(new_room_defs)
	new_room_defs.append(current_room_def())

	room_defs = new_room_defs

	for rd in room_defs:
		for coord in rd.map_cells:
			MetSys.discover_cell(coord)

	# redo the current room's doors
	map.setup_walls_and_doors()

func add_new_room(count=1):
	var new_room_defs = VaniaRoomDef.generate_defs({tile_size=tile_size, count=count})
	new_room_defs = generator.add_rooms_to_map(new_room_defs)
	room_defs.append_array(new_room_defs)
	Log.pr(len(new_room_defs), " rooms added")

	for rd in room_defs:
		for coord in rd.map_cells:
			MetSys.discover_cell(coord)

	# redo the current room's doors
	map.setup_walls_and_doors()
	# TODO redo walls/doors for neighbors of new room

func remove_room(count=1):
	var other_room_defs = []
	for rd in room_defs:
		if MetSys.get_current_room_name() == rd.room_path:
			continue
		other_room_defs.append(rd)

	# TODO when removing, don't leave orphans.... unless they're fun to work with?
	var room_defs_to_remove = []
	other_room_defs.reverse() # prefer to remove the latest room for now
	for rd in other_room_defs:
		if len(room_defs_to_remove) >= count:
			break
		room_defs_to_remove.append(rd)
		room_defs.erase(rd)

	generator.remove_rooms_from_map(room_defs_to_remove)

	Log.pr(len(room_defs_to_remove), " rooms removed")

	for rd in room_defs:
		for coord in rd.map_cells:
			MetSys.discover_cell(coord)

	# redo the current room's doors
	map.setup_walls_and_doors()
	# TODO redo walls/doors for neighbors of removed room


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
