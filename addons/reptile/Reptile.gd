@tool
# Reptile
extends Node

func _ready():
	Debug.prn("Reptile autoload ready")

######################################################################
# generate random image

# var temp_img_path = "res://addons/reptile/generated/temp_"
# var p = temp_img_path + str(Time.get_unix_time_from_system()) + ".png"
# var res = img.save_png(p)

# REPTILE.generate_image({:seed 1337})
func generate_image(inputs):
	# validating inputs
	if not "octaves" in inputs:
		Debug.pr("[WARN] nil octaves...")
		return

	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.seed = inputs["seed"]
	noise.fractal_octaves = inputs["octaves"]
	noise.fractal_lacunarity = inputs["lacunarity"]
	noise.fractal_gain = inputs.get("gain", inputs.get("persistence"))
	noise.frequency = inputs.get("frequency", 1.0 / inputs.get("period", 20.0))

	# TODO may want to use normalize here to simplify the stats bit?
	return noise.get_seamless_image(inputs["img_size"], inputs["img_size"])


######################################################################
# img helpers


func all_coords(img):
	var coords = []
	for x in img.get_width():
		for y in img.get_height():
			coords.append(Vector2(x, y))
	return coords


func rotate(img):
	false # img.lock() # TODOConverter40, Image no longer requires locking, `false` helps to not break one line if/else, so it can freely be removed
	var new_img = Image.new()
	new_img.copy_from(img)
	false # new_img.lock() # TODOConverter40, Image no longer requires locking, `false` helps to not break one line if/else, so it can freely be removed
	for coord in all_coords(img):
		new_img.set_pixel(coord.y, coord.x, img.get_pixelv(coord))
	return new_img


######################################################################
# img stats


func img_stats(img):
	var vals = []
	var stats = {"min": 1, "max": 0}
	for x in img.get_width():
		for y in img.get_height():
			var pix = img.get_pixel(x, y)
			var val = pix.r
			if val < stats["min"]:
				stats["min"] = val
			if val > stats["max"]:
				stats["max"] = val
			vals.append(pix.r)
	stats["variance"] = stats["max"] - stats["min"]
	# stats["vals"] = vals
	return stats


func normalized_val(stats, val):
	val = val - stats["min"]
	return val / stats["variance"]


## tilemap/cell helpers #####################################################################

func get_layers(tilemap):
	var layers = []
	for i in range(tilemap.get_layers_count()):
		# TODO could add more layer data to get layers as dicts here
		layers.append({i=i, name=tilemap.get_layer_name(i)})
	return layers


func valid_neighbors(tilemap, cell, layer=0):
	var nbr_coords = tilemap.get_surrounding_cells(cell)
	return nbr_coords.filter(func(coord):
		return -1 != tilemap.get_cell_source_id(layer, coord))

# Does not check if either cell is valid, only checks that they are neighboring coordinates
func is_neighbor(cell_a, cell_b):
	if cell_a.x == cell_b.x:
		if abs(cell_a.y - cell_b.y) == 1:
			return true
	if cell_a.y == cell_b.y:
		if abs(cell_a.x - cell_b.x) == 1:
			return true

func group_has_neighbor(group, cell):
	# gen neighbors for cell, check if any in group
	for g_cell in group:
		if is_neighbor(cell, g_cell):
			return true

func split_connected_groups(cell, groups):
	var connected = []
	var disconnected = []
	# should be able to filter out groups before checking every cell here, maybe with a stored min/max
	for g in groups:
		var is_neighbor = group_has_neighbor(g, cell)
		if is_neighbor:
			connected.append(g)
		else:
			disconnected.append(g)
	return {connected=connected, disconnected=disconnected}

func update_connected_groups(cell, groups):
	var split = split_connected_groups(cell, groups)
	var disconnected_groups = split.disconnected
	var new_group = [cell]
	for g in split.connected:
		# combine connected groups
		new_group.append_array(g)
	disconnected_groups.append(new_group)
	return disconnected_groups

# Given a list of coords from get_used_cells, returns lists of coords
# grouped by connectivity - i.e. the clusters of connected tiles.
func build_connected_groups(cells, groups=[]):
	for c in cells:
		groups = update_connected_groups(c, groups)
	return groups

# Returns coords grouped by adjacency - connected cells will be in the same group.
# TODO maybe we want to include or group by layers, or expose a layer filter?
func cell_clusters(tilemap):
	var clusters = []
	for l in get_layers(tilemap):
		var used_cells = tilemap.get_used_cells(l.i)
		var connected_groups = build_connected_groups(used_cells)
		clusters.append_array(connected_groups)
	return clusters

func cells_to_polygon(tilemap, cells):
	# get points from cell coordinates
	var points = cells.map(func(c):
		# assumes square tiles
		var half_tile_size = tilemap.tile_set.tile_size.x / 2 * Vector2.ONE
		var cell_center = tilemap.to_global(tilemap.map_to_local(c))
		return [
			cell_center + half_tile_size,
			cell_center - half_tile_size,
			cell_center + Vector2(-half_tile_size.x, half_tile_size.y),
			cell_center + Vector2(half_tile_size.x, -half_tile_size.y),
			]
		).reduce(func(agg, pts):
			agg.append_array(pts)
			return agg, [])

	# remove points found 4 times (these are all internal points)
	var seen_points = {}
	for p in points:
		if p in seen_points:
			seen_points[p] += 1
		else:
			seen_points[p] = 1
	points = []
	for p in seen_points:
		if seen_points[p] < 4:
			points.append(p)

	# sort cells according to angle to midpoint
	# NOTE not a perfect algo for convex shapes
	var mid = Util.average(points)
	points.sort_custom(func (a,b):
		var a_ang = mid.angle_to_point(a)
		var b_ang = mid.angle_to_point(b)
		var diff_ang = abs(a_ang - b_ang)
		if diff_ang <= 0.05:
			return mid.distance_to(a) <= mid.distance_to(b)
		return a_ang >= b_ang)

	var polygon = PackedVector2Array()
	for p in points:
		polygon.append(p)

	return polygon
