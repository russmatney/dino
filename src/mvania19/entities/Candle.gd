@tool
extends Node2D

@onready var light = $PointLight2D
@onready var anim = $AnimatedSprite2D
@onready var particles = $FlameParticles
@onready var action_area = $ActionArea

var actions = [
	Action.mk({
		label="Light", fn=light_up,
		source_can_execute=func(): return not is_lit()}),
	Action.mk({
		label="Put Out", fn=put_out,
		source_can_execute=is_lit}),
	]

#################################################################
# ready

func _ready():
	og_scale = light.texture_scale
	og_energy = light.energy

	Hotel.register(self)

	$ColorRect.set_visible(false)

	action_area.register_actions(actions, self)

#################################################################
# persist/restore

func hotel_data():
	return {lit=lit}

func check_out(data):
	lit = data.get("lit", false)
	update_light()

#################################################################
# actions

@export var lit: bool = true :
	set(l):
		lit = l

func update_light():
	if lit:
		light_up()
	else:
		put_out()

func is_lit():
	return lit

func light_up():
	lit = true
	anim.play("flicker")
	light.set_enabled(true)
	particles.set_emitting(true)
	light_tween()
	Hotel.check_in(self)

func put_out():
	lit = false
	anim.play("off")
	light.set_enabled(false)
	particles.set_emitting(false)
	Hotel.check_in(self)

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
