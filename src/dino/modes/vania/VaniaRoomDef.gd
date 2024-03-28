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

func _init(opts={}):
	room_type = opts.get("room_type", room_type)
	# TODO create this dynamically - does it really need to be represented in the main map?
	room_scene = opts.get("room_scene")
	coords = opts.get("coords", [])

	bg_color = opts.get("bg_color", bg_color)
	border_color = opts.get("border_color", border_color)

	entity_defs = opts.get("entity_defs")
