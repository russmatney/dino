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

export(bool) var regenerate_image setget do_image_regen
func do_image_regen(_val = null):
	if ready:
		print("doing regeneration: ", Time.get_unix_time_from_system())
		print("inputs: ", inputs())
		image_regen()
		persisted_imgs.push_front(temp_imgs[0])
		colorize_image()
		gen_tilemap()

export(bool) var persist_tilemap setget do_persist_tilemap
func do_persist_tilemap(_val = null):
	print("persisting tilemap: ", Time.get_unix_time_from_system())
	print("bounds: ", bounds())
	print("inputs: ", inputs())
	persist_tilemap_to_disk()

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
		"ocatves": octaves,
		"period": period,
		"persistence": persistence,
		"lacunarity": lacunarity,
		"img_size": img_size,
		}

######################################################################
# regen

var temp_img_path = "res://src/gunner/maps/temp_"

var temp_imgs = []
var persisted_imgs = []

func image_regen():
	if not Engine.editor_hint:
		return
	if not octaves:
		print("[WARN] nil octaves...")
		return

	var noise = OpenSimplexNoise.new()
	noise.seed = n_seed
	noise.octaves = octaves
	noise.period = period
	noise.persistence = persistence
	noise.lacunarity = lacunarity

	var img = noise.get_seamless_image(img_size)
	var raw_image = get_node_or_null("RawImage")
	if raw_image:
		raw_image.texture = img_to_texture(img)

	temp_imgs.push_front(img)
	if temp_imgs.size() > 10:
		print("10 recents, popping back")
		temp_imgs.pop_back()

	print(str(temp_imgs.size()) + " temp_images")

	# var sample = noise.get_noise_2d(1.0, 1.0)
	# print("sample: ", sample)

	# img.lock()
	# print("img.data: ", img.data)
	# print("img.get_size: ", img.get_size())
	# print("img.get_pixel: ", img.get_pixel(0, 0))

	# var p = temp_img_path + str(Time.get_unix_time_from_system()) + ".png"
	# var res = img.save_png(p)

######################################################################
# bound inputs/triggers

export(float) var lower_bound = 0.3 setget set_lower_bound
func set_lower_bound(v):
	lower_bound = v
	if ready:
		colorize_image()
		gen_tilemap()

export(float) var middle_bound = 0.3 setget set_middle_bound
func set_middle_bound(v):
	middle_bound = v
	if ready:
		colorize_image()
		gen_tilemap()

export(float) var upper_bound = 0.8 setget set_upper_bound
func set_upper_bound(v):
	upper_bound = v
	if ready:
		colorize_image()
		gen_tilemap()

func bounds():
	return {"upper": upper_bound,
		"middle": middle_bound,
		"lower": lower_bound}

######################################################################
# colorize_image

export(Color) var color1 = Color.darkseagreen
export(Color) var color2 = Color.aquamarine
export(Color) var color3 = Color.crimson
export(Color) var color4 = Color.brown

func colorize_image():
	if not Engine.editor_hint:
		return

	if not persisted_imgs:
		print("No persisted_imgs, skipping colorize")
		return

	var img = persisted_imgs[0].duplicate()
	img.convert(Image.FORMAT_RGBA8)
	img.lock()

	var stats = img_stats(img)
	print(stats)

	for x in img.get_width():
		for y in img.get_height():
			var pix = img.get_pixel(x, y)
			var normed = normalized_val(stats, pix.r)
			var col
			if normed < lower_bound:
				col = color1
			elif normed >= lower_bound and normed < middle_bound:
				col = color2
			elif normed >= middle_bound and normed < upper_bound:
				col = color3
			elif normed >= upper_bound:
				col = color4
			else:
				print("wut.")
			img.set_pixel(x, y, col)

	$ColorizedImage.texture = img_to_texture(img)

######################################################################
# tile map

export(PackedScene) var tilemap1_scene
var tilemap1
export(PackedScene) var tilemap2_scene
var tilemap2
export(PackedScene) var tilemap3_scene
var tilemap3
export(PackedScene) var tilemap4_scene
var tilemap4

export(int) var target_cell_size = 64

func invalid_config():
	if not (tilemap1_scene or tilemap2_scene or tilemap3_scene or tilemap4_scene):
		print("No tilemap_scenes set, no tiles to add.")
		return true

func init_tile(tilemap, tilemap_scene):
	if tilemap_scene:
		var t = tilemap_scene.instance()
		var scale_by = target_cell_size / t.cell_size.x
		t.scale = Vector2(scale_by, scale_by)
		$Map.add_child(t)
		return t

func update_autotile(tilemap):
	if tilemap:
		tilemap.update_bitmask_region()

func init_tiles():
	for c in $Map.get_children():
		c.queue_free()

	tilemap1 = init_tile(tilemap1, tilemap1_scene)
	tilemap2 = init_tile(tilemap2, tilemap2_scene)
	tilemap3 = init_tile(tilemap3, tilemap3_scene)
	tilemap4 = init_tile(tilemap4, tilemap4_scene)

func update_autotiles():
	update_autotile(tilemap1)
	update_autotile(tilemap2)
	update_autotile(tilemap3)
	update_autotile(tilemap4)

func gen_tilemap():
	if not Engine.editor_hint:
		return

	if invalid_config():
		print("Invalid config")

	if not persisted_imgs:
		print("No persisted_imgs, skipping gen_tilemap")
		return

	var img = persisted_imgs[0].duplicate()
	img.convert(Image.FORMAT_RGBA8)
	img.lock()

	var stats = img_stats(img)
	print(stats)

	init_tiles()

	print("tilemap 2: ", tilemap2)

	for x in img.get_width():
		for y in img.get_height():
			var pix = img.get_pixel(x, y)
			var normed = normalized_val(stats, pix.r)

			if normed < lower_bound:
				if tilemap1 and is_instance_valid(tilemap1):
					tilemap1.set_cell(x, y, 0)
			elif normed >= lower_bound and normed < middle_bound:
				# print("should set on tilemap 2", tilemap2)
				if tilemap2 and is_instance_valid(tilemap2):
					# print("setting on tilemap 2")
					tilemap2.set_cell(x, y, 0)
				else:
					pass
					# print("nope!")
			elif normed >= middle_bound and normed < upper_bound:
				if tilemap3 and is_instance_valid(tilemap3):
					tilemap3.set_cell(x, y, 0)
			elif normed >= upper_bound:
				if tilemap4 and is_instance_valid(tilemap4):
					tilemap4.set_cell(x, y, 0)
			else:
				print("wut.")

	update_autotiles()

######################################################################
# persist map as resource

export(String) var persist_dir = "res://addons/reptile/maps/"
export(String) var persist_name = "Map"
export(bool) var name_with_time = true

func persist_tilemap_to_disk():
	if not Engine.editor_hint:
		return

	if not persisted_imgs:
		print("No persisted_imgs, skipping persist")
		return

	if not $Map.get_children():
		print("$Map has no children, skipping persist")

	print("map: ", $Map)
	for c in $Map.get_children():
		c.set_owner($Map)
		print("c owner: ", c.owner)

	var scene = PackedScene.new()
	var result = scene.pack($Map)
	if result == OK:
		var path = str(persist_dir, persist_name)
		if name_with_time:
			path = path + str(Time.get_unix_time_from_system())
		path = path + ".tscn"
		var error = ResourceSaver.save(path, scene)
		if error != OK:
			push_error("Error while saving Map")
			print("E: ", error)
		else:
			print("Successfully saved new map: ", path)


######################################################################
# helpers

func img_to_texture(img):
	var imgTexture = ImageTexture.new()
	imgTexture.create_from_image(img, 1)
	return imgTexture

func img_stats(img):
	var vals = []
	var stats = {"min": 1, "max": 0}
	for x in img.get_width():
		for y in img.get_height():
			var pix = img.get_pixel(x, y)
			var val = pix.r
			if val < stats["min"]:
				stats["min"] = val
			if val > stats["max"]:
				stats["max"] = val
			vals.append(pix.r)
	stats["variance"] = stats["max"] - stats["min"]
	# stats["vals"] = vals
	return stats

func normalized_val(stats, val):
	val = val - stats["min"]
	return val / stats["variance"]
