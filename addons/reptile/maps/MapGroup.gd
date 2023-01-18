class_name MapGroup
extends Object

export(int) var upper_bound
export(int) var lower_bound
export(Color) var color
export(PackedScene) var tilemap_scene
var tilemap

func _init(c=null, ts=null, lb=null, ub=null):
	upper_bound = ub
	lower_bound = lb
	color = c
	tilemap_scene = ts

func _to_string():
	return "\n[tiles: " + str(tilemap_scene) + "]\t[bounds: " + str(upper_bound) + ", " + str(lower_bound) + "]\t[color: " + str(color) + "]"

# TODO consider selecting a group based on all group bounds per coord instead
# TODO unit tests
static func sort_by_key(a, b):
	if not a.upper_bound or a.lower_bound:
		return false
	if a.upper_bound <= Util._or(b.upper_bound, 1.1):
		return true
	if a.lower_bound >= Util._or(b.lower_bound, -0.1):
		return true
	return false
