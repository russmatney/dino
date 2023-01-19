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
	prn("Inputs: ", noise_inputs())
	prn("Image size: ", img_size)
	prn("Room Node: ", room_node_path)

######################################################################
# ready

var ready = false

func _ready():
	if Engine.editor_hint:
		ready = true

######################################################################
# triggers

export(bool) var ready_override = false

# these behind 'ready' guards to avoid errors in the editor (upon opening)
export(bool) var generate_image setget do_image_regen
func do_image_regen(_val = null):
	if ready or ready_override:
		print("-------------------")
		print_data()
		regenerate_image()

export(bool) var include_images = true

func regenerate_image():
	var room = Util._or(owner, self).get_node_or_null(room_node_path)
	if not room:
		room = MapRoom.new()
		room.room_name = Util.node_name_from_path(room_node_path)

		var o = Util._or(owner, self)
		o.add_child(room)
		room.set_owner(o)

	room.set_data(noise_inputs())
	room.set_groups(default_groups())
	room.regen_tilemaps()

export(NodePath) var room_node_path = "Map"

export(bool) var clear setget do_clear
func do_clear(_v):
	if ready:
		prn("Clear")
		var node = get_node_or_null(room_node_path)
		if node:
			node.queue_free()

		for c in self.get_children():
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

func noise_inputs():
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

func default_groups():
	var group_data = [
		[colorA, tilemapA_scene, 0.0, boundA],
		[colorB, tilemapB_scene, boundA, boundB],
		[colorC, tilemapC_scene, boundB, boundC],
		[colorD, tilemapD_scene, boundC, boundD],
	]
	var gps = []
	for data in group_data:
		var g = MapGroup.new()
		g.setup(data[0], data[1], data[2], data[3])
		gps.append(g)
	return gps

######################################################################
# colorize_image

# func ensure_image_node(name, i=0, img=null):
# 	var texture_rect = get_node_or_null(name)
# 	if not texture_rect:
# 		texture_rect = TextureRect.new()
# 		add_child(texture_rect)
# 		texture_rect.set_owner(Util._or(owner, self))
# 		texture_rect.name = name

# 	var w = 3200
# 	var h = 3200
# 	texture_rect.rect_size = Vector2(w/2, h/2)
# 	texture_rect.rect_position = Vector2(-w/2, h*i/2)
# 	texture_rect.expand = true

# 	if img:
# 		texture_rect.texture = ReptileMap.img_to_texture(img)


# func colorize_coord(ctx):
# 	if ctx.group:
# 		if not ctx.img:
# 			prn("[WARN] colorize_coord ctx without img")
# 			return
# 		ctx.img.set_pixel(ctx.coord.x, ctx.coord.y, ctx.group.color)

# func colorize_image(img):
# 	# copy this image b/c we're about to mutate it
# 	var n = Image.new()
# 	n.copy_from(img)
# 	n.convert(Image.FORMAT_RGBA8)
# 	n.lock()
# 	call_with_coord_context(n, self, "colorize_coord")
# 	ensure_image_node("ColorizedImage", 1, n)

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
