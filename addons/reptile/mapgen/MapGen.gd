# MapGen
@tool
extends Node2D
class_name MapGen


func prn(msg, msg2 = null, msg3 = null, msg4 = null, msg5 = null):
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


######################################################################
# ready

var ready = false


func _ready():
	if Engine.is_editor_hint():
		ready = true


######################################################################
# triggers

@export var ready_override: bool = false

# these behind 'ready' guards to avoid errors in the editor (upon opening)
@export var generate_image: bool : set = do_image_regen


func do_image_regen(_val = null):
	if ready or ready_override:
		print("-------------------")
		regenerate_image()


func regenerate_image():
	var room = Util._or(owner, self).get_node_or_null(room_node_path)
	if not room:
		room = ReptileRoom.new()
		var o = Util._or(owner, self)
		o.add_child(room)
		room.set_owner(o)

	room.set_room_name(Util.node_name_from_path(room_node_path))
	room.set_groups(default_groups())
	room.regen_tilemaps()


@export var room_node_path: String = "Map"

@export var clear: bool : set = do_clear


func do_clear(_v):
	if ready:
		prn("Clear")
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

# func ensure_image_node(name, i=0, img=null):
# 	var texture_rect = get_node_or_null(name)
# 	if not texture_rect:
# 		texture_rect = TextureRect.new()
# 		add_child(texture_rect)
# 		texture_rect.set_owner(Util._or(owner, self))
# 		texture_rect.name = name

# 	var w = 3200
# 	var h = 3200
# 	texture_rect.size = Vector2(w/2, h/2)
# 	texture_rect.position = Vector2(-w/2, h*i/2)
# 	texture_rect.expand = true

# 	if img:
# 		texture_rect.texture = Reptile.img_to_texture(img)

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
# 	false # n.lock() # TODOConverter40, Image no longer requires locking, `false` helps to not break one line if/else, so it can freely be removed
# 	call_with_coord_context(n, self, "colorize_coord")
# 	ensure_image_node("ColorizedImage", 1, n)

######################################################################
# persist map as resource

@export var persist_tilemap: bool : set = do_persist_tilemap


func do_persist_tilemap(_val = null):
	if ready:
		prn(str("persisting tilemap: ", Time.get_time_string_from_system()))
		persist_tilemap_to_disk()


@export var persist_node_path: NodePath = "Map"
@export var persist_name: String = str(persist_node_path)
@export var persist_dir: String = "res://addons/reptile/maps/"
@export var version_number: bool = true
@export var hardcoded_version_number: String


func persist_tilemap_to_disk():
	if not Engine.is_editor_hint():
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
