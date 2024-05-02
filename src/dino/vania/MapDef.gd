extends Resource
class_name MapDef

@export var name: String
@export var room_inputs: Array[RoomInput]

func _init(opts={}):
	name = opts.get("name", "New Map Def")
	room_inputs.assign(opts.get("room_inputs", []))
