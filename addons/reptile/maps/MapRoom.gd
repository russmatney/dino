tool
class_name MapRoom
extends Node2D

func prn(msg, msg2=null, msg3=null, msg4=null, msg5=null):
	var s = "[Room" + name + "] "
	if msg5:
		print(str(s, msg, msg2, msg3, msg4, msg5))
	elif msg4:
		print(str(s, msg, msg2, msg3, msg4))
	elif msg3:
		print(str(s, msg, msg2, msg3))
	elif msg2:
		print(str(s, msg, msg2))
	elif msg:
		print(str(s, msg))

var img

######################################################################
# name

export(String) var room_name = "Room" setget set_room_name

func set_room_name(n):
	room_name = n
	name = n

######################################################################
# dict setter

func set_data(opts):
	for k in opts.keys():
		match(k):
			"seed": self["n_seed"] = opts[k]
			_: self[k] = opts[k]

######################################################################
# ready

var groups

func _enter_tree():
	self.add_to_group("map_room")

var ready = false
func _ready():
	ready = true
	if position_offset:
		global_position += position_offset

	if not groups:
		find_groups()


func find_groups():
	groups = []
	for c in get_children():
		if c.is_in_group("map_group"):
			groups.append(c)

func set_groups(new_groups):
	for c in get_children():
		if c.is_in_group("map_group"):
			c.free()

	for g in new_groups:
		g.connect("tree_entered", g, "set_owner", [Util._or(owner, self)])
		g.name = "Group"
		add_child(g)
	groups = new_groups


######################################################################
# room geo

var position_offset = Vector2.ZERO

func width():
	return cell_size * img_size

func height():
	return cell_size * img_size

######################################################################
# noise and tile regen

export(bool) var regenerate_tilemaps setget do_tile_regen
func do_tile_regen(_v=null):
	if ready:
		# regen image with latest noise_inputs()
		img = ReptileMap.generate_image(noise_inputs())
		regen_tilemaps()

######################################################################
# noise inputs

export(int) var n_seed = 1001 setget set_seed
func set_seed(v):
	n_seed = v
	do_tile_regen()

export(int) var octaves = 4 setget set_octaves
func set_octaves(v):
	octaves = v
	do_tile_regen()

export(float) var period = 60.0 setget set_period
func set_period(v):
	period = v
	do_tile_regen()

export(float) var persistence = 0.5 setget set_persistence
func set_persistence(v):
	persistence = v
	do_tile_regen()

export(float) var lacunarity = 2.0 setget set_lacunarity
func set_lacunarity(v):
	lacunarity = v
	do_tile_regen()

export(int) var img_size = 50 setget set_img_size
func set_img_size(v):
	img_size = v
	do_tile_regen()


func noise_inputs():
	return {
		"seed": n_seed,
		"octaves": octaves,
		"period": period,
		"persistence": persistence,
		"lacunarity": lacunarity,
		"img_size": img_size,
		}

export(int) var cell_size = 64

#####################################################################
# coords

# return a group for the normed value, if one can be found.
# this may not be comprehensive, if we want to leave some empty tiles
func group_for_normed_val(normed):
	groups.sort_custom(MapGroup, "sort_by_key")
	for g in groups:
		if not g.upper_bound and not g.lower_bound:
			# no bounds? we assume it's this group then
			return g
		if g.contains_val(normed):
			return g

func to_coord_ctx(coord, img, stats):
	# this is called per coordinate
	# avoid expensive ops in here, things should be passed in
	var normed = ReptileMap.normalized_val(stats, img.get_pixel(coord.x, coord.y).r)
	var group = group_for_normed_val(normed)
	return CoordCtx.new(group, coord, normed, img)

func call_for_each_coord(img, obj, fname):
	img.lock()
	var stats = ReptileMap.img_stats(img)

	for coord in ReptileMap.all_coords(img):
		var ctx = to_coord_ctx(coord, img, stats)
		obj.call(fname, ctx)

######################################################################
# generate tilemaps

func init_tilemaps():
	for c in get_children():
		if c is TileMap:
			c.free()

	for group in groups:
		if group.tilemap_scene:
			var t = group.tilemap_scene.instance()
			var scale_by = cell_size / t.cell_size.x
			t.scale = Vector2(scale_by, scale_by)
			t.connect("tree_entered", t, "set_owner", [Util._or(owner, self)])
			add_child(t)
			group.tilemap = t

func add_tile_at_coord(ctx):
	if ctx.group:
		var t = ctx.group.tilemap
		if t and is_instance_valid(t):
			t.set_cell(ctx.coord.x, ctx.coord.y, 0)

func update_tilemaps():
	for gp in groups:
		if gp.tilemap:
			gp.tilemap.update_bitmask_region()

func groups_valid():
	for g in groups:
		if g.valid():
			return true
	prn("No valid group found")
	return false

func regen_tilemaps(image=null):
	if image:
		img = image
	if not img:
		img = ReptileMap.generate_image(noise_inputs())

	if not groups:
		prn("No groups, re-finding")
		find_groups()

	if not groups_valid():
		prn("Invalid groups config")
		return

	init_tilemaps()
	call_for_each_coord(img, self, "add_tile_at_coord")
	update_tilemaps()
