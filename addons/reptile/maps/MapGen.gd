# MapGen
tool
extends Node2D
class_name MapGen

######################################################################
# ready

var ready = false

func _ready():
	if Engine.editor_hint:
		print("in editor, _ready(): ", Time.get_time_string_from_system())
		ready = true

func p_script_vars():
	for prop in get_property_list():
		if "usage" in prop and prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			print("\t", prop["name"], ": ", self.get(prop["name"]))

######################################################################
# triggers and inputs

# these behind 'ready' guards to avoid errors in the editor (upon opening)
export(bool) var generate_image setget do_image_regen
func do_image_regen(_val = null):
	if ready:
		print("\n[MapGen] Image Regen: ", Time.get_time_string_from_system())
		image_regen()

func do_image_reprocess():
	if ready:
		image_reprocess()

var the_img
func image_regen():
	groups = build_groups()
	the_img = ReptileMap.generate_image(inputs())
	var raw_image = get_node_or_null("RawImage")
	if raw_image:
		raw_image.texture = ReptileMap.img_to_texture(the_img)

	do_image_reprocess()


func print_data():
	print("[MapGen] bounds: ", bounds())
	print("[MapGen] inputs: ", inputs())
	print("[MapGen] groups: ", groups)

func image_reprocess():
	if the_img:
		groups = build_groups()

		if not groups_valid():
			print("Invalid groups config")
			return

		print("new tilemap: ", Time.get_time_string_from_system())
		print_data()

		colorize_image(the_img)
		gen_tilemaps(the_img)

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

class MapGroup:
	extends Object

	export(int) var bound
	export(Color) var color
	export(PackedScene) var tilemap_scene
	var tilemap

	func _init(b=null, c=null, ts=null):
		bound = b
		color = c
		tilemap_scene = ts

	func _to_string():
		return "\n[tiles: " + str(tilemap_scene) + "]\t[bound: " + str(bound) + "]\t[color: " + str(color) + "]"

	static func sort_by_key(a, b):
		if not a.bound:
			return false
		if a.bound <= Util._or(b.bound, 1.1):
			return true
		return false


# TODO type hint for editor arbitrary groups in the editor in 4.0 (or if it gets backported)
# https://github.com/godotengine/godot-proposals/issues/18
export(Array) var group_list = []


# bound inputs/triggers

export(float) var boundA = 0.3 setget set_boundA
func set_boundA(v):
	boundA = v
	do_image_reprocess()

export(float) var boundB = 0.55 setget set_boundB
func set_boundB(v):
	boundB = v
	do_image_reprocess()

export(float) var boundC = 0.8 setget set_boundC
func set_boundC(v):
	boundC = v
	do_image_reprocess()

export(float) var boundD = 1.0 setget set_boundD
func set_boundD(v):
	boundD = v
	do_image_reprocess()

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
		MapGroup.new(boundA, colorA, tilemapA_scene),
		MapGroup.new(boundB, colorB, tilemapB_scene),
		MapGroup.new(boundC, colorC, tilemapC_scene),
		MapGroup.new(boundD, colorD, tilemapD_scene),
	]

func groups_valid():
	# TODO add validation for bounds
	for mg in groups:
		if mg.tilemap_scene:
			return true

	print("[MapGen] No tilemap_scenes set, no tiles to add.")
	return false


func bounds():
	var bds = []
	groups.sort_custom(MapGroup, "sort_by_key")
	for mg in groups:
		bds.append(mg.bound)
	return bds

# return a group for the normed value, if one can be found.
# this may not be comprehensive, if we want to leave some empty tiles
func group_for_normed_val(normed):
	groups.sort_custom(MapGroup, "sort_by_key")
	for g in groups:
		if not g.bound:
			# no bound? we must be past the bounds, let's return
			return g

		if normed < g.bound:
			# we fit here
			return g

class CoordCtx:
	var group: MapGroup
	var coord: Vector2
	var normed: float
	var img: Image

	func _init(g=null, c=null, n=null, i=null):
		group = g
		coord = c
		normed = n
		img = i

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
			print("[MapGen] [WARN] colorize_coord ctx without img")
			return
		ctx.img.set_pixel(ctx.coord.x, ctx.coord.y, ctx.group.color)

func colorize_image(img):
	# copy this image b/c we're about to mutate it
	var n = Image.new()
	n.copy_from(img)
	n.convert(Image.FORMAT_RGBA8)
	n.lock()
	call_with_coord_context(n, self, "colorize_coord")
	$ColorizedImage.texture = ReptileMap.img_to_texture(n)

######################################################################
# generate tilemap

export(int) var target_cell_size = 64
export(NodePath) var gen_node_path = "Map"

func owner_or_self():
	if owner:
		return owner
	else:
		return self

func init_tilemaps(parent_node):
	print("[MapGen] initing tilemaps at parent_node: ", parent_node)
	# do we need to return the updated tilemap anywhere?
	for c in parent_node.get_children():
		c.queue_free()

	for group in groups:
		if group.tilemap_scene:
			var t = group.tilemap_scene.instance()
			var scale_by = target_cell_size / t.cell_size.x
			t.scale = Vector2(scale_by, scale_by)
			t.connect("tree_entered", t, "set_owner", [owner_or_self()])
			parent_node.add_child(t)
			group.tilemap = t

	print("[MapGen] Tile maps initialized")
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
		print("[MapGen] persisting tilemap: ", Time.get_time_string_from_system())
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
		print("[MapGen] " + persist_node_path + " has no children, skipping persist")
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
			print("E: ", error)
		else:
			print("[MapGen] Successfully saved new map: ", path)
