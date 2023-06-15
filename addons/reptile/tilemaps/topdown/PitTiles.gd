@tool
extends RepTileMap

func _ready():
	ensure_pit_detectors()

func get_layers():
	var layers = []
	for i in range(get_layers_count()):
		layers.append({i=i, name=get_layer_name(i)})
	return layers

func is_neighbor(cell_a, cell_b):
	if cell_a.x == cell_b.x:
		if abs(cell_a.y - cell_b.y) == 1:
			return true
	if cell_a.y == cell_b.y:
		if abs(cell_a.x - cell_b.x) == 1:
			return true

func split_connected_groups(cell, groups):
	var connected = []
	var disconnected = []
	for g in groups:
		var found_neighbor
		for g_cell in g:
			if is_neighbor(cell, g_cell):
				found_neighbor = true
				break
		if found_neighbor:
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
		Debug.pr("updated_connected_groups:", len(groups))
	return groups

func ensure_pit_detectors():
	Debug.pr("ensuring pit detectors")

	# for every tile create a small area 2d
	# if connected, merge them together (along the way)

	for l in get_layers():
		var used_cells = get_used_cells(0)
		Debug.pr(l, "used_cells", used_cells)

		var connected_groups = build_connected_groups(used_cells)
		Debug.prn(l, "connected_groups", connected_groups)
