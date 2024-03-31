extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name VaniaGame

# func to_printable():
# 	return {level_def=level_def.get_display_name()}

## vars #######################################################

var generator = VaniaGenerator.new()
var VaniaRoomTransitions = "res://src/dino/modes/vania/VaniaRoomTransitions.gd"
var PassageAutomapper = "res://addons/MetroidvaniaSystem/Template/Scripts/Modules/PassageAutomapper.gd"

var room_defs = []
var room_defs_by_path = {}

# capture as RoomGenInputs
var tile_size = 16 # TODO fixed? dynamic?
var initial_room_count = 3

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
	room_defs = VaniaRoomDef.generate_defs({tile_size=tile_size, count=initial_room_count})

	room_defs = generator.add_rooms_to_map(room_defs, {clear_all_rooms=true})
	for rd in room_defs:
		room_defs_by_path[rd.room_path] = rd

	load_initial_room()
	setup_player()

# regenerate rooms besides the current one
func regenerate_other_rooms():
	var other_room_defs = []
	for path in room_defs_by_path.keys():
		if MetSys.get_current_room_name() == path:
			continue
		other_room_defs.append(room_defs_by_path[path])

	var new_room_defs = VaniaRoomDef.generate_defs({tile_size=tile_size, count=len(other_room_defs)})

	generator.add_rooms_to_map(new_room_defs, {clear_rooms=other_room_defs})
	# redo the current room's doors
	map.setup_walls_and_doors()


func on_room_loaded():
	Log.pr("room entered", MetSys.get_current_room_instance())
	# Log.pr("this room's neighbors", MetSys.get_current_room_instance().get_neighbor_rooms(false))

	# MetSys.get_current_room_instance().adjust_camera_limits($Player/Camera2D)
	# player.on_enter()

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
	if path in room_defs_by_path:
		return room_defs_by_path[path]

func current_room_def():
	var path = MetSys.get_current_room_name()
	if path in room_defs_by_path:
		return room_defs_by_path[path]

## metsys misc #######################################################

func add_custom_module(module_path: String):
	modules.append(load(module_path).new(self))
