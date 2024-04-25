# MapGen
@tool
extends Node2D
class_name MapGen


######################################################################
# ready

var scene_ready = false


func _ready():
	if Engine.is_editor_hint():
		scene_ready = true


######################################################################
# triggers

@export var ready_override: bool = false

# these behind 'ready' guards to avoid errors in the editor (upon opening)
@export var generate_image: bool : set = do_image_regen


func do_image_regen(_val = null):
	if scene_ready or ready_override:
		print("-------------------")
		regenerate_image()


func regenerate_image():
	var room = U._or(owner, self).get_node_or_null(room_node_path)
	if not room:
		room = ReptileRoom.new()
		var o = U._or(owner, self)
		o.add_child(room)
		room.set_owner(o)

	room.set_room_name(U.node_name_from_path(room_node_path))
	room.set_groups(default_groups())
	randomize()
	room.regen_tilemaps(null, {
			"seed": randf_range(0, 500000),
			"octaves": U.rand_of([2, 3, 4]),
			"frequency": 1/randf_range(5, 30),
			"persistence": randf_range(0.3, 0.7),
			"lacunarity": randf_range(2.0, 4.0),
			"img_size": randf_range(40, 60)
		})

	colorize_image(room.img)


@export var room_node_path: String = "Map"

@export var clear: bool : set = do_clear


func do_clear(_v):
	if scene_ready:
		var node = get_node_or_null(room_node_path)
		if node:
			node.queue_free()

		for c in self.get_children():
			c.queue_free()

######################################################################
# groups

@export var tilemapA_scene: PackedScene
@export var tilemapB_scene: PackedScene
@export var tilemapC_scene: PackedScene
@export var tilemapD_scene: PackedScene


func default_groups():
	var group_data = [
		[Color.DARK_SEA_GREEN, tilemapA_scene, 0.0, 0.3],
		[Color.AQUAMARINE, tilemapB_scene, 0.3, 0.55],
		[Color.CRIMSON, tilemapC_scene, 0.55, 0.8],
		[Color.BROWN, tilemapD_scene, 0.8, 1.0],
	]
	var gps = []
	for data in group_data:
		var g = ReptileGroup.new()
		g.setup(data[0], data[1], data[2], data[3])
		gps.append(g)
	return gps


######################################################################
# colorize_image

# return a group for the normed value, if one can be found.
# this may not be comprehensive, if we want to leave some empty tiles
func group_for_normed_val(normed):
	var groups = default_groups()
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

func ensure_image_node(name, i=0, img=null):
	var texture_rect = get_node_or_null(name)
	if not texture_rect:
		texture_rect = TextureRect.new()
		add_child(texture_rect)
		texture_rect.set_owner(U._or(owner, self))
		texture_rect.name = name

	var w = 3200
	var h = 3200
	texture_rect.size = Vector2(w/2, h/2)
	texture_rect.position = Vector2(-w/2, h*i/2)
	texture_rect.expand = true

	if img:
		var img_texture = ImageTexture.create_from_image(img)
		# img_texture.set_size_override(Vector2(w/2, h/2))
		texture_rect.texture = img_texture

func colorize_coord(ctx):
	if ctx.group:
		if not ctx.img:
			Log.warn("colorize_coord ctx without img")
			return
		ctx.img.set_pixel(ctx.coord.x, ctx.coord.y, ctx.group.color)

func colorize_image(img):
	# copy this image b/c we're about to mutate it
	var n = Image.new()
	n.copy_from(img)
	n.convert(Image.FORMAT_RGBA8)
	call_for_each_coord(n, self, "colorize_coord")
	ensure_image_node("ColorizedImage", 1, n)

######################################################################
# persist map as resource

@export var persist_tilemap: bool : set = do_persist_tilemap


func do_persist_tilemap(_val = null):
	if scene_ready:
		Log.info("persisting tilemap: ", Time.get_time_string_from_system())
		persist_tilemap_to_disk()


@export var persist_node_path: NodePath = "Map"
@export var persist_name: String = str(persist_node_path)
@export var persist_dir: String = "res://addons/core/reptile/maps/"
@export var version_number: bool = true
@export var hardcoded_version_number: String


func persist_tilemap_to_disk():
	if not Engine.is_editor_hint():
		return

	var node = get_node(persist_node_path)
	if not node:
		push_error(str("No node found for node_path: ", persist_node_path))

	if not node.get_children().size():
		Log.warn(persist_node_path, " has no children, skipping persist")
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
		var error = ResourceSaver.save(scene, path)
		if error != OK:
			Log.error(error)
		else:
			Log.info("Successfully saved new map: ", path)
