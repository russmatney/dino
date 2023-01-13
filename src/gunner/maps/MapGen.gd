# MapGen
tool
extends Node2D

onready var TextureRect = $TextureRect

######################################################################
# ready

func _ready():
	if Engine.editor_hint:
		print("in editor, _ready(): ", Time.get_unix_time_from_system())

######################################################################
# triggers and inputs

export(bool) var trigger_image_regen setget do_image_regen
func do_image_regen(_val = null):
	print("doing regeneration: ", Time.get_unix_time_from_system())
	image_regen()

export(bool) var persist_latest setget do_persist_latest
func do_persist_latest(_val = null):
	print("persisting latest: ", Time.get_unix_time_from_system())
	# TODO impl
	# list files
	# filter by tmp_img_path prefix
	# write out persisted images (img and data?)

######################################################################
# setters

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


######################################################################
# regen

var temp_img_path = "res://src/gunner/maps/temp_"

func image_regen():
	if not octaves:
		print("[WARN] nil octaves.")
		return

	var noise = OpenSimplexNoise.new()

	noise.seed = n_seed
	noise.octaves = octaves
	noise.period = period
	noise.persistence = persistence
	noise.lacunarity = lacunarity

	var sample = noise.get_noise_2d(1.0, 1.0)
	print("sample: ", sample)

	var img = noise.get_seamless_image(img_size)
	var imgTexture = ImageTexture.new()
	imgTexture.create_from_image(img, 1)

	var p = temp_img_path + str(Time.get_unix_time_from_system()) + ".png"
	var res = img.save_png(p)
	if res == 0:
		TextureRect.texture = imgTexture

	img.lock()
	print("save res error: ", res)
	print("img: ", img)
	# print("img.data: ", img.data)
	# print("img.get_size: ", img.get_size())
	print("img.get_pixel: ", img.get_pixel(0, 0))
