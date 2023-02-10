# Reptile
extends Node

######################################################################
# generate random image

# var temp_img_path = "res://addons/reptile/generated/temp_"
# var p = temp_img_path + str(Time.get_unix_time_from_system()) + ".png"
# var res = img.save_png(p)

# REPTILE.generate_image({:seed 1337})
func generate_image(inputs):
	# validating inputs
	if not "octaves" in inputs:
		print("[WARN] nil octaves...")
		return

	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.seed = inputs["seed"]
	noise.fractal_octaves = inputs["octaves"]
	noise.fractal_lacunarity = inputs["lacunarity"]
	noise.fractal_gain = inputs.get("gain", inputs.get("persistence"))
	noise.frequency = inputs.get("frequency", 1.0 / inputs.get("period", 20.0))

	# TODO may want to use normalize here to simplify the stats bit?
	return noise.get_seamless_image(inputs["img_size"], inputs["img_size"])


######################################################################
# img helpers


func all_coords(img):
	var coords = []
	for x in img.get_width():
		for y in img.get_height():
			coords.append(Vector2(x, y))
	return coords


func rotate(img):
	false # img.lock() # TODOConverter40, Image no longer requires locking, `false` helps to not break one line if/else, so it can freely be removed
	var new_img = Image.new()
	new_img.copy_from(img)
	false # new_img.lock() # TODOConverter40, Image no longer requires locking, `false` helps to not break one line if/else, so it can freely be removed
	for coord in all_coords(img):
		new_img.set_pixel(coord.y, coord.x, img.get_pixelv(coord))
	return new_img


func img_to_texture(img):
	var imgTexture = ImageTexture.new()
	imgTexture.create_from_image(img) #,1
	return imgTexture


######################################################################
# img stats


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


######################################################################
# tilemap/cell helpers


func all_neighbors(cell):
	return [
		Vector2(cell.x, cell.y),
		Vector2(cell.x + 1, cell.y),
		Vector2(cell.x - 1, cell.y),
		Vector2(cell.x, cell.y - 1),
		Vector2(cell.x + 1, cell.y - 1),
		Vector2(cell.x - 1, cell.y - 1),
		Vector2(cell.x, cell.y + 1),
		Vector2(cell.x + 1, cell.y + 1),
		Vector2(cell.x - 1, cell.y + 1),
	]


func valid_neighbors(tilemap, cell):
	var nbrs = all_neighbors(cell)
	var valid = []
	for n in nbrs:
		if tilemap.get_cell_tile_data(0, n):
			valid.append(n)
	return valid
