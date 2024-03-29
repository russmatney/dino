@tool
extends RefCounted
class_name VaniaRoomDef

var room_type: DinoData.RoomType = DinoData.RoomType.SideScroller
var room_scene: PackedScene
var room_path: String
var coords: Array #[Vector3i]

var bg_color: Color = Color.BLACK
var border_color: Color = Color.WHITE

var index: int

var entity_defs: GridDefs
var entities: Array #[String]

var label_to_entity
var label_to_tilemap
var tile_size: int = 16

func _init(opts={}):
	room_type = opts.get("room_type", room_type)
	# TODO create this dynamically - does it really need to be represented in the main map?
	room_scene = opts.get("room_scene")
	coords = opts.get("coords", [])

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

func set_room_type(t: DinoData.RoomType) -> VaniaRoomDef:
	self.room_type = t
	return self

func set_scene(sc: PackedScene) -> VaniaRoomDef:
	self.room_scene = sc
	return self

func add_entities(ents: Array) -> VaniaRoomDef:
	self.entities = ents
	return self

func set_coords(crds) -> VaniaRoomDef:
	self.coords = crds
	return self
