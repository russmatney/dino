class_name RoomDef
extends Object

var name: String
var shape: Array
var meta: Dictionary

func to_pretty(obj, a, b, c):
	return Debug.to_pretty({name=name, meta=meta}, a, b, c)

func has_flag(f):
	if f in meta:
		return meta.get(f)
