@tool
extends Area2D

@onready var light = $PointLight2D
@onready var anim = $AnimatedSprite2D

#################################################################
# ready

func _ready():
	og_scale = light.texture_scale
	og_energy = light.energy

	light_up()
	$ColorRect.set_visible(false)

#################################################################
# actions

func light_up():
	anim.play("flicker")
	light.set_enabled(true)
	light_tween()

func put_out():
	anim.play("off")
	light.set_enabled(false)

#################################################################
# light tween

var t
var new_scale
var new_energy
var og_scale
var og_energy

func light_tween():
	var duration = 3.0
	var reset_duration = 2.0
	var new = 0.8

	# TODO how to use random values in a looping tween?
	# seems the tween caches the values
	if t:
		t.kill()

	t = create_tween().set_loops()
	t.tween_property(light, "texture_scale", new, duration)
	t.parallel().tween_property(light, "energy", new, duration)
	t.tween_property(light, "texture_scale", og_scale, reset_duration)
	t.parallel().tween_property(light, "energy", og_energy, reset_duration)

# func calc_new_light():
# 	new_scale = 0.3 + randf() * 0.5
# 	new_energy = 0.3 + randf() * 0.5
# 	print("new_scale: ", new_scale)
# 	print("new_energy: ", new_energy)

# func p():
# 	print("tween loop!")
# 	print(light.texture_scale)
# 	print(light.energy)
