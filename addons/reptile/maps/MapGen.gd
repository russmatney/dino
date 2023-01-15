# MapGen
tool
extends Node2D

######################################################################
# ready

var ready = false

func _ready():
	if Engine.editor_hint:
		print("in editor, _ready(): ", Time.get_unix_time_from_system())
		ready = true

######################################################################
# triggers and inputs

var the_img

export(bool) var generate_image setget do_image_regen
func do_image_regen(_val = null):
	if ready:
		print("generating new image: ", Time.get_unix_time_from_system())

		groups = build_groups()
		the_img = ReptileMap.generate_image(inputs())
		var raw_image = get_node_or_null("RawImage")
		if raw_image:
			raw_image.texture = ReptileMap.img_to_texture(the_img)

		do_image_reprocess()

func do_image_reprocess():
	if ready and the_img:
		if not groups_valid():
			print("Invalid groups config")
			return

		print("new tilemap: ", Time.get_unix_time_from_system())
		print("bounds: ", bounds())
		print("inputs: ", inputs())
		print("groups: ", groups)

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

# TODO move Group to a type and support defining it via the UI
# consider whether it's easier to create in-editor ui components to do this instead
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
	return [{
	"tilemap": null,
	"tilemap_scene": tilemapA_scene,
	"color": colorA,
	"bound": boundA,
	},
	{
		"tilemap": null,
		"tilemap_scene": tilemapB_scene,
		"color": colorB,
		"bound": boundB,
		},
	{
		"tilemap": null,
		"tilemap_scene": tilemapC_scene,
		"color": colorC,
		"bound": boundC,
		},
	{
		"tilemap": null,
		"tilemap_scene": tilemapD_scene,
		"color": colorD
		},
	]

class GroupsSort:
	static func sort_by_key(a, b):
		if not "bound" in a:
			return false
		if a["bound"] <= b.get("bound", 1.1):
			return true
		return false

	func sort(xs):
		xs.sort_custom(self, "sort_by_key")
		return xs

func bounds():
	var bds = []
	groups.sort_custom(GroupsSort, "sort_by_key")
	for gp in groups:
		bds.append(gp.get("bound"))
	return bds

func group_for_normed_val(normed):
	var group_name

	groups.sort_custom(GroupsSort, "sort_by_key")
	for g in groups:
		if not "bound" in g:
			# no bound? we must be past the bounds, let's return
			return g

		if normed < g["bound"]:
			# we fit here
			return g
	# this should be comprehensive ^
	print("[WARN] No group found for normed val: ", normed, " ", groups)

func groups_valid():
	# TODO add validation for bounds

	for gp in groups:
		if "tilemap_scene" in gp and gp["tilemap_scene"]:
			return true

	print("No tilemap_scenes set, no tiles to add.")
	return false

func to_ctx(coord, img, stats):
	# this is called per coordinate
	# avoid expensive ops in here, things should be passed in
	var normed = ReptileMap.normalized_val(stats, img.get_pixel(coord.x, coord.y).r)
	var group = group_for_normed_val(normed)
	var dupe = group.duplicate()
	dupe.merge({
		"x": coord.x,
		"y": coord.y,
		"normed": normed,
		"img": img,
		})
	return dupe

#####################################################################
# coords

func call_with_group_context(img, obj, fname):
	var stats = ReptileMap.img_stats(img)

	for coord in ReptileMap.all_coords(img):
		var ctx = to_ctx(coord, img, stats)
		obj.call(fname, coord, ctx)

######################################################################
# colorize_image

func colorize_coord(coord, ctx):
	if not "img" in ctx:
		print("[WARN] colorize_coord ctx without img")
		return
	ctx["img"].set_pixel(coord.x, coord.y, ctx["color"])

func colorize_image(img):
	# copy this image b/c we're about to mutate it
	var n = Image.new()
	n.copy_from(img)
	n.convert(Image.FORMAT_RGBA8)
	n.lock()
	call_with_group_context(n, self, "colorize_coord")
	$ColorizedImage.texture = ReptileMap.img_to_texture(n)

######################################################################
# generate tilemap

export(int) var target_cell_size = 64
export(String) var gen_node_path = "Map"

func init_tilemaps(parent_node):
	print("initing tilemaps at parent_node: ", parent_node)
	# do we need to return the updated tilemap anywhere?
	for c in parent_node.get_children():
		c.queue_free()

	for group in groups:
		if group["tilemap_scene"]:
			var t = group["tilemap_scene"].instance()
			var scale_by = target_cell_size / t.cell_size.x
			t.scale = Vector2(scale_by, scale_by)
			t.connect("tree_entered", t, "set_owner", [self])
			parent_node.add_child(t)
			group["tilemap"] = t

func add_tile_at_coord(coord, ctx):
	var t
	if "tilemap" in ctx and ctx["tilemap"]:
		t = ctx["tilemap"]
	if t and is_instance_valid(t):
		t.set_cell(coord.x, coord.y, 0)

func update_tilemaps():
	for val in groups:
		if val["tilemap"]:
			val["tilemap"].update_bitmask_region()


# maybe we want this per-group instead of that being baked in?
# as impled it runs once for every x/y
func gen_tilemaps(img):
	if not get_node(gen_node_path) and get_node(gen_node_path):
		print("No node at " + gen_node_path)
		return

	# feeling like i should pass groups into these rather than rely on this node's state
	# but maybe that's long dead
	init_tilemaps(get_node(gen_node_path))
	img.lock()
	call_with_group_context(img, self, "add_tile_at_coord")
	update_tilemaps()

######################################################################
# persist map as resource

export(bool) var persist_tilemap setget do_persist_tilemap
func do_persist_tilemap(_val = null):
	print("persisting tilemap: ", Time.get_unix_time_from_system())
	print("bounds: ", bounds())
	print("inputs: ", inputs())
	print("groups: ", groups)
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
		print(persist_node_path + " has no children, skipping persist")
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
			print("Successfully saved new map: ", path)

