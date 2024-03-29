@tool
extends RefCounted
class_name VaniaRoomDef

const vania_room_path = "res://src/dino/modes/vania/maps/VaniaRoom.tscn"
const vania_room_path_wide = "res://src/dino/modes/vania/maps/VaniaRoomWide.tscn"
const vania_room_path_tall = "res://src/dino/modes/vania/maps/VaniaRoomTall.tscn"
const vania_room_path_4x = "res://src/dino/modes/vania/maps/VaniaRoom4x.tscn"

var room_type: DinoData.RoomType = DinoData.RoomType.SideScroller
var base_scene_path: String
var room_scene: PackedScene
var room_path: String
var local_cells: Array #[Vector3i]
var map_cells: Array #[Vector3i]

var bg_color: Color = Color.BLACK
var border_color: Color = Color.WHITE

var index: int

var entity_defs: GridDefs
var entities: Array #[String]

var label_to_entity
var label_to_tilemap
var tile_size: int = 16

func to_printable():
	return {
		entities=entities,
		room_path=room_path.get_file(),
		local_cells=local_cells,
		}

## init #####################################################3

func _init(opts={}):
	room_type = opts.get("room_type", room_type)
	if opts.get("base_scene_path"):
		base_scene_path = opts.get("base_scene_path")
	# TODO create this dynamically - does it really need to be represented in the main map?
	room_scene = opts.get("room_scene")
	local_cells = opts.get("local_cells", [])

	bg_color = opts.get("bg_color", bg_color)
	border_color = opts.get("border_color", border_color)

	entity_defs = opts.get("entity_defs")
	if opts.get("entities"):
		entities = opts.get("entities")
		Log.pr("setting entities", entities)
	tile_size = opts.get("tile_size", tile_size)

	label_to_entity = DinoLevelGenData.label_to_entity({tile_size=tile_size})
	label_to_tilemap = {
			"Tile": {
				scene=load("res://addons/reptile/tilemaps/GrassTiles16.tscn"),
				# border_depth={down=30, left=20, right=20},
				}
		}

## setters #####################################################3

func set_room_type(t: DinoData.RoomType) -> VaniaRoomDef:
	self.room_type = t
	return self

func set_base_scene(path) -> VaniaRoomDef:
	self.base_scene_path = path
	return self

func add_entities(ents: Array) -> VaniaRoomDef:
	self.entities = ents
	return self

## random data builders #####################################################3

func select_room_type():
	var types = [DinoData.RoomType.SideScroller, DinoData.RoomType.TopDown]
	self.room_type = types.pick_random()
	return self

func select_room_shape():
	var shapes = [
		[[Vector3i()], vania_room_path],
		[[Vector3i(), Vector3i(1, 0, 0),], vania_room_path_wide,],
		[[Vector3i(), Vector3i(0, 1, 0),], vania_room_path_tall],
		[[Vector3i(0, 0, 0), Vector3i(1, 0, 0),
			Vector3i(0, 1, 0), Vector3i(1, 1, 0),], vania_room_path_4x],
		]
	var shape = shapes.pick_random()
	self.local_cells = shape[0]
	self.base_scene_path = shape[1]
	return self

func select_entities():
	var entity_groups = [
		# ["Candle"],
		# ["Player"],
		["Target", "Target", "Target"],
		["Leaf", "Leaf", "Leaf"],
		["Enemy", "Enemy", "Enemy"],
		]
	var ents = entity_groups.pick_random()
	self.entities = ents
	return self

## static #####################################################3

static func generate_defs(opts={}):
	var defs: Array[VaniaRoomDef] = []
	var fixed = [
		{entities=["Candle", "Player", "Target", "Leaf"]}
		]
	for i in range(opts.get("count", 4)):
		var data = {entity_defs=opts.get("entity_defs"), tile_size=opts.get("tile_size"),}
		if i < len(fixed):
			data.merge(fixed[i])

		var def = VaniaRoomDef.new(data)

		def.select_room_shape()

		if def.entities.is_empty():
			def.select_entities()

		def.index = i
		defs.append(def)

	return defs

### misc helpers

func get_local_cells_dict():
	var local = {}
	for coord in local_cells:
		local[coord] = true
	return local

func get_local_width():
	return Reptile.get_width(local_cells)

func get_local_height():
	return Reptile.get_height(local_cells)
