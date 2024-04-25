@tool
class_name ReptileRoom
extends Node2D

var img

######################################################################
# ready


func _enter_tree():
	self.add_to_group("reptile_room", true)


var scene_ready


func _ready():
	scene_ready = true
	if position_offset:
		global_position += position_offset

	if not groups:
		find_groups()

	regenerated_tilemaps.connect(_on_regen)


func _on_regen():
	pass


func setup():
	set_noise_input()
	if not groups_valid():
		recreate_groups()


######################################################################
# tilemaps, cells helpers


func tilemaps(opts = {}):
	var tile_group_name = opts.get("group")
	var ts = []
	for c in get_children():
		if c is TileMap:
			if tile_group_name:
				if c.is_in_group(tile_group_name):
					ts.append(c)
			else:
				ts.append(c)
	return ts


func tilemap_cells(opts = {}):
	var cells = []
	for t in tilemaps(opts):
		for cell in t.get_used_cells(0):
			cells.append([t, cell])
	return cells


func cell_to_local_pos(t, cell):
	# assumes scaled in same x/y directions
	return t.map_to_local(cell) * t.scale.x + t.cell_size * t.scale.x / 2.0


func calc_rect():
	var rect = Rect2()
	for t in tilemaps():
		var rr = t.get_used_rect()
		var pos = t.map_to_local(rr.position) * t.scale.x
		var size = t.map_to_local(rr.size) * t.scale.x
		rect = rect.merge(Rect2(pos, size))
	return rect


func calc_rect_global():
	var r = calc_rect()
	r.position = to_global(r.position)
	return r


######################################################################
# name

@export var room_name: String = "Room" : set = set_room_name


func set_room_name(n):
	room_name = n
	name = n


######################################################################
# dict setter


func set_data(opts):
	for k in opts.keys():
		match k:
			"seed":
				self["n_seed"] = opts[k]
			_:
				self[k] = opts[k]


#####################################################################
## fallback group data

var cf_dark_tile = preload("res://addons/core/reptile/tilemaps/coldfire/ColdFireDark.tscn")
var cf_blue_tile = preload("res://addons/core/reptile/tilemaps/coldfire/ColdFireBlue.tscn")

var cf_dark = Color8(91, 118, 141)
var cf_blue = Color8(70, 66, 94)


func get_group_def():
	var options = [
		[
			[cf_blue, cf_blue_tile, 0.0, 0.4],
			[cf_dark, cf_dark_tile, 0.7, 1.0],
		],
	]

	var opts = []
	for group_opt in options:
		var grp_opt = []
		for data in group_opt:
			var grp = ReptileGroup.new()
			grp.setup(data[0], data[1], data[2], data[3])
			grp_opt.append(grp)
		opts.append(grp_opt)
	opts.shuffle()
	return opts[0]


func get_noise_input():
	var options = [
		{
			"seed": randf_range(0, 50000),
			"octaves": U.rand_of([2, 3, 4]),
			"frequency": 1/randf_range(5, 30),
			"persistence": randf_range(0.3, 0.7),
			"lacunarity": randf_range(2.0, 4.0),
			"img_size": randf_range(40, 60)
		}
	]
	options.shuffle()
	return options[0]


func set_noise_input():
	# overwrites default noise inputs with vals specified in get_noise_inputs
	var inp = get_noise_input()
	set_data(inp)


######################################################################
# groups

var groups


func find_groups():
	groups = []
	for c in get_children():
		if c.is_in_group("reptile_group"):
			groups.append(c)
	return groups


func clear_groups():
	for c in get_children():
		if c.is_in_group("reptile_group"):
			c.free()


func set_groups(new_groups):
	clear_groups()

	for g in new_groups:
		g.tree_entered.connect(g.set_owner.bind(U._or(owner, self)))
		g.name = "Group"
		add_child(g)
	groups = new_groups


func recreate_groups():
	clear_groups()

	var groups = get_group_def()
	for g in groups:
		add_child(g)
		g.set_owner(get_tree().edited_scene_root)


######################################################################
# room geo

var position_offset = Vector2.ZERO


func width():
	return cell_size * img_size


func height():
	return cell_size * img_size


######################################################################
# noise and tile regen

@export var regenerate_tilemaps: bool : set = do_tile_regen


func do_tile_regen(_v = null):
	if scene_ready:
		# regen image with latest noise_inputs
		img = Reptile.generate_image(noise_inputs())
		regen_tilemaps()


######################################################################
# noise inputs

@export var n_seed: int = 1001 : set = set_seed


func set_seed(v):
	n_seed = v
	do_tile_regen()


@export var octaves: int = 4 : set = set_octaves


func set_octaves(v):
	octaves = v
	do_tile_regen()


@export var period: float = 60.0 : set = set_period


func set_period(v):
	period = v
	do_tile_regen()

@export var frequency: float = 1.0/60.0 : set = set_frequency


func set_frequency(v):
	frequency = v
	do_tile_regen()

@export var persistence: float = 0.5 : set = set_persistence


func set_persistence(v):
	persistence = v
	do_tile_regen()


@export var lacunarity: float = 2.0 : set = set_lacunarity


func set_lacunarity(v):
	lacunarity = v
	do_tile_regen()


@export var img_size: int = 50 : set = set_img_size


func set_img_size(v):
	img_size = v
	do_tile_regen()


@export var img_flip_x: bool : set = set_img_flip_x


func set_img_flip_x(v):
	img_flip_x = v
	do_tile_regen()


@export var img_flip_y: bool : set = set_img_flip_y


func set_img_flip_y(v):
	img_flip_y = v
	do_tile_regen()


@export var img_rotate: bool : set = set_img_rotate


func set_img_rotate(v):
	img_rotate = v
	do_tile_regen()


func noise_inputs():
	return {
		"seed": n_seed,
		"octaves": octaves,
		"period": period,
		"frequency": frequency,
		"persistence": persistence,
		"lacunarity": lacunarity,
		"img_size": img_size,
	}


@export var cell_size: int = 64

#####################################################################
# coords


# return a group for the normed value, if one can be found.
# this may not be comprehensive, if we want to leave some empty tiles
func group_for_normed_val(normed):
	groups.sort_custom(Callable(ReptileGroup,"sort_by_key"))
	for g in groups:
		if not g.upper_bound and not g.lower_bound:
			# no bounds? we assume it's this group then
			return g
		if g.contains_val(normed):
			return g


func to_coord_ctx(coord, img, stats):
	# this is called per coordinate
	# avoid expensive ops in here, things should be passed in
	var normed = Reptile.normalized_val(stats, img.get_pixel(coord.x, coord.y).r)
	var group = group_for_normed_val(normed)
	return CoordCtx.new(group, coord, normed, img)


func call_for_each_coord(img, obj, fname):
	var stats = Reptile.img_stats(img)

	for coord in Reptile.all_coords(img):
		var ctx = to_coord_ctx(coord, img, stats)
		obj.call(fname, ctx)


######################################################################
# generate tilemaps


func init_tilemaps():
	for t in tilemaps():
		t.free()

	for group in groups:
		if group.tilemap_scene:
			var t = group.tilemap_scene.instantiate()
			var scale_by
			if t.tile_set:
				scale_by = cell_size / t.tile_set.tile_size.x
			else:
				scale_by = 1
			t.scale = Vector2(scale_by, scale_by)
			t.tree_entered.connect(t.set_owner.bind(U._or(owner, self)))
			add_child(t)
			group.tilemap = t


func add_tile_at_coord(ctx):
	if ctx.group:
		var t = ctx.group.tilemap
		if t and is_instance_valid(t):
			# restore random tile selector for godot 4 api
			# may want to support source_id/atlas_coords/alternative_tile
			# var t_ids = t.tile_set.get_tiles_ids()
			# t_ids.shuffle()
			# t.set_cell(0, Vector2(ctx.coord.x, ctx.coord.y), t_ids[0])
			t.set_cell(0, ctx.coord, 1)


func update_tilemaps():
	for gp in groups:
		if gp.tilemap:
			# gp.tilemap.update_bitmask_region()
			gp.tilemap.force_update()


func groups_valid():
	for g in groups:
		if g.valid():
			return true
	return false


signal regenerated_tilemaps


func regen_tilemaps(image = null, inputs=null):
	if inputs == null:
		inputs = noise_inputs()

	if image:
		img = image
	if not img:
		img = Reptile.generate_image(inputs)

	if img_flip_x:
		img.flip_x()
	if img_flip_y:
		img.flip_y()
	if img_rotate:
		img = Reptile.rotate(img)

	if groups == null or groups.size() == 0:
		Log.warn("No groups, re-finding")
		find_groups()

	if not groups_valid():
		Log.warn("Invalid groups config")
		return

	init_tilemaps()
	call_for_each_coord(img, self, "add_tile_at_coord")
	update_tilemaps()

	# regenerated_tilemaps.emit.call_deferred()
	regenerated_tilemaps.emit()
