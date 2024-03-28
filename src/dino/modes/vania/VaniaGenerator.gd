extends RefCounted
class_name VaniaGenerator

const GEN_MAP_DIR = "user://vania_maps"

const vania_room = preload("res://src/dino/modes/vania/maps/VaniaRoom.tscn")
const vania_room_wide = preload("res://src/dino/modes/vania/maps/VaniaRoomWide.tscn")
const vania_room_tall = preload("res://src/dino/modes/vania/maps/VaniaRoomTall.tscn")
const vania_room_4x = preload("res://src/dino/modes/vania/maps/VaniaRoom4x.tscn")

var room_defs = [
	{
		room_type=DinoData.RoomType.SideScroller,
		room_scene=vania_room,
		coords=[Vector3i(0, 0, 0)],
	}, {
		room_type=DinoData.RoomType.SideScroller,
		room_scene=vania_room_wide,
		coords=[Vector3i(0, -1, 0), Vector3i(1, -1, 0),]
	}, {
		room_type=DinoData.RoomType.SideScroller,
		room_scene=vania_room_tall,
		coords=[Vector3i(1, 0, 0), Vector3i(1, 1, 0),]
	}, {
		room_type=DinoData.RoomType.SideScroller,
		room_scene=vania_room_4x,
		coords=[
			Vector3i(2, 0, 0), Vector3i(3, 0, 0),
			Vector3i(2, 1, 0), Vector3i(3, 1, 0),
			]
	}
	].map(func(opts): return VaniaRoomDef.new(opts))

## init ##########################################################

var entity_defs
var entity_defs_path = "res://src/dino/modes/vania/entities.txt"

func _init():
	var brickRoomDefs = GridParser.parse({room_defs_path=entity_defs_path})
	Log.pr("brick room defs", brickRoomDefs)
	Log.pr("brick room defs rooms", brickRoomDefs.rooms)


## generate_rooms ##########################################################

func generate_rooms():
	# ensure directory exists
	DirAccess.make_dir_absolute(GEN_MAP_DIR)

	# delete contents in directory
	for file in DirAccess.get_files_at(GEN_MAP_DIR):
		DirAccess.remove_absolute(GEN_MAP_DIR.path_join(file))

	var builder := MetSys.get_map_builder()

	for room_def in room_defs:
		for index in range(len(room_def.coords)):
			var coord = room_def.coords[index]
			var cell := builder.create_cell(coord)
			cell.color = room_def.bg_color
			for i in 4:
				cell.borders[i] = 0
				cell.border_colors[i] = room_def.border_color

			if not room_def.room_path:
				room_def.index = index
				room_def.room_path = build_scene_name(room_def)

			cell.set_assigned_scene(room_def.room_path)

		# Does this need to be called before set_assigned_scene ?
		prepare_scene(room_def)

	builder.update_map()

	return room_defs

func build_scene_name(room_def) -> String:
	var res_path = room_def.room_scene.resource_path
	var basename = res_path.get_file().get_basename()
	var new_map = "%s%d.tscn" % [basename, room_def.index + 1]
	return GEN_MAP_DIR.path_join(new_map)

func prepare_scene(room_def):
	# Prepare the actual scene (maybe deferred if threading)
	var room: Node2D = room_def.room_scene.instantiate()

	# TODO generate tiles, add entities, default doors, etc

	# do things like hide/show exits based on room opts, neighbors

	var ps := PackedScene.new()
	ps.pack(room)
	ResourceSaver.save(ps, room_def.room_path)
