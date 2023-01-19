# ReptileMap
tool
extends Node


func _ready():
	print("<ReptileMap> ready")


######################################################################
# generate random image

# var temp_img_path = "res://addons/reptile/generated/temp_"
# var p = temp_img_path + str(Time.get_unix_time_from_system()) + ".png"
# var res = img.save_png(p)

func generate_image(inputs):
	# validating inputs
	if not "octaves" in inputs:
		print("[WARN] nil octaves...")
		return

	var noise = OpenSimplexNoise.new()
	noise.seed = inputs["seed"]
	noise.octaves = inputs["octaves"]
	noise.period = inputs["period"]
	noise.persistence = inputs["persistence"]
	noise.lacunarity = inputs["lacunarity"]

	return noise.get_seamless_image(inputs["img_size"])

######################################################################
# img helpers

func all_coords(img):
	var coords = []
	for x in img.get_width():
		for y in img.get_height():
			coords.append(Vector2(x, y))
	return coords

func img_to_texture(img):
	var imgTexture = ImageTexture.new()
	imgTexture.create_from_image(img, 1)
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
