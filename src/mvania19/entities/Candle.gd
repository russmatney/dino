@tool
extends Area2D

@onready var light = $PointLight2D
@onready var anim = $AnimatedSprite2D
@onready var particles = $FlameParticles

#################################################################
# ready

func _ready():
	og_scale = light.texture_scale
	og_energy = light.energy

	if lit:
		light_up()
	else:
		put_out()
	$ColorRect.set_visible(false)

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


#################################################################
# actions

var lit = true

func light_up():
	lit = true
	anim.play("flicker")
	light.set_enabled(true)
	particles.set_emitting(true)
	light_tween()

func put_out():
	lit = false
	anim.play("off")
	light.set_enabled(false)
	particles.set_emitting(false)

var light_action = {label="Light", fn=light_up}
var put_out_action = {label="Put Out", fn=put_out}

func _on_body_entered(body):
	if body.is_in_group("player"):
		if lit:
			body.add_action(put_out_action)
		else:
			body.add_action(light_action)

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.remove_action(light_action)
		body.remove_action(put_out_action)

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
