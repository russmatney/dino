extends RigidBody2D

@onready var pop = $Pop
@onready var anim = $AnimatedSprite2D

var ttl = 3
var dying = false


func _process(delta):
	ttl -= delta
	if ttl <= 0:
		kill()


signal bullet_dying(bullet)


func kill():
	emit_signal("bullet_dying", self)
	# no need to run more than once (if we contact multiple objs)
	if not dying:
		dying = true
		Cam.screenshake(0.1)
		GunnerSounds.play_sound("bullet_pop")
		anim.set_visible(false)
		pop.set_visible(true)

		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(self):
			queue_free()


func _on_Bullet_body_entered(body: Node):
	kill()

	if body.is_in_group("darktile"):
		body.hit(global_position)
	elif body.is_in_group("enemy_robots") and not body.dead:
		body.take_damage(self, 1)
	elif body.is_in_group("player") and not body.dead:
		body.take_damage(self, 1)
