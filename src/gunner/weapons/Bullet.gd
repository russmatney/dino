extends RigidBody2D

var ttl = 5

func _process(delta):
	ttl -= delta
	if ttl <= 0:
		kill()

func kill():
	if is_instance_valid(self):
		queue_free()

func _on_Bullet_body_entered(_body:Node):
	kill()
