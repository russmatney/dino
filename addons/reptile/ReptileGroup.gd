tool
class_name ReptileGroup
extends Node

#####################################################################
# regenerate via parent

func tile_regen():
	var p = get_parent()
	if p and is_instance_valid(p) and p.is_in_group("reptile_room"):
		p.regen_tilemaps()

#####################################################################
# fields

export(float) var lower_bound = 0.0 setget set_lower_bound
func set_lower_bound(v):
	lower_bound = v
	tile_regen()

export(float) var upper_bound = 1.0 setget set_upper_bound
func set_upper_bound(v):
	upper_bound = v
	tile_regen()

export(Color) var color = Color.crimson setget set_color
func set_color(c):
	color = c
	tile_regen()

export(PackedScene) var tilemap_scene setget set_tilemap_scene
func set_tilemap_scene(ts):
	tilemap_scene = ts
	tile_regen()


var tilemap

#####################################################################
# init

func _ready():
	self.add_to_group("reptile_group")

func setup(c, ts, lb, ub):
	color = c
	tilemap_scene = ts
	lower_bound = lb
	upper_bound = ub

func _to_string():
	return "\n[tiles: " + str(tilemap_scene) + "]\t[bounds: " + str(upper_bound) + ", " + str(lower_bound) + "]\t[color: " + str(color) + "]"

#####################################################################
# public

func valid():
	# validation for bounds?
	if tilemap_scene:
		return true

func contains_val(normed):
	return normed <= upper_bound and normed >= lower_bound

#####################################################################
# sort

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
