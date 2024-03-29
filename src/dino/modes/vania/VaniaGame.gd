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

## ready #######################################################

func _ready():

	add_custom_module.call_deferred(VaniaRoomTransitions)
	add_custom_module.call_deferred(PassageAutomapper)

	room_loaded.connect(on_room_loaded, CONNECT_DEFERRED)

	regenerate_rooms()
	load_initial_room()
	setup_player()

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
		# TODO filter for room with player entity
		var p = room_defs[0].room_path
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

	get_tree().physics_frame.connect(_set_player_position, CONNECT_DEFERRED)

func _set_player_position():
	var p = Dino.current_player_node()
	if p:
		MetSys.set_player_position(p.position)

## room defs #######################################################

func regenerate_rooms():
	room_defs = generator.generate_rooms() # add new rooms/cells to metsys map_data
	for rd in room_defs:
		room_defs_by_path[rd.room_path] = rd

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
