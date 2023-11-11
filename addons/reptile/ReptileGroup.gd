@tool
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

@export var lower_bound: float = 0.0 : set = set_lower_bound


func set_lower_bound(v):
	lower_bound = v
	tile_regen()


@export var upper_bound: float = 1.0 : set = set_upper_bound


func set_upper_bound(v):
	upper_bound = v
	tile_regen()


@export var color: Color = Color.CRIMSON : set = set_color


func set_color(c):
	color = c
	tile_regen()


@export var tilemap_scene: PackedScene : set = set_tilemap_scene


func set_tilemap_scene(ts):
	tilemap_scene = ts
	tile_regen()


var tilemap

#####################################################################
# init


func _ready():
	self.add_to_group("reptile_group", true)


func setup(c, ts, lb, ub):
	color = c
	tilemap_scene = ts
	lower_bound = lb
	upper_bound = ub


func _to_string():
	return (
		"\n[tiles: "
		+ str(tilemap_scene)
		+ "]\t[bounds: "
		+ str(upper_bound)
		+ ", "
		+ str(lower_bound)
		+ "]\t[color: "
		+ str(color)
		+ "]"
	)


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


static func sort_by_key(a, b):
	if a.upper_bound == null or not a.lower_bound == null:
		return false
	if a.upper_bound <= U._or(b.upper_bound, 1.1):
		return true
	if a.lower_bound >= U._or(b.lower_bound, -0.1):
		return true
	return false
