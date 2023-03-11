@tool
extends Node2D

@onready var light = $PointLight2D
@onready var anim = $AnimatedSprite2D
@onready var particles = $FlameParticles
@onready var action_area = $ActionArea
@onready var spawn_point = $PlayerSpawnPoint

var actions = [
	Action.mk({
		label="Light", fn=light_up,
		source_can_execute=func(): return not is_lit()}),
	# Action.mk({
	# 	label="Put Out", fn=put_out,
	# 	source_can_execute=is_lit}),
	Action.mk({
		label="Sit", fn=sit,
		source_can_execute=func(): return is_lit() and not sitting}),
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

var sat_count = 0

func hotel_data():
	return {lit=lit, sat_count=sat_count}

func check_out(data):
	lit = data.get("lit", false)
	sat_count = data.get("sat_count", sat_count)
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

	# marks spawn point active
	spawn_point.sat_at()

func put_out():
	lit = false
	anim.play("off")
	light.set_enabled(false)
	particles.set_emitting(false)
	Hotel.check_in(self)

var sitting
func sit():
	sitting = true
	sat_count += 1
	Hotel.check_in(self)

	# TODO some _sit_ animation + glow when healing
	# using this to lock player controls for a bit
	MvaniaGame.set_forced_movement_target(global_position)
	var heal_t = create_tween()
	heal_t.set_loops(3)
	heal_t.tween_callback(MvaniaGame.player.heal.bind({health=1})).set_delay(1)
	await get_tree().create_timer(3.4).timeout
	put_out()
	MvaniaGame.clear_forced_movement_target()
	sitting = false

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

	if t:
		t.kill()

	t = create_tween().set_loops()
	t.tween_property(light, "texture_scale", new, duration)
	t.parallel().tween_property(light, "energy", new, duration)
	t.tween_property(light, "texture_scale", og_scale, reset_duration)
	t.parallel().tween_property(light, "energy", og_energy, reset_duration)
