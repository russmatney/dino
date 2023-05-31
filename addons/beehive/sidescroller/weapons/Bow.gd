@tool
extends SSWeapon

var aim_vector
# TODO consider setting a location for the gun?
var arrow_position = Vector2.ZERO

func aim(aim: Vector2):
	aim_vector = aim

func activate():
	Debug.pr("activating", self)
	# TODO gun loading sound effect?
	DJZ.play(DJZ.S.laser)

func deactivate():
	pass

func use():
	fire()

func stop_using():
	stop_firing()

######################################################
# ready

func _on_animation_finished():
	pass

func _on_frame_changed():
	pass

######################################################
# fire

var firing = false

var arrow_scene = preload("res://addons/beehive/sidescroller/weapons/Arrow.tscn")
var arrow_impulse = 400
var fire_rate = 0.4
var arrow_knockback = 1

var fire_tween

func fire():
	firing = true

	if fire_tween and fire_tween.is_running():
		return

	fire_tween = create_tween()
	fire_arrow()
	fire_tween.set_loops(0)
	fire_tween.tween_callback(fire_arrow).set_delay(fire_rate)

func stop_firing():
	firing = false

	# kill tween after last arrow
	if fire_tween and fire_tween.is_running():
		fire_tween.kill()

func fire_arrow():
	if aim_vector == null:
		aim_vector = Vector2.RIGHT

	var arrow = arrow_scene.instantiate()
	arrow.position = arrow_position
	arrow.add_collision_exception_with(actor)

	Navi.current_scene.add_child.call_deferred(arrow)
	arrow.rotation = aim_vector.angle()
	arrow.apply_impulse(aim_vector * arrow_impulse, Vector2.ZERO)
	DJZ.play(DJZ.S.fire)

	# player push back when firing
	var pos = get_global_position()
	pos.x += -1 * aim_vector.x * arrow_knockback
	set_global_position(pos)
