@tool
extends RepTileMap

func _ready():
	ensure_pit_detectors()

###################################################################

func get_layers():
	var layers = []
	for i in range(get_layers_count()):
		layers.append({i=i, name=get_layer_name(i)})
	return layers

###################################################################
# used_cells clustering (move to Reptile.gd)

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

func build_connected_groups(cells, groups=[]):
	for c in cells:
		groups = update_connected_groups(c, groups)
	return groups

###################################################################
# create_pit_detector

var generated_group = "_generated"

func create_pit_detector(cells, layer):
	# create polygon

	# get points, not just cell centers
	var points = cells.map(func(c):
		# assumes square tiles
		var half_tile_size = tile_set.tile_size.x / 2 * Vector2.ONE
		var cell_center = to_global(map_to_local(c))
		return [
			cell_center + half_tile_size,
			cell_center - half_tile_size,
			cell_center + Vector2(-half_tile_size.x, half_tile_size.y),
			cell_center + Vector2(half_tile_size.x, -half_tile_size.y),
			]
		).reduce(func(agg, pts):
			agg.append_array(pts)
			return agg, [])

	# remove points found 4 times (internal points)
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

	Debug.pr(seen_points)
	Debug.pr(points)

	# sort cells according to angle to midpoint
	var mid = Util.average(points)
	# TODO not perfect for convex shapes, but pretty much right
	points.sort_custom(func (a,b):
		var a_ang = mid.angle_to_point(a)
		var b_ang = mid.angle_to_point(b)
		if a_ang == b_ang:
			return mid.distance_to(a) <= mid.distance_to(b)
		return a_ang >= b_ang)

	var polygon = PackedVector2Array()
	for p in points:
		polygon.append(p)

	var coll_polygon = CollisionPolygon2D.new()
	coll_polygon.polygon = polygon
	var area = Area2D.new()

	(func():
		owner.add_child(area)
		area.set_owner(owner)

		area.add_child(coll_polygon)
		coll_polygon.set_owner(owner)
		area.add_to_group(generated_group, true)
		).call_deferred()

	# TODO set collision mask
	# connect signals

###################################################################
# ensure_pit_detectors

func ensure_pit_detectors():
	Debug.pr("ensuring pit detectors")

	for c in owner.get_children():
		if c.is_in_group(generated_group):
			c.queue_free()

	for l in get_layers():
		var used_cells = get_used_cells(l.i)
		Debug.pr(l, "used_cells", used_cells)

		var connected_groups = build_connected_groups(used_cells)
		Debug.prn(l, "connected_groups", len(connected_groups))

		for cells in connected_groups:
			create_pit_detector(cells, l.i)
