# MapGen
tool
extends Node2D

######################################################################
# ready

func _ready():
	if Engine.editor_hint:
		print("in editor, _ready(): ", Time.get_unix_time_from_system())

######################################################################
# triggers and inputs

export(bool) var regenerate_image setget do_image_regen
func do_image_regen(_val = null):
	print("doing regeneration: ", Time.get_unix_time_from_system())
	image_regen()

export(bool) var persist_latest setget do_persist_latest
func do_persist_latest(_val = null):
	print("persisting latest: ", Time.get_unix_time_from_system())
	print("inputs: ", inputs())
	persisted_imgs.push_front(temp_imgs[0])
	colorize_image()

export(bool) var generate_tilemap setget do_gen_tilemap
func do_gen_tilemap(_val = null):
	print("generating tilemap: ", Time.get_unix_time_from_system())
	print("bounds: ", bounds())
	gen_tilemap()

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
	$RawImage.texture = img_to_texture(img)

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
	colorize_image()

export(float) var middle_bound = 0.3 setget set_middle_bound
func set_middle_bound(v):
	middle_bound = v
	colorize_image()

export(float) var upper_bound = 0.8 setget set_upper_bound
func set_upper_bound(v):
	upper_bound = v
	colorize_image()

func bounds():
	return {"upper": upper_bound,
		"middle": middle_bound,
		"lower": lower_bound}

######################################################################
# colorize_image

func colorize_image():
	if not Engine.editor_hint:
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
				col = Color.darkseagreen
			elif normed >= lower_bound and normed < middle_bound:
				col = Color.aquamarine
			elif normed >= middle_bound and normed < upper_bound:
				col = Color.crimson
			elif normed >= upper_bound:
				col = Color.brown
			else:
				print("wut.")
			img.set_pixel(x, y, col)

	$ColorizedImage.texture = img_to_texture(img)

######################################################################
# tile map

func gen_tilemap():
	if not Engine.editor_hint:
		return
	var img = persisted_imgs[0].duplicate()
	img.convert(Image.FORMAT_RGBA8)
	img.lock()

	var stats = img_stats(img)
	print(stats)

	# TODO separate function/flag?
	$BasicTile.clear()
	$ShipTiles.clear()
	$IndoorBackgroundTiles.clear()

	for x in img.get_width():
		for y in img.get_height():
			var pix = img.get_pixel(x, y)
			var normed = normalized_val(stats, pix.r)

			if normed < lower_bound:
				$IndoorBackgroundTiles.set_cell(x, y, 0)
			elif normed >= lower_bound and normed < middle_bound:
				$ShipTiles.set_cell(x, y, 0)
			elif normed >= middle_bound and normed < upper_bound:
				$BasicTile.set_cell(x, y, 0)
			elif normed >= upper_bound:
				pass
			else:
				print("wut.")
	$IndoorBackgroundTiles.update_bitmask_region()
	$BasicTile.update_bitmask_region()
	$ShipTiles.update_bitmask_region()

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
