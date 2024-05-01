@tool
extends SSWeapon

var aim_vector
var bullet_offset = Vector2.ONE * -12

func aim(aim_vec: Vector2):
	aim_vector = aim_vec

func activate():
	if actor:
		actor.notif(self.name)
	Sounds.play(Sounds.S.laser)

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

var bullet_scene = preload("res://src/dino/weapons/bullet/Bullet.tscn")
var bullet_impulse = 800
var fire_rate = 0.2
var bullet_knockback = 3

var fire_tween

func fire():
	firing = true

	if fire_tween and fire_tween.is_running():
		return

	fire_tween = create_tween()
	fire_bullet()
	fire_tween.set_loops(0)
	fire_tween.tween_callback(fire_bullet).set_delay(fire_rate)

func stop_firing():
	firing = false

	# kill tween after last bullet
	if fire_tween and fire_tween.is_running():
		fire_tween.kill()

func fire_bullet():
	if aim_vector == null:
		aim_vector = Vector2.RIGHT

	var bullet = bullet_scene.instantiate()
	bullet.position = global_position + bullet_offset
	bullet.add_collision_exception_with(actor)

	U.add_child_to_level(self, bullet)
	bullet.rotation = aim_vector.angle()
	bullet.apply_impulse(aim_vector * bullet_impulse, Vector2.ZERO)
	Sounds.play(Sounds.S.fire)

	# player push back when firing
	actor.global_position.x += -1 * aim_vector.x * bullet_knockback
