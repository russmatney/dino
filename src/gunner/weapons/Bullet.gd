extends RigidBody2D

onready var pop = $Pop
onready var anim = $AnimatedSprite

var ttl = 5


func _process(delta):
	ttl -= delta
	if ttl <= 0:
		queue_free()


func kill():
	Cam.screenshake({"amplitude": 1, "variance": 1, "duration": 0.05, "loops": 2})
	Gunner.play_sound("bullet_pop")
	anim.set_visible(false)
	pop.set_visible(true)

	yield(get_tree().create_timer(0.1), "timeout")
	if is_instance_valid(self):
		queue_free()


func _on_Bullet_body_entered(_body: Node):
	kill()
