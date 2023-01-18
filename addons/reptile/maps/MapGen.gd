# MapGen
tool
extends Node2D
class_name MapGen

func prn(msg, msg2=null, msg3=null, msg4=null, msg5=null):
	var s = "[MapGen] "
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

func print_data():
	prn(str("Inputs: ", inputs()))
	prn(str("Groups: ", groups))
	prn(str("Bounds: ", bounds()))
	prn(str("Image size: ", img_size))
	prn(str("Gen Node: ", gen_node_path, " ", gen_node_position))

######################################################################
# ready

var ready = false

func _ready():
	if Engine.editor_hint:
		prn(str("ready: ", Time.get_time_string_from_system()))
		ready = true

func p_script_vars():
	for prop in get_property_list():
		if "usage" in prop and prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			print("\t", prop["name"], ": ", self.get(prop["name"]))

var room_data
func init_room_data(room_data={}):
	# Not great, but avoids regen-ing the image whenever this runs
	var old_ready = ready
	ready = false
	call_deferred("set", "ready", old_ready)

	room_data = room_data
	prn("setting room data: ", room_data)
	for k in room_data.keys():
		match(k):
			"seed": self["n_seed"] = room_data[k]
			"groups": self["group_list"] = room_data[k]
			_: self[k] = room_data[k]

######################################################################
# triggers and inputs

# these behind 'ready' guards to avoid errors in the editor (upon opening)
export(bool) var generate_image setget do_image_regen
func do_image_regen(_val = null):
	if ready:
		print("-------------------")
		prn(str("Image Regen: ", Time.get_time_string_from_system()))
		regenerate_image()

func width():
	return cell_size * img_size

func height():
	return cell_size * img_size

func ensure_image_node(name, i=0, img=null):
	var texture_rect = get_node_or_null(name)
	if not texture_rect:

		texture_rect = TextureRect.new()
		add_child(texture_rect)
		texture_rect.set_owner(owner_or_self())
		texture_rect.name = name

	texture_rect.rect_size = Vector2(width()/2, height()/2)
	texture_rect.rect_position = Vector2(-width()/2, height()*i/2)
	texture_rect.expand = true

	if img:
		texture_rect.texture = ReptileMap.img_to_texture(img)

func regenerate_image(img=null):
	groups = build_groups()
	if not img:
		img = ReptileMap.generate_image(inputs())

	if include_images:
		ensure_image_node("RawImage", 0, img)

	image_reprocess(img)

export(bool) var include_images = true

func image_reprocess(img):
	groups = build_groups()

	if not groups_valid():
		prn("Invalid groups config")
		return

	prn(str("New Tilemap: ", Time.get_time_string_from_system()))
	print_data()

	if include_images:
		colorize_image(img)
	gen_tilemaps(img)


export(NodePath) var gen_node_path = "Map"

export(bool) var clear_node setget do_clear_node
func do_clear_node(_v):
	if ready:
		prn(str("Clearing node: ", gen_node_path))
		var node = get_node_or_null(gen_node_path)
		if node:
			node.queue_free()

		prn(str("Clearing all children: ", gen_node_path))
		for c in get_children():
			c.queue_free()


######################################################################
# image gen setters

export(int) var n_seed = 1 setget set_seed
func set_seed(v):
	n_seed = v
	do_image_regen()

export(int) var octaves = 3 setget set_octaves
func set_octaves(v):
	octaves = v
	do_image_regen()

export(float) var period = 60.0 setget set_period
func set_period(v):
	period = v
	do_image_regen()

export(float) var persistence = 0.5 setget set_persistence
func set_persistence(v):
	persistence = v
	do_image_regen()

export(float) var lacunarity = 2.0 setget set_lacunarity
func set_lacunarity(v):
	lacunarity = v
	do_image_regen()

export(int) var img_size = 20 setget set_img_size
func set_img_size(v):
	img_size = v
	do_image_regen()

func inputs():
	return {
		"seed": n_seed,
		"octaves": octaves,
		"period": period,
		"persistence": persistence,
		"lacunarity": lacunarity,
		"img_size": img_size,
		}

######################################################################
# groups

export(Array) var group_list = []

# bound inputs/triggers

export(float) var boundA = 0.3 setget set_boundA
func set_boundA(v):
	boundA = v
	do_image_regen()

export(float) var boundB = 0.55 setget set_boundB
func set_boundB(v):
	boundB = v
	do_image_regen()

export(float) var boundC = 0.8 setget set_boundC
func set_boundC(v):
	boundC = v
	do_image_regen()

export(float) var boundD = 1.0 setget set_boundD
func set_boundD(v):
	boundD = v
	do_image_regen()

# colors

export(Color) var colorA = Color.darkseagreen
export(Color) var colorB = Color.aquamarine
export(Color) var colorC = Color.crimson
export(Color) var colorD = Color.brown

# tilemap scene

export(PackedScene) var tilemapA_scene
export(PackedScene) var tilemapB_scene
export(PackedScene) var tilemapC_scene
export(PackedScene) var tilemapD_scene

# TODO refactor into an arbitrary number of groups
var groups
func build_groups():
	if group_list:
		return group_list

	return [
		MapGroup.new(colorA, tilemapA_scene, 0.0, boundA),
		MapGroup.new(colorB, tilemapB_scene, boundA, boundB),
		MapGroup.new(colorC, tilemapC_scene, boundB, boundC),
		MapGroup.new(colorD, tilemapD_scene, boundC, boundD),
	]

func groups_valid():
	# TODO add validation for bounds
	for mg in groups:
		if mg.tilemap_scene:
			return true

	prn("No tilemap_scenes set, no tiles to add.")
	return false

# only used to print the bounds
func bounds():
	var bds = []
	groups.sort_custom(MapGroup, "sort_by_key")
	for mg in groups:
		bds.append([mg.lower_bound, mg.upper_bound])
	return bds

# return a group for the normed value, if one can be found.
# this may not be comprehensive, if we want to leave some empty tiles
func group_for_normed_val(normed):
	groups.sort_custom(MapGroup, "sort_by_key")
	for g in groups:
		if not g.upper_bound and not g.lower_bound:
			# no bounds? we assume it's this group then
			return g

		if normed <= g.upper_bound and normed >= g.lower_bound:
			return g

func to_coord_ctx(coord, img, stats):
	# this is called per coordinate
	# avoid expensive ops in here, things should be passed in
	var normed = ReptileMap.normalized_val(stats, img.get_pixel(coord.x, coord.y).r)
	var group = group_for_normed_val(normed)
	return CoordCtx.new(group, coord, normed, img)

#####################################################################
# coords

func call_with_coord_context(img, obj, fname):
	var stats = ReptileMap.img_stats(img)

	for coord in ReptileMap.all_coords(img):
		var ctx = to_coord_ctx(coord, img, stats)
		obj.call(fname, ctx)

######################################################################
# colorize_image

func colorize_coord(ctx):
	if ctx.group:
		if not ctx.img:
			prn("[WARN] colorize_coord ctx without img")
			return
		ctx.img.set_pixel(ctx.coord.x, ctx.coord.y, ctx.group.color)

func colorize_image(img):
	# copy this image b/c we're about to mutate it
	var n = Image.new()
	n.copy_from(img)
	n.convert(Image.FORMAT_RGBA8)
	n.lock()
	call_with_coord_context(n, self, "colorize_coord")
	ensure_image_node("ColorizedImage", 1, n)

######################################################################
# generate tilemap

export(int) var cell_size = 64

func owner_or_self():
	if owner:
		return owner
	else:
		return self

func init_tilemaps(parent_node):
	prn(str("Initializing tilemaps at parent_node: ", parent_node))

	for c in parent_node.get_children():
		c.free()

	for group in groups:
		if group.tilemap_scene:
			var t = group.tilemap_scene.instance()
			var scale_by = cell_size / t.cell_size.x
			t.scale = Vector2(scale_by, scale_by)
			t.connect("tree_entered", t, "set_owner", [owner_or_self()])
			parent_node.add_child(t)
			group.tilemap = t

	prn("Tile maps initialized")
	parent_node.print_tree_pretty()


func add_tile_at_coord(ctx):
	if ctx.group:
		var t = ctx.group.tilemap
		if t and is_instance_valid(t):
			t.set_cell(ctx.coord.x, ctx.coord.y, 0)

func update_tilemaps():
	for gp in groups:
		if gp.tilemap:
			gp.tilemap.update_bitmask_region()


func node_name_from_path(path):
	var parts = path.split("/")
	return parts[-1]

var gen_node_position = Vector2.ZERO

# maybe we want this per-group instead of that being baked in?
# as impled it runs once for every x/y
func gen_tilemaps(img):
	var parent_node = get_node_or_null(gen_node_path)
	if not parent_node:
		parent_node = Node2D.new()
		parent_node.name = node_name_from_path(gen_node_path)

		# support adding to this node or a parent if one exists
		# TODO support following the gen_node_path "../SomeOtherNode/MyNode"?
		var o = owner_or_self()
		o.add_child(parent_node)
		parent_node.set_owner(o)

	prn(str("setting parent global position: ", gen_node_position))
	parent_node.global_position = gen_node_position

	# feeling like i should pass groups into these rather than rely on this node's state
	# but maybe that's long dead
	init_tilemaps(parent_node)
	img.lock()
	call_with_coord_context(img, self, "add_tile_at_coord")
	update_tilemaps()

######################################################################
# persist map as resource

export(bool) var persist_tilemap setget do_persist_tilemap
func do_persist_tilemap(_val = null):
	if ready:
		prn(str("persisting tilemap: ", Time.get_time_string_from_system()))
		print_data()
		persist_tilemap_to_disk()

export(String) var persist_node_path = "Map"
export(String) var persist_name = persist_node_path
export(String) var persist_dir = "res://addons/reptile/maps/"
export(bool) var version_number = true
export(String) var hardcoded_version_number

func persist_tilemap_to_disk():
	if not Engine.editor_hint:
		return

	var node = get_node(persist_node_path)
	if not node:
		push_error(str("No node found for node_path: ", persist_node_path))

	if not node.get_children():
		prn(str(persist_node_path + " has no children, skipping persist"))
		return

	for c in node.get_children():
		c.set_owner(node)

	var scene = PackedScene.new()
	var result = scene.pack(node)
	if result == OK:
		var path = str(persist_dir, persist_name)
		if hardcoded_version_number:
			path = path + hardcoded_version_number
		elif version_number:
			path = path + str(Time.get_unix_time_from_system())
		path = path + ".tscn"
		var error = ResourceSaver.save(path, scene)
		if error != OK:
			push_error("Error while saving Map")
			prn(str("E: ", error))
		else:
			prn(str("Successfully saved new map: ", path))
