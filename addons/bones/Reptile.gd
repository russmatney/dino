@tool
extends Object
class_name Reptile

## generate random image ######################################################################

static func generate_image(inputs: Dictionary) -> Image:
	# validating inputs
	if not "octaves" in inputs:
		Log.warn("nil octaves...")
		return

	var noise := FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.seed = inputs["seed"]
	noise.fractal_octaves = inputs["octaves"]
	noise.fractal_lacunarity = inputs["lacunarity"]
	noise.fractal_gain = inputs.get("gain", inputs.get("persistence"))
	noise.frequency = inputs.get("frequency", 1.0 / inputs.get("period", 20.0))

	var img_size: int = inputs["img_size"]
	return noise.get_seamless_image(img_size, img_size)

## img helpers #####################################################################

static func all_coords(img: Image) -> Array:
	var coords := []
	for x in img.get_width():
		for y in img.get_height():
			coords.append(Vector2(x, y))
	return coords

static func rotate(img: Image) -> Image:
	var new_img := Image.new()
	new_img.copy_from(img)
	for coord: Vector2 in all_coords(img):
		@warning_ignore("narrowing_conversion")
		new_img.set_pixel(coord.y, coord.x, img.get_pixelv(coord))
	return new_img

## img stats #####################################################################

static func img_stats(img: Image) -> Dictionary:
	var vals := []
	var stats := {"min": 1, "max": 0}
	for x in img.get_width():
		for y in img.get_height():
			var pix := img.get_pixel(x, y)
			var val := pix.r
			if val < stats["min"]:
				stats["min"] = val
			if val > stats["max"]:
				stats["max"] = val
			vals.append(pix.r)
	stats["variance"] = stats["max"] - stats["min"]
	# stats["vals"] = vals
	return stats

static func normalized_val(stats: Dictionary, val: float) -> float:
	val = val - stats["min"]
	return val / stats["variance"]

## tilemap/cell helpers #####################################################################

static func get_layers(tilemap: TileMap) -> Array:
	var layers := []
	for i in range(tilemap.get_layers_count()):
		layers.append({i=i, name=tilemap.get_layer_name(i)})
	return layers

static func valid_neighbors(tilemap: TileMap, cell: Vector2i, layer: int = 0) -> Array:
	var nbr_coords := tilemap.get_surrounding_cells(cell)
	return nbr_coords.filter(func(coord: Vector2i) -> bool:
		return -1 != tilemap.get_cell_source_id(layer, coord))

# Does not check if either cell is valid, only checks that they are neighboring coordinates
static func is_neighbor(cell_a: Vector2i, cell_b: Vector2i) -> bool:
	if cell_a.x == cell_b.x:
		if abs(cell_a.y - cell_b.y) == 1:
			return true
	if cell_a.y == cell_b.y:
		if abs(cell_a.x - cell_b.x) == 1:
			return true
	return false

static func group_has_neighbor(group: Array, cell: Vector2i) -> bool:
	# gen neighbors for cell, check if any in group
	for g_cell: Vector2i in group:
		if Reptile.is_neighbor(cell, g_cell):
			return true
	return false

static func split_connected_groups(cell: Vector2i, groups: Array) -> Dictionary:
	var connected := []
	var disconnected := []
	# should be able to filter out groups before checking every cell here, maybe with a stored min/max
	for g: Array in groups:
		var is_ngbr := Reptile.group_has_neighbor(g, cell)
		if is_ngbr:
			connected.append(g)
		else:
			disconnected.append(g)
	return {connected=connected, disconnected=disconnected}

static func update_connected_groups(cell: Vector2i, groups: Array) -> Array:
	var split := Reptile.split_connected_groups(cell, groups)
	var disconnected_groups: Array = split.disconnected
	var new_group := [cell]
	for g: Array in split.connected:
		# combine connected groups
		new_group.append_array(g)
	disconnected_groups.append(new_group)
	return disconnected_groups

# Given a list of coords from get_used_cells, returns lists of coords
# grouped by connectivity - i.e. the clusters of connected tiles.
static func build_connected_groups(cells: Array, groups: Array = []) -> Array:
	for c: Vector2i in cells:
		groups = Reptile.update_connected_groups(c, groups)
	return groups

# Returns coords grouped by adjacency - connected cells will be in the same group.
static func cell_clusters(tilemap: TileMap) -> Array:
	var clusters := []
	for l: Dictionary in Reptile.get_layers(tilemap):
		var layer_i: int = l.ih
		var used_cells: Array = tilemap.get_used_cells(layer_i)
		var connected_groups := Reptile.build_connected_groups(used_cells)
		clusters.append_array(connected_groups)
	return clusters

static func cells_to_polygon(tilemap: TileMap, cells: Array, opts: Dictionary = {}) -> Array:
	# get points from cell coordinates
	var points: Array = cells.map(func(c: Vector2i) -> Array:
		# assumes square tiles
		var half_tile_size := tilemap.tile_set.tile_size.x / 2.0 * Vector2.ONE
		var cell_center := tilemap.to_global(tilemap.map_to_local(c))
		return [
			cell_center + half_tile_size,
			cell_center - half_tile_size,
			cell_center + Vector2(-half_tile_size.x, half_tile_size.y),
			cell_center + Vector2(half_tile_size.x, -half_tile_size.y),
			]
		).reduce(func(agg: Array, pts: Array) -> Array:
			agg.append_array(pts)
			return agg, [])

	# remove points found 4 times (these are all internal points)
	var seen_points := {}
	for p: Vector2 in points:
		if p in seen_points:
			seen_points[p] += 1
		else:
			seen_points[p] = 1
	points = []
	for p: Vector2 in seen_points:
		if seen_points[p] < 4:
			points.append(p)

	var mid: Vector2 = U.average(points)

	# move points toward midpoint
	var padding: float = opts.get("padding", 0.0)
	var adjusted_points := []
	for p: Vector2 in points:
		adjusted_points.append(p.move_toward(mid, padding))
	points = adjusted_points

	# sort points according to angle to midpoint
	# NOTE not a perfect algo for convex shapes
	points.sort_custom(func (a: Vector2, b: Vector2) -> bool:
		var a_ang := mid.angle_to_point(a)
		var b_ang := mid.angle_to_point(b)
		var diff_ang: float = abs(a_ang - b_ang)
		if diff_ang <= 0.05:
			return mid.distance_to(a) <= mid.distance_to(b)
		return a_ang >= b_ang)

	var polygon := PackedVector2Array()
	for p: Vector2 in points:
		polygon.append(p)

	return polygon

## tilemap borders #####################################################################

static func tilemap_border_coords(tilemap: TileMap) -> Dictionary:
	var rect := tilemap.get_used_rect()
	rect = rect.grow_individual(1, 1, 0, 0)
	var corners := [ # corners
		Vector2i(rect.position.x, rect.position.y),
		Vector2i(rect.position.x + rect.size.x, rect.position.y),
		Vector2i(rect.position.x, rect.position.y + rect.size.y),
		Vector2i(rect.position.x + rect.size.x, rect.position.y + rect.size.y),
		]
	var top_coords := []
	var bottom_coords := []
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		top_coords.append(Vector2i(x, rect.position.y))
		bottom_coords.append(Vector2i(x, rect.position.y + rect.size.y))
	var left_coords := []
	var right_coords := []
	for y in range(rect.position.y, rect.position.y + rect.size.y):
		left_coords.append(Vector2i(rect.position.x, y))
		right_coords.append(Vector2i(rect.position.x + rect.size.x, y))
	return {corners=corners, top_coords=top_coords, bottom_coords=bottom_coords,
		left_coords=left_coords, right_coords=right_coords}

static func all_tilemap_border_coords(tilemap: TileMap) -> Array:
	return Reptile.tilemap_border_coords(tilemap).values()\
	.reduce(func(acc: Array, xs: Array) -> Array:
		acc.append_array(xs)
		return acc, [])

static func cells_in_rect(rect: Rect2i) -> Array:
	var cells := []
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		for y in range(rect.position.y, rect.position.y + rect.size.y):
			cells.append(Vector2i(x,y))
	return cells

static func cells_in_local_rect(tilemap: TileMapLayer, rect: Rect2) -> Array:
	var t_rect := rect_to_local_rect(tilemap, rect)
	return cells_in_rect(t_rect)

static func rect_to_local_rect(tilemap: TileMapLayer, rect: Rect2) -> Rect2i:
	var t_rect := Rect2i()
	t_rect.position = tilemap.local_to_map(rect.position)
	t_rect.end = tilemap.local_to_map(rect.end)
	return t_rect

static func to_rect2i(opts: Dictionary) -> Rect2i:
	# maybe need to cast/convert some Vector2s here
	var pos: Vector2i = opts.get("position")
	var end: Vector2i = opts.get("end")
	var r := Rect2i()
	r.position = pos
	r.end = end
	return r

## tilemap borders #####################################################################

# rect2 or colorRect
static func rect_to_collision_shape(rect: Rect2) -> CollisionShape2D:
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	var coll := CollisionShape2D.new()
	coll.name = "CollisionShape2D"
	coll.set_shape(shape)
	coll.position = rect.position + (rect.size / 2.0)
	return coll

static func tmap_to_collision_shape(tilemap: TileMap) -> CollisionShape2D:
	var rect := tilemap.get_used_rect()
	rect = Rect2(rect)
	# this seems weird
	# map_to_local seems to return the position at the CENTER of the tile, not the top-left
	# and i guess size after that is also half a tile too big?
	# maybe this is the collisionshape's position's job?
	var half_a_tile := Vector2(tilemap.tile_set.tile_size) / 2.0
	rect.position = (tilemap.map_to_local(rect.position) - half_a_tile) * tilemap.scale
	rect.size = (tilemap.map_to_local(rect.size) - half_a_tile) * tilemap.scale

	return rect_to_collision_shape(rect)

static func to_area2D(tilemap: TileMap = null, rect: Variant = null) -> Area2D:
	# naive! TODO impl to match the tiles, not just the rect
	var rect2: Rect2
	if rect == null:
		rect = tilemap.get_used_rect()
		rect2 = rect
		# this seems weird
		# map_to_local seems to return the position at the CENTER of the tile, not the top-left
		# and i guess size after that is also half a tile too big?
		# maybe this is the collisionshape's position's job?
		var half_a_tile := Vector2(tilemap.tile_set.tile_size) / 2.0
		rect2.position = (tilemap.map_to_local(rect2.position) - half_a_tile) * tilemap.scale
		rect2.size = (tilemap.map_to_local(rect2.size) - half_a_tile) * tilemap.scale
	else:
		rect2 = rect

	var coll := rect_to_collision_shape(rect2)

	# area2D
	var area := Area2D.new()
	area.add_child(coll)
	# if tilemap:
	# 	area.position = tilemap.position

	return area

### misc rectangle/cell helpers

static func get_width(coords: Array) -> int:
	var minx: int = U.min_of(coords, func(coord: Vector2i) -> int: return coord.x, 0)
	var maxx: int = U.max_of(coords, func(coord: Vector2i) -> int: return coord.x, 0)
	return maxx - minx + 1

static func get_height(coords: Array) -> int:
	var miny: int = U.min_of(coords, func(coord: Vector2i) -> int: return coord.y, 0)
	var maxy: int = U.max_of(coords, func(coord: Vector2i) -> int: return coord.y, 0)
	return maxy - miny + 1

static func get_recti(coords: Array) -> Rect2i:
	var minx: int = U.min_of(coords, func(coord: Vector2i) -> int: return coord.x, 0)
	var maxx: int = U.max_of(coords, func(coord: Vector2i) -> int: return coord.x, 0) + 1
	var miny: int = U.min_of(coords, func(coord: Vector2i) -> int: return coord.y, 0)
	var maxy: int = U.max_of(coords, func(coord: Vector2i) -> int: return coord.y, 0) + 1
	return Rect2i(Vector2i(minx, miny), Vector2i(maxx, maxy))

### Tilesets

static func disable_collisions(tilemap: TileMapLayer) -> void:
	var tileset := tilemap.get_tile_set()
	for i in range(tileset.get_physics_layers_count()):
		tileset.set_physics_layer_collision_layer(i, 0)
		tileset.set_physics_layer_collision_mask(i, 0)

static func disable_occlusion(tilemap: TileMapLayer) -> void:
	var tileset := tilemap.get_tile_set()
	for i in range(tileset.get_occlusion_layers_count()):
		tileset.set_occlusion_layer_light_mask(i, 0)

## destroy tiles w/ collision

static func destroy_tile_with_rid(tmap: TileMapLayer, rid: RID) -> bool:
	var coords := tmap.get_coords_for_body_rid(rid)
	if coords:
		var tile_data := tmap.get_cell_tile_data(coords)
		if tile_data:
			var mat := tile_data.material
			if mat is ShaderMaterial:
				(mat as ShaderMaterial).set_shader_parameter("offset", (mat as ShaderMaterial).get_shader_parameter("fade"))
			else:
				tmap.erase_cell(coords)
		else:
			tmap.erase_cell(coords)
		return true
	return false
