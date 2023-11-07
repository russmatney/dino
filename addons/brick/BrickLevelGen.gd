@tool
extends Node2D
class_name BrickLevelGen

################################################################################
## static ######################################################################

static func generate_level(opts: Dictionary) -> Dictionary:
	Util.ensure_default(opts, "seed", 1)
	Util.ensure_default(opts, "tile_size", 16)

	# parse once
	var parsed_room_defs = RoomParser.parse({
		room_defs_path=opts.get("room_defs_path"),
		contents=opts.get("contents"),
		})

	# set seed
	seed(opts.seed)

	# get room opts
	var get_room_opts = opts.get("get_room_opts", BrickLevelGen.default_room_opts)
	var room_opts = get_room_opts.call(opts)
	for room_opt in room_opts:
		room_opt.merge(opts) # merge tile_size and other passed opts
		room_opt.merge({parsed_room_defs=parsed_room_defs,})
	if room_opts == null:
		Debug.warn("No room_opts returned from get_room_opts, nothing to generate")
		return {}

	# create the rooms
	var rooms = BrickRoom.create_rooms(room_opts)

	var room_idx = 0
	for r in rooms:
		r.name = "Room_%s" % room_idx
		room_idx += 1

	# combine tilemaps
	var res = BrickLevelGen.combine_tilemaps(rooms, room_opts)
	var tilemaps = res[0]

	# collect entities from tilemaps
	var entities = res[1]

	# add normal entities
	for room in rooms:
		for ent in room.entities:
			entities.append(ent)

	if "label_to_entity" in opts:
		for label in opts.label_to_entity:
			var ent_opts = opts.label_to_entity[label]
			if "find_entity" in ent_opts and "setup_with_entities" in ent_opts:
				var ent = ent_opts.find_entity.call(entities)
				if ent != null:
					entities = ent_opts.setup_with_entities.call(ent, entities)

	# build update dict
	var data = {
		seed=opts.seed,
		rooms=rooms,
		entities=entities,
		tilemaps=tilemaps,
		}

	return data

static func default_room_opts(opts):
	var room_opts = []
	for i in range(opts.room_count):
		room_opts.append({})
	return room_opts

## combine tilemaps ######################################################################

static func combine_tilemaps(rooms, room_opts):
	var label_to_tilemap = room_opts[0].label_to_tilemap

	var tmaps = []
	var entities = []
	for label in label_to_tilemap:
		var res = BrickLevelGen.combine_tilemap(rooms, label, label_to_tilemap[label])
		if res[0]:
			tmaps.append(res[0])
		entities.append_array(res[1])

	return [tmaps, entities]

# converts a coord in a room's tilemap to a coord in the 'combined' passed tilemap
static func room_tilemap_coord_to_new_tilemap_coord(room, room_tilemap, coord, tilemap):
	var new_pos = room_tilemap.map_to_local(coord) + (room.position / room_tilemap.scale) + room_tilemap.position
	return tilemap.local_to_map(new_pos)

static func combine_tilemap(rooms, label, opts):
	var add_borders = opts.get("add_borders")
	var border_depth = opts.get("border_depth", {})
	if border_depth is int and border_depth > 0:
		border_depth = {"up"=border_depth, "down"=border_depth, "left"=border_depth, "right"=border_depth}
		add_borders = true
	var scene = opts.get("scene", load("res://addons/reptile/tilemaps/MetalTiles8.tscn"))
	var tilemap = scene.instantiate()

	var entities = []

	var room_tilemap = func(room):
		return room.tilemaps.get(label)

	var is_scale_set = false

	var room_rects = []
	for r in rooms:
		var tmap = room_tilemap.call(r)
		if tmap == null:
			continue

		# set tilemap scale
		if not is_scale_set:
			tilemap.scale = tmap.scale
			is_scale_set = true

		# collect rects
		if add_borders:
			var rect = tmap.get_used_rect()
			rect.position = tmap.local_to_map(r.position / tmap.scale + tmap.position)
			room_rects.append(rect)

	var new_cell_coords = []
	var border_cells = []

	for r in rooms:
		var tmap = room_tilemap.call(r)
		if tmap == null:
			continue

		new_cell_coords.append_array(tmap.get_used_cells(0).map(func(coord):
			return BrickLevelGen.room_tilemap_coord_to_new_tilemap_coord(r, tmap, coord, tilemap)))

		if add_borders:
			# add border coords that don't overlap room_rects
			# NOTE assumes rooms are rectangles until this function gets more nuanced
			var border_coords = Reptile.all_tilemap_border_coords(tmap)
			for c in border_coords:
				var coord = BrickLevelGen.room_tilemap_coord_to_new_tilemap_coord(r, tmap, c, tilemap)
				var overlaps = false
				for rect in room_rects:
					if rect.has_point(coord):
						overlaps = true
						break
				if not overlaps:
					border_cells.append(coord)

		# this clean up might not be necessary
		r.remove_child(tmap)
		tmap.queue_free()

	if add_borders:
		new_cell_coords.append_array(border_cells)

	tilemap.set_cells_terrain_connect(0, new_cell_coords, 0, 0)
	tilemap.force_update()

	if add_borders:
		var depth_cells = []
		var rect = tilemap.get_used_rect()

		for side in border_depth:
			var depth = border_depth[side]
			var border_rect = Rect2i()
			match side:
				"up":
					border_rect.position = Vector2i(rect.position.x, rect.position.y + depth * Vector2.UP.y)
					border_rect.end = Vector2i(rect.position.x + rect.size.x - 1, rect.position.y)
				"down":
					border_rect.position = Vector2i(rect.position.x, rect.position.y + rect.size.y)
					border_rect.end = Vector2i(rect.position.x + rect.size.x - 1, rect.position.y + rect.size.y + depth * Vector2.DOWN.y)
				"left":
					border_rect.position = Vector2i(rect.position.x + depth * Vector2.LEFT.x, rect.position.y)
					border_rect.end = Vector2i(rect.position.x, rect.position.y + rect.size.y - 1)
				"right":
					border_rect.position = Vector2i(rect.position.x + rect.size.x, rect.position.y)
					border_rect.end = Vector2i(rect.position.x + rect.size.x + depth * Vector2.RIGHT.x, rect.position.y + rect.size.y - 1)

			var b_cells = Reptile.cells_in_rect(border_rect)
			Debug.pr("border cells for rect", border_rect, b_cells, side, depth)

			# TODO fill internal border gaps
			# TODO reduce the iterations to one loop?
			# TODO fill 'corners'
			depth_cells.append_array(b_cells)

		new_cell_coords.append_array(depth_cells)
		tilemap.set_cells_terrain_connect(0, new_cell_coords, 0, 0)
		tilemap.force_update()

	if "setup" in opts:
		opts.setup.call(tilemap)
	if "to_entities" in opts:
		entities = opts.to_entities.call(tilemap)
		tilemap = null

	return [tilemap, entities]

################################################################################
## instance ######################################################################

## signals ######################################################################

signal new_data_generated(data: Dictionary)

## vars/triggers ######################################################################

@export var run_gen: bool:
	set(v):
		if v and Engine.is_editor_hint():
			generate()

@export var _seed: int
@export var gen_with_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			_seed = randi()
			generate()

@export var tile_size = 16
@export var room_count = 5
@export_file var room_defs_path

@export var entities_node: Node2D
@export var tilemaps_node: Node2D
@export var rooms_node: Node2D
@export var show_color_rect: bool

## generate ######################################################################

func generate():
	var opts = {
		seed=_seed,
		tile_size=tile_size,
		room_count=room_count,
		room_defs_path=room_defs_path,
		show_color_rect=show_color_rect,
		}
	if self.has_method("get_room_opts"):
		opts["get_room_opts"] = self.get_room_opts

	var data = BrickLevelGen.generate_level(opts)

	(func():
		# created in this order to get entities on top (last)
		if not rooms_node:
			rooms_node = Node2D.new()
			rooms_node.name = "Rooms"
			get_parent().add_child(rooms_node)
			rooms_node.set_owner(get_owner())
		if not tilemaps_node:
			tilemaps_node = Node2D.new()
			tilemaps_node.name = "Tilemaps"
			get_parent().add_child(tilemaps_node)
			tilemaps_node.set_owner(get_owner())
		if not entities_node:
			entities_node = Node2D.new()
			entities_node.name = "Entities"
			get_parent().add_child(entities_node)
			entities_node.set_owner(get_owner())

		entities_node.get_children().map(func(c): c.queue_free())
		for node in data.entities:
			var had_parent
			if node.get_parent():
				had_parent = true
				node.reparent(entities_node, true)
			else:
				# entities from tilemaps have no parent yet
				entities_node.add_child(node)
			node.set_owner(self.get_owner())
			if not had_parent:
				# maybe want an explicit opt-in to this - had_parent might not be the right flag
				for ch in node.get_children():
					ch.set_owner(self.get_owner())
					for cch in ch.get_children():
						cch.set_owner(self.get_owner())

		if tilemaps_node:
			tilemaps_node.get_children().map(func(c): c.queue_free())
			for node in data.tilemaps:
				tilemaps_node.add_child(node)
				node.set_owner(self.get_owner())

		if rooms_node:
			rooms_node.get_children().map(func(c): c.queue_free())
			for node in data.rooms:
				rooms_node.add_child(node)
				node.set_owner(self.get_owner())
				for ch in node.get_children():
					ch.set_owner(self.get_owner())
					# how deep must we go?
					for cch in ch.get_children():
						cch.set_owner(self.get_owner())

		Debug.pr("new data gend with seed", [data.seed], data.keys())
		new_data_generated.emit(data)

		).call_deferred()
