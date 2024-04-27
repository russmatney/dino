extends SSWeapon

var aim_vector
var arrow_offset = Vector2.ONE * -12

func aim(aim_vec: Vector2):
	aim_vector = aim_vec

func activate():
	DJZ.play(DJZ.S.laser)
	if actor:
		actor.notif(self.name)

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

var arrow_scene = preload("res://src/dino/weapons/arrow/Arrow.tscn")
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
	arrow.position = global_position + arrow_offset
	arrow.add_collision_exception_with(actor)

	U.add_child_to_level(self, arrow)
	arrow.rotation = aim_vector.angle()
	arrow.apply_impulse(aim_vector * arrow_impulse, Vector2.ZERO)
	DJZ.play(DJZ.S.fire)

	# player push back when firing
	actor.global_position.x += -1 * aim_vector.x * arrow_knockback
